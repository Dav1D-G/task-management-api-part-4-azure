# Part 4 - Additional Questions (Azure)

## 1) Why must Jenkins not provision its own foundational infrastructure?
The Jenkins platform must exist before CI/CD can safely operate. Separating bootstrap infrastructure from delivery pipelines avoids circular dependencies and simplifies disaster recovery.

## 2) Why did you separate CI and INFRA agents?
Build and test stages require different tools and permissions than Terraform and deployment stages. Separate agents reduce risk, improve auditability, and enforce clearer ownership of cloud actions.

## 3) How did you ensure least privilege for Jenkins in Azure?
The intended model uses managed identities and scoped RBAC assignments for different execution contexts. CI agents only need image build and registry access, while INFRA agents need scoped Terraform deployment permissions.

## 4) Why is `terraform plan` important in a CI/CD pipeline?
It provides a reviewable preview of infrastructure changes before apply. This is especially important for `prod`, where deployments require manual approval.

## 5) What happens if deployment succeeds but the health check fails?
The deployment is treated as failed from the pipeline perspective. Even if infrastructure changes were applied, the release is not considered valid until the application passes the health check.

## 6) How does your design support future scaling?
Azure Container Apps scales the workload independently of Jenkins. The infrastructure is modular, environment-specific, and can be extended with stricter networking, additional observability, or more agent capacity.

## 7) If Jenkins becomes unavailable, what is the operational impact?
Running workloads continue serving traffic, but automated build, deployment, approvals, and infrastructure changes are blocked until Jenkins is restored.
