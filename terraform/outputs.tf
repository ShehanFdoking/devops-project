# Output Values

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

# EKS Outputs
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

# Node Group Outputs
output "node_group_id" {
  description = "EKS node group ID"
  value       = module.eks.eks_managed_node_groups["primary"].node_group_id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = module.eks.eks_managed_node_groups["primary"].node_group_arn
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = module.eks.node_security_group_id
}

# ECR Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.app.arn
}

# kubectl Configuration Command
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# Useful URLs
output "aws_console_urls" {
  description = "AWS Console URLs for resources"
  value = {
    eks_cluster  = "https://console.aws.amazon.com/eks/home?region=${var.aws_region}#/clusters/${module.eks.cluster_name}"
    ecr_repository = "https://console.aws.amazon.com/ecr/repositories/${var.ecr_repository_name}?region=${var.aws_region}"
    vpc = "https://console.aws.amazon.com/vpc/home?region=${var.aws_region}#vpcs:VpcId=${module.vpc.vpc_id}"
    cloudwatch_logs = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group//aws/eks/${module.eks.cluster_name}/cluster"
  }
}

# Cost Estimation
output "estimated_monthly_cost" {
  description = "Estimated monthly cost (USD)"
  value = {
    eks_control_plane = "$73"
    worker_nodes      = "$${var.node_desired_capacity * 33}"  # ~$33/month per t3.medium
    nat_gateway       = var.single_nat_gateway ? "$32" : "$${32 * length(data.aws_availability_zones.available.names)}"
    load_balancer     = "$16"
    total_estimated   = "$${73 + (var.node_desired_capacity * 33) + (var.single_nat_gateway ? 32 : 32 * 3) + 16}"
    note              = "Prices are approximate and based on eu-north-1 region. Actual costs may vary."
  }
}
