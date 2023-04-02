#

# Basic Infrastructure

## VPC

A VPC is a private, customizable network in AWS, allowing secure control over your resources.

### Basic Components

- Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Network ACLs
- Security Groups

A subnet is a smaller network within a VPC, used to divide and organize resources for better management and security.

An internet gateway connects your VPC to the internet, enabling communication between resources inside and outside the VPC.

A nat gateway enables private subnet resources to access the internet, while preventing inbound traffic.

Route Tables define rules for traffic routing within and outside the VPC.

Network ACLs control inbound and outbound traffic at the subnet level, acting as firewalls.

Security groups act as virtual firewalls for individual instances, managing inbound and outbound traffic.

VPC peering connects two VPCs, allowing private traffic exchange between them.


A VPN connection securely links an on-premises network to a VPC via the internet.

Direct Connect establishes a dedicated, private connection between an on-premises network and AWS.