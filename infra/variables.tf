variable "site_name" {
  description = "Domain of the website (without www.)"
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for the domain (MUST BE US-EAST-1)"
}

variable "route_53_zone_id" {
  description = "Route 53 zone id"
}

variable "github_git_url" {
  description = "Github url for repo: https://github.com/<AUTHOR>/<REPOSITORY>.git"
}
