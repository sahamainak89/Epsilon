locals {
  cluster_name = "msdemo"
}

resource "aws_ecs_cluster" "msecs" {
  name = local.cluster_name
}