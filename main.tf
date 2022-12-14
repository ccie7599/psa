terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}
//Use the Linode Provider
provider "linode" {
  token = var.token
}


//Use the linode_lke_cluster resource to create
//a Kubernetes cluster
resource "linode_lke_cluster" "foobar1" {
    k8s_version = var.k8s_version
    label = "lke-us-east"
    region = "us-east"
    tags = var.tags

     pool {
        type  = "g6-standard-4"
        count = 3

        autoscaler {
          min = 3
          max = 20
        }
    }
}
resource "linode_lke_cluster" "foobar2" {
    k8s_version = var.k8s_version
    label = "lke-us-west"
    region = "us-west"
    tags = var.tags

     pool {
        type  = "g6-standard-4"
        count = 3

        autoscaler {
          min = 3
          max = 20
        }
    }
}
resource "local_file" "lke_east_yaml" {
    content  = base64decode(linode_lke_cluster.foobar1.kubeconfig)
    filename = "${path.module}/us-east.yaml"
}
resource "local_file" "lke_west_yaml" {
    content  = base64decode(linode_lke_cluster.foobar2.kubeconfig)
    filename = "${path.module}/us-west.yaml"
}
