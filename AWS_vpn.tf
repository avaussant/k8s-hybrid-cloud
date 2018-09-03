# https://cloud.google.com/solutions/automated-network-deployment-multicloud

resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = "${google_compute_address.gcp-vpn-ip.address}"
  type       = "ipsec.1"

  tags {
    Name = "VPN to GCP"
  }
}

### Preshared Key only
resource "aws_vpn_connection" "preshared" {

  vpn_gateway_id      = "${module.vpc.vgw_id}"
  customer_gateway_id = "${aws_customer_gateway.main.id}"
  type                = "ipsec.1"

  static_routes_only  = true

}

resource "aws_vpn_connection_route" "gcp_hybrid_cloud" {
  destination_cidr_block = "${var.GCP_vpc_subnet}"
  vpn_connection_id      = "${aws_vpn_connection.preshared.id}"
}