# Define the MongoDB Atlas Provider
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.31.0"
    }
  }
  required_version = "1.11.3"
}

provider "mongodbatlas" {
  public_key  = var.MONGODB_ATLAS_PUBLIC_KEY
  private_key = var.MONGODB_ATLAS_PRIVATE_KEY
}

# Create a Project
resource "mongodbatlas_project" "practice_6" {
  name   = "SS Practice 6"
  org_id = var.MONGODB_ATLAS_ORGANIZATION_ID
}

# Create an Atlas Cluster
resource "mongodbatlas_cluster" "mycluster" {
  project_id                  = mongodbatlas_project.practice_6.id
  name                        = "mycluster"
  cluster_type                = "REPLICASET"
  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_instance_size_name = "M0"
  provider_region_name        = "US_EAST_1"
  mongo_db_major_version      = "8.0"

  depends_on = [mongodbatlas_project.practice_6]
}

# Create a Database User
resource "mongodbatlas_database_user" "admin" {
  username           = var.DB_USER_NAME
  password           = var.DB_USER_PASSWORD
  project_id         = mongodbatlas_project.practice_6.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "db"
  }

  depends_on = [mongodbatlas_cluster.mycluster]
}

# Open up your IP Access List to all, but this comes with significant potential risk.
locals {
  cidr_block_list = [
    { cidr_block : "0.0.0.0/1", comment : "Allow 0.0.0.0/1 ips" },
    { cidr_block : "128.0.0.0/1", comment : "Allow 128.0.0.0/1 ips" }
  ]
}

resource "mongodbatlas_project_ip_access_list" "allow_all_ips" {
  for_each   = { for entry in local.cidr_block_list : entry.cidr_block => entry }
  project_id = mongodbatlas_project.practice_6.id

  cidr_block = each.value.cidr_block
  comment    = each.value.comment
}
