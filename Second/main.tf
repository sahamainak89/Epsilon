module "deploy" {
  source = "./module"
  instanceCount = 1
  env = "UAT"
  instanceName = "MS"
}