variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "zone_name" {
  description = "The name of the Cloud DNS managed zone"
  type        = string
  default     = "carmocloud-com-br"
}

variable "domain_name" {
  description = "The DNS name of the zone"
  type        = string
  default     = "carmocloud.com.br."
}

variable "google_site_verification" {
  description = "The google-site-verification TXT value"
  type        = string
  default     = ""
}

variable "dkim_host" {
  description = "The DKIM selector/host (e.g. google._domainkey)"
  type        = string
  default     = "google._domainkey"
}

variable "dkim_value" {
  description = "The DKIM TXT value"
  type        = string
  default     = ""
}
