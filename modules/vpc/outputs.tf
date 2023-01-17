output "vpc_1" {
  value = {
    vpc_id = aws_vpc.vpc_1.id
    subnet_id = aws_subnet.vpc_1_private_subnet.id
  }
}

output "vpc_2" {
  value = {
    vpc_id = aws_vpc.vpc_2.id
    subnet_id = aws_subnet.vpc_2_private_subnet.id
  }
}

output "vpc_3" {
  value = {
    vpc_id = aws_vpc.vpc_3.id
    subnet_id = aws_subnet.vpc_3_private_subnet.id
  }
}