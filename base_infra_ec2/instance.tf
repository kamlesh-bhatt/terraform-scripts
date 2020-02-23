resource "aws_instance" "kb-terraform" {
    ami="ami-0f02b24005e4aec36"
    instance_type = "t2.nano" 
    subnet_id="${aws_subnet.kb-public-subnet01.id}"
    vpc_security_group_ids=["${aws_security_group.security_group.id}"]
    user_data= "${file("userdata.sh")}"
    key_name ="CL"
    iam_instance_profile="admin_"
    tags={
        Name="kb-terraform-instance"
        Environment="Production"
    }
}
resource "aws_eip" "publicip" {
    instance= "${aws_instance.kb-terraform.id}"
    vpc=true
  
}
resource "aws_ebs_volume" "kb-terraform_ebs" {
    size=30
    availability_zone="ap-southeast-1b"
    encrypted=true
  
}
resource "aws_volume_attachment" "volumeattach" {
    instance_id="${aws_instance.kb-terraform.id}"
    volume_id="${aws_ebs_volume.kb-terraform_ebs.id}"
    device_name = "/dev/sdf"
  
}
resource "aws_security_group" "security_group" {
    name ="kb-security-group"
    ingress{
        from_port="22"
        to_port ="22"
        protocol ="tcp"
        cidr_blocks =["0.0.0.0/0"]
    }
        ingress{
        from_port="80"
        to_port ="80"
        protocol ="tcp"
        cidr_blocks =["0.0.0.0/0"]
    }
    egress{
        from_port ="0"
        to_port = "0"
        protocol ="-1"
        cidr_blocks =["0.0.0.0/0"]

    }
    vpc_id="${aws_vpc.kb-terraform-vpc.id}"
}

output "instance_ip" {
  value = "${aws_instance.kb-terraform.public_ip}"

  }