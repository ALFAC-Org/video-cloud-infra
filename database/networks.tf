resource "aws_subnet" "food_database_subnet_az_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_database_1_cidr_block
  availability_zone = var.subnet_availability_zone_az_1

  tags = {
    Name = "food_database_subnet_az_1"
  }
}

resource "aws_subnet" "food_database_subnet_az_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_database_2_cidr_block
  availability_zone = var.subnet_availability_zone_az_2

  tags = {
    Name = "food_database_subnet_az_2"
  }
}