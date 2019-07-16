provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.site_name}-site-logs"
  acl = "log-delivery-write"
}
resource "aws_s3_bucket" "www_site" {
  bucket = "www.${var.site_name}"
  logging {
    target_bucket = "${aws_s3_bucket.logs.bucket}"
    target_prefix = "www.${var.site_name}/"
  }
  website {
    index_document = "index.html"
  }
 
  depends_on = [aws_s3_bucket.logs, aws_cloudfront_origin_access_identity.origin_access_identity]
}

resource "aws_s3_bucket" "apex" {
  bucket = "${var.site_name}"
  website {
    redirect_all_requests_to = "https://www.${var.site_name}"
  }
}

resource "aws_s3_bucket_policy" "www_site" {
  bucket = "${aws_s3_bucket.www_site.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OnlyCloudfrontReadAccess",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
      },
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.www_site.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "apex" {
  bucket = "${aws_s3_bucket.apex.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
	    "Sid": "PublicReadGetObject",
      "Effect": "Allow",
	    "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.apex.arn}/*"]
    }
  ]
}
POLICY
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}
resource "aws_cloudfront_distribution" "website_cdn" {
  enabled      = true
  price_class  = "PriceClass_200"
  http_version = "http1.1"
  aliases = ["www.${var.site_name}"]
  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.www_site.id}"
    domain_name = "www.${var.site_name}.s3.eu-west-1.amazonaws.com"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.www_site.id}"
    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400
    // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "${var.ssl_certificate_arn}"
    ssl_support_method       = "sni-only"
  }
  logging_config {
    bucket = "${aws_s3_bucket.logs.bucket_domain_name}"
    prefix = "website_cdn"
  }
}

resource "aws_cloudfront_distribution" "apex_cdn" {
  enabled      = true
  price_class  = "PriceClass_100"
  http_version = "http1.1"
  aliases = ["${var.site_name}"]
  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.apex.id}"
    domain_name = "${var.site_name}.s3-website-eu-west-1.amazonaws.com"

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy = "http-only"
      origin_read_timeout = "30"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.apex.id}"
    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400
    // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  default_root_object = "index.html"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "${var.ssl_certificate_arn}"
    ssl_support_method       = "sni-only"
  }
  logging_config {
    bucket = "${aws_s3_bucket.logs.bucket_domain_name}"
    prefix = "apex_cdn"
  }
}

resource "aws_route53_record" "www_site" {
  zone_id = "${var.route_53_zone_id}"
  name = "www.${var.site_name}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.website_cdn.domain_name}"
    zone_id  = "${aws_cloudfront_distribution.website_cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  zone_id = "${var.route_53_zone_id}"
  name = "${var.site_name}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.apex_cdn.domain_name}"
    zone_id  = "${aws_cloudfront_distribution.apex_cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}
