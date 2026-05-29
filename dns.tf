resource "google_dns_managed_zone" "primary" {
  name        = var.zone_name
  dns_name    = var.domain_name
  description = "Public DNS zone for carmocloud.com.br"
  visibility  = "public"
}

# Zoho Mail MX Records
resource "google_dns_record_set" "mx" {
  name         = google_dns_managed_zone.primary.dns_name
  managed_zone = google_dns_managed_zone.primary.name
  type         = "MX"
  ttl          = 3600

  rrdatas = [
    "10 mx.zoho.com.",
    "20 mx2.zoho.com.",
    "50 mx3.zoho.com."
  ]
}

# Root TXT Records (SPF, Zoho, Google Verification)
resource "google_dns_record_set" "root_txt" {
  name         = google_dns_managed_zone.primary.dns_name
  managed_zone = google_dns_managed_zone.primary.name
  type         = "TXT"
  ttl          = 3600
  rrdatas = [
    "v=spf1 include:zohomail.com ~all",
    "zoho-verification=zb99924062.zmverify.zoho.com",
    "google-site-verification=E2cLnodTrpY8rLfOT3QKUZ_AwymR0gKpLaaleXCs5oE"
  ]
}

# DMARC
resource "google_dns_record_set" "dmarc" {
  name         = "_dmarc.${google_dns_managed_zone.primary.dns_name}"
  managed_zone = google_dns_managed_zone.primary.name
  type         = "TXT"
  ttl          = 3600
  rrdatas      = ["v=DMARC1; p=none; rua=mailto:dmarc@${substr(var.domain_name, 0, length(var.domain_name)-1)}"]
}

# DKIM (placeholder for Zoho DKIM - update when available)
resource "google_dns_record_set" "dkim" {
  count        = var.dkim_value != "" ? 1 : 0
  name         = "${var.dkim_host}.${google_dns_managed_zone.primary.dns_name}"
  managed_zone = google_dns_managed_zone.primary.name
  type         = "TXT"
  ttl          = 3600
  rrdatas      = [var.dkim_value]
}

# Cloud Run Apex Domain A records
resource "google_dns_record_set" "apex_a" {
  name         = google_dns_managed_zone.primary.dns_name
  managed_zone = google_dns_managed_zone.primary.name
  type         = "A"
  ttl          = 300
  rrdatas      = [
    "216.239.32.21",
    "216.239.34.21",
    "216.239.36.21",
    "216.239.38.21"
  ]
}

# Cloud Run Apex Domain AAAA records
resource "google_dns_record_set" "apex_aaaa" {
  name         = google_dns_managed_zone.primary.dns_name
  managed_zone = google_dns_managed_zone.primary.name
  type         = "AAAA"
  ttl          = 300
  rrdatas      = [
    "2001:4860:4802:32::15",
    "2001:4860:4802:34::15",
    "2001:4860:4802:36::15",
    "2001:4860:4802:38::15"
  ]
}

# Cloud Run Subdomain www CNAME record
resource "google_dns_record_set" "www_cname" {
  name         = "www.${google_dns_managed_zone.primary.dns_name}"
  managed_zone = google_dns_managed_zone.primary.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["ghs.googlehosted.com."]
}
