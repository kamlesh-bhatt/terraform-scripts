resource "aws_vpc" "kb-terraform-vpc" {
    enable_classiclink_dns_support= false
    enable_dns_hostnames= true
    enable_dns_support= true
    cidr_block="192.10.0.0/16"
    tags={
        Name="kb-terraform-vpc"
    }
  
}
resource "aws_subnet" "kb-public-subnet01" {
    cidr_block="192.10.40.0/24"
    availability_zone="ap-southeast-1b"
    vpc_id="${aws_vpc.kb-terraform-vpc.id}"
  
}

resource "aws_subnet" "kb-public-subnet02" {
    cidr_block="192.10.30.0/24"
    availability_zone="ap-southeast-1a"
    vpc_id="${aws_vpc.kb-terraform-vpc.id}"
  
}
resource "aws_route_table" "kb-routetable" {
    vpc_id="${aws_vpc.kb-terraform-vpc.id}"
    route {
        cidr_block ="0.0.0.0/0"
        gateway_id ="${aws_internet_gateway.kb-internetgateway.id}"
    }
    
  
}

resource "aws_internet_gateway" "kb-internetgateway" {
    vpc_id="${aws_vpc.kb-terraform-vpc.id}"
}

resource "aws_route_table_association" "kb-route-table-association" {
    subnet_id="${aws_subnet.kb-public-subnet01.id}"
    route_table_id="${aws_route_table.kb-routetable.id}"

  
}

