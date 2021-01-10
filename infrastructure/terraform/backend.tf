terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "davidpvilaca"

    workspaces {
      name = "applications_intera_challenge"
    }
  }
}
