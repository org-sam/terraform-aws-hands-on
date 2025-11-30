module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "21.9.0"

  cluster_name = var.cluster_name

  namespace = "karpenter"

  create_node_iam_role = false
  node_iam_role_arn    = var.eks_managed_node_groups["eks-node-initial"].iam_role_arn
  create_access_entry  = false
}

resource "helm_release" "karpenter" {
  depends_on = [module.karpenter]

  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.8.2"

  values = [<<-EOT
    replicas: 1
    logLevel: "info"
    nodeSelector:
      nodeTypeClass: "initial"
    settings:
      clusterName: ${var.cluster_name}
      clusterEndpoint: ${var.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    serviceAccount:
      name: ${module.karpenter.service_account}
    serviceMonitor:
      enabled: true
      additionalLabels:
        release: "prometheus"
    controller:
      resources:
        requests:
          cpu: 100m
          memory: 256Mi
        limits:
          cpu: 500m
          memory: 1Gi
  EOT
  ]
}

resource "kubectl_manifest" "karpenter_nodepool_default" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: ${var.env}-${var.name}-default
    spec:
      disruption:
        consolidateAfter: 30s
        consolidationPolicy: WhenEmpty
        expireAfter: Never
      limits:
        cpu: ${var.nodepool_config.nodepool.limits.cpu}
        memory: ${var.nodepool_config.nodepool.limits.memory}
      template:
        metadata:
          labels:
            nodeTypeClass: default
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: ${var.env}-${var.name}-default
          requirements:
            - key: kubernetes.io/os
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.os)}
            - key: karpenter.k8s.aws/instance-hypervisor
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.instance_hypervisor)}
            - key: kubernetes.io/arch
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.arch)}
            - key: karpenter.sh/capacity-type
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.capacity_type)}
            - key: karpenter.k8s.aws/instance-family
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.instance_family)}
            - key: karpenter.k8s.aws/instance-cpu
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.instance_cpu)}
            - key: topology.kubernetes.io/zone
              operator: In
              values: ${jsonencode(var.nodepool_config.nodepool.requirements.zone)}
  YAML
}

resource "kubectl_manifest" "karpenter_ec2nodeclass_default" {
  depends_on = [module.karpenter, helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: ${var.env}-${var.name}-default
    spec:
      role: ${var.eks_managed_node_groups["eks-node-initial"].iam_role_name}
      amiSelectorTerms:
        - alias: al2023@latest
      blockDeviceMappings:
        - deviceName: ${var.nodepool_config.ec2_node_class.device_name}
          ebs:
            volumeSize: ${var.nodepool_config.ec2_node_class.volume_size}
            volumeType: ${var.nodepool_config.ec2_node_class.volume_type}
            encrypted: true
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.env}-${var.name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.env}-${var.name}
      tags:
        karpenter.sh/discovery: ${var.env}-${var.name}
        Name: eks-node-${var.env}-${var.name}-default
        Environment: ${var.env}
  YAML
}
