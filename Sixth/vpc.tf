resource "aws_vpc" "emessVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "msVPC01"
  }
}

locals {
  subnet_count = 2
}

data "aws_availability_zones" "allazs" {

}

resource "aws_subnet" "emesspublicsubnets" {
  vpc_id            = aws_vpc.emessVPC.id
  count             = local.subnet_count
  cidr_block        = "10.0.${count.index}.0/28"
  availability_zone = data.aws_availability_zones.allazs.names["${count.index}"]
  depends_on = [
    aws_vpc.emessVPC
  ]
}

resource "aws_subnet" "emessprivatesubnets" {
  vpc_id            = aws_vpc.emessVPC.id
  count             = local.subnet_count
  cidr_block        = "10.0.${10 + count.index}.0/28"
  availability_zone = data.aws_availability_zones.allazs.names["${count.index}"]
  depends_on = [
    aws_vpc.emessVPC
  ]
}

resource "aws_internet_gateway" "msigw" {
  vpc_id = aws_vpc.emessVPC.id
}

resource "aws_route" "ms_internet_route" {
  route_table_id         = aws_vpc.emessVPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.msigw.id
}

resource "aws_eip" "msgateway" {
  count      = local.subnet_count
  vpc        = true
  depends_on = [aws_internet_gateway.msigw]
}

resource "aws_nat_gateway" "msnat" {
  count         = local.subnet_count
  subnet_id     = element(aws_subnet.emesspublicsubnets.*.id, count.index)
  allocation_id = element(aws_eip.msgateway.*.id, count.index)
}

resource "aws_route_table" "ms_private" {
  count  = local.subnet_count
  vpc_id = aws_vpc.emessVPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.msnat.*.id, count.index)
  }
}

resource "aws_route_table_association" "privateasso" {
  count          = local.subnet_count
  subnet_id      = element(aws_subnet.emessprivatesubnets.*.id, count.index)
  route_table_id = element(aws_route_table.ms_private.*.id, count.index)
}
