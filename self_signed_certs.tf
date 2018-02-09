resource "tls_cert_request" "ssl_csr" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ssl_private_key.private_key_pem}"

  dns_names = [
    "*.apps.${var.env_name}.${var.dns_suffix}",
    "*.sys.${var.env_name}.${var.dns_suffix}",
    "*.login.sys.${var.env_name}.${var.dns_suffix}",
    "*.uaa.sys.${var.env_name}.${var.dns_suffix}",
  ]

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"

  subject {
    common_name         = "${var.env_name}.${var.dns_suffix}"
    organization        = "Pivotal"
    organizational_unit = "Cloudfoundry"
    country             = "US"
    province            = "CA"
    locality            = "San Francisco"
  }
}

resource "tls_locally_signed_cert" "ssl_cert" {
  cert_request_pem   = "${tls_cert_request.ssl_csr.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${var.ssl_ca_private_key}"
  ca_cert_pem        = "${var.ssl_ca_cert}"

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"

  validity_period_hours = 8760 # 1year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "ssl_private_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"
}

resource "tls_cert_request" "isoseg_ssl_csr" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.isoseg_ssl_private_key.private_key_pem}"

  dns_names = [
    "*.iso.${var.env_name}.${var.dns_suffix}",
  ]

  count = "${length(var.isoseg_ssl_ca_cert) > 0 ? 1 : 0}"

  subject {
    common_name         = "${var.env_name}.${var.dns_suffix}"
    organization        = "Pivotal"
    organizational_unit = "Cloudfoundry"
    country             = "US"
    province            = "CA"
    locality            = "San Francisco"
  }
}

resource "tls_locally_signed_cert" "isoseg_ssl_cert" {
  cert_request_pem   = "${tls_cert_request.isoseg_ssl_csr.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${var.isoseg_ssl_ca_private_key}"
  ca_cert_pem        = "${var.isoseg_ssl_ca_cert}"

  count = "${length(var.isoseg_ssl_ca_cert) > 0 ? 1 : 0}"

  validity_period_hours = 8760 # 1year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "isoseg_ssl_private_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  count = "${length(var.isoseg_ssl_ca_cert) > 0 ? 1 : 0}"
}
