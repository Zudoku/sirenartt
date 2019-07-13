variable "site_name" {
  description = "Domain of the website"
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for the domain"
}

variable "route_53_zone_id" {
  description = "Route 53 zone id"
}
