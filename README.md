
A terraform module to create a managed Kubernetes cluster on AWS EKS. Available through the Terraform registry. 

Inspired by and adapted from this doc and its source code. Read the AWS docs on EKS to get connected to the k8s dashboard.

Assumptions

You want to create an EKS cluster and an autoscaling group of workers for the cluster.

You want these resources to exist within security groups that allow communication and coordination. 

These can be user provided or created within the module.

You've created a Virtual Private Cloud (VPC) and subnets where you intend to put the EKS resources. 

The VPC satisfies EKS requirements.

Important note

The default cluster_versionis now 1.16. Kubernetes 1.16 includes a number of deprecated API removals, 

and you need to ensure your applications and add ons are updated, or workloads could fail after the upgrade is complete.

For more information on the API removals, see the Kubernetes blog post. For action you may need to take before upgrading, 

see the steps in the EKS documentation.

Please set explicitly your cluster_version to an older EKS version until your workloads are ready for Kubernetes 1.16.

Usage example

A full example leveraging other community modules is contained in the examples/basic directory.

    data "aws_eks_cluster" "cluster" {
    name = module.my-cluster.cluster_id
     }

    data "aws_eks_cluster_auth" "cluster" {
    name = module.my-cluster.cluster_id
    }

    provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
    version                = "~> 1.9"
    }

    module "my-cluster" {
    source          = "terraform-aws-modules/eks/aws"
    cluster_name    = "my-cluster"
    cluster_version = "1.16"
    subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
    vpc_id          = "vpc-1234556abcdef"

    worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
    ]
    }
    
Conditional creation

Sometimes you need to have a way to create EKS resources conditionally but Terraform does not allow to use count inside 

module block, so the solution is to specify argument create_eks.

Using this feature and having manage_aws_auth=true (the default) 

requires to set up the kubernetes provider in a way that allows the data sources to not exist.

    data "aws_eks_cluster" "cluster" {
    count = var.create_eks ? 1 : 0
    name  = module.eks.cluster_id
    }

    data "aws_eks_cluster_auth" "cluster" {
    count = var.create_eks ? 1 : 0
    name  = module.eks.cluster_id
    }

# In case of not creating the cluster, this will be an incompletely configured, unused provider, which poses no problem.
    provider "kubernetes" {
     host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
    cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")),  0))
    token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
    load_config_file       = false
    version                = "1.10"
    }

# This cluster will not be created
    module "eks" {
    source = "terraform-aws-modules/eks/aws"

    create_eks = false
  # ... omitted
    }
    
    
