# ------------------------------------------------------------------------------
# Create a tunnel to VENOM
# ------------------------------------------------------------------------------

resource "aws_customer_gateway" "venom" {
  provider = aws.sharedservicesprovisionaccount

  bgp_asn    = 65000 # Unused
  ip_address = "52.177.137.15"
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM site-to-site VPN gateway"
    },
  )
  type = "ipsec.1"
}

resource "aws_vpn_connection" "venom" {
  provider = aws.sharedservicesprovisionaccount

  customer_gateway_id = aws_customer_gateway.venom.id
  # These two resources seem to want a /32, which I do not understand.
  # It doesn't really matter, since I will define what traffic flows
  # into the customer gateway via TGW routing tables.
  #
  # local_ipv4_network_cidr = "10.240.208.0/21"
  # remote_ipv4_network_cidr = aws_vpc.the_vpc.cidr_block
  static_routes_only = true
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM site-to-site VPN connection"
    },
  )
  transit_gateway_id                   = aws_ec2_transit_gateway.tgw.id
  tunnel_inside_ip_version             = "ipv4"
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase2_lifetime_seconds      = 3600
  tunnel1_preshared_key                = var.venom_vpn_preshared_key
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase2_lifetime_seconds      = 3600
  tunnel2_preshared_key                = var.venom_vpn_preshared_key
  type                                 = aws_customer_gateway.venom.type
}
