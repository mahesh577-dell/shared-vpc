output "firewall_rules" {
  value = [
    google_compute_firewall.allow_internal.name,
    google_compute_firewall.allow_health_check.name,
    google_compute_firewall.allow_ssh_iap.name,
    google_compute_firewall.allow_http_https.name,
    google_compute_firewall.deny_all_ingress.name,
    google_compute_firewall.allow_all_egress.name,
  ]
}
