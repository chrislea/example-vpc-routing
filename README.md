# A Simple VPC Routing Example

This manifest sets up two AWS VPCs, a gateway between them which AWS calls a "Peering Connection", and adds routes to the VPCs' route tables so that packets from each VPC can reach the other.

---

It creates the VPCs using [this module](https://github.com/chrislea/example-terraform-vpc).

We will reference one VPC as the "10" VPC, which will have the CIDR range `10.213.0.0/16`.

The other VPC we will reference as the "172" VPC, which will have the CIDR range `172.213.0.0/16`.

Each VPC will have public and private subnets, an Internet Gateway (IGW), and routing set up so that hosts in the public subnets will route to the IGW for traffic bound for the external Internet.

---

With the VPCs created, the manifest will then create the "Peering Connection", which is an AWS gateway object that can forward traffic between the two VPCs.

Finally, a route will be added to the route table for the "10" VPC that sends traffic bound for the CIDR range of the "172" VPC to the Peering Connection. Likewise, a route will be added to the route table for the "172" VPC that sends traffic bound for the CIDR range of the "10" VPC to the Peering Connection as well. In this way, bi-directional traffic is allowed.