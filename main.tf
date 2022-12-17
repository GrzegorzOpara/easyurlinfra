module "prod" {
    source = "./environments/prod"
    project_name = "easyurl"
    location = "North Europe"
    python_version = "3.9"
}
