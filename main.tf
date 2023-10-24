# Create a VPC we'll call the "10" VPC, with public and private
# subnets, and an IGW that the public subnets can use to route
# to the outside Intenet.
module "the_10_vpc" {
  source          = "git@github.com:chrislea/example-terraform-vpc.git?ref=df1579880f27f65cd693e9e82e8145b502a3fdbb"
  vpc_name        = "the_10_vpc"
  main_cidr_block = "10.21.0.0/16"

  public_subnet_cidrs = [
    "10.21.0.0/19",
    "10.21.32.0/19",
    "10.21.64.0/19"
  ]

  private_subnet_cidrs = [
    "10.21.96.0/19",
    "10.21.128.0/19",
    "10.21.160.0/19"
  ]

  igw_name = "vpc_10_igw"
}

# Create a VPC we'll call the "172" VPC, with public and private
# subnets, and an IGW that the public subnets can use to route
# to the outside Intenet.
module "the_172_vpc" {
  source          = "git@github.com:chrislea/example-terraform-vpc.git?ref=df1579880f27f65cd693e9e82e8145b502a3fdbb"
  vpc_name        = "the_172_vpc"
  main_cidr_block = "172.21.0.0/16"
  auto_accept     = true

  public_subnet_cidrs = [
    "172.21.0.0/19",
    "172.21.32.0/19",
    "172.21.64.0/19"
  ]

  private_subnet_cidrs = [
    "172.21.96.0/19",
    "172.21.128.0/19",
    "172.21.160.0/19"
  ]

  igw_name = "vpc_172_igw"
}

# This creates a "Peering Connection", which is a gateway / router, between
# these two VPCs.
resource "aws_vpc_peering_connection" "vpc_peer" {
  peer_vpc_id = module.the_172_vpc.vpc_id
  vpc_id      = module.the_10_vpc.vpc_id

  tags = {
    Name = "VPC Peering Example"
  }

}

# Add a route in the route table for the "10" VPC that sends any traffic
# headed to the "172" VPC CIDR range to the Peering Connection gateway.
resource "aws_route" "route_10_to_172" {
  route_table_id            = module.the_10_vpc.route_table_id
  destination_cidr_block    = module.the_172_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
}

# Add a route in the route table for the "172" VPC that sends any traffic
# headed to the "10" VPC CIDR range to the Peering Connection gateway.
resource "aws_route" "route_172_to_10" {
  route_table_id            = module.the_172_vpc.route_table_id
  destination_cidr_block    = module.the_10_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
}
