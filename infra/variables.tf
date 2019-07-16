variable "site_name" {
  description = "Domain of the website (without www.)"
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for the domain (MUST BE US-EAST-1)"
}

variable "route_53_zone_id" {
  description = "Route 53 zone id"
}

variable "aws_access_key" {
  description = "AWS access key that CodeBuild uses to push static files into the s3 bucket"
}

variable "aws_secret_key" {
  description = "AWS secret key that CodeBuild uses to push static files into the s3 bucket"
}
