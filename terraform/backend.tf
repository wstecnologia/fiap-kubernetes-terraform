terraform {
  backend "s3" {
    bucket = "wstech-backend-tf"
    key    = "fiap/terraform.tfstate"
    region = "us-east-1"
  }
}
