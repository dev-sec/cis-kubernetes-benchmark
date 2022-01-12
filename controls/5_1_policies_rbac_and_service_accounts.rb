# frozen_string_literal: true

title '5.1 Policies: RBAC and Service Accounts'

control 'cis-kubernetes-benchmark-5.1.1' do
  title 'Ensure that the cluster-admin role is only used where required'
  desc "The RBAC role `cluster-admin` provides wide-ranging powers over the environment and should be used only where and when needed.\n\nRationale: Kubernetes provides a set of default roles where RBAC is used. Some of these roles such as `cluster-admin` provide wide-ranging privileges which should only be applied where absolutely necessary. Roles such as `cluster-admin` allow super-user access to perform any action on any resource. When used in a `ClusterRoleBinding`, it gives full control over every resource in the cluster and in all namespaces. When used in a `RoleBinding`, it gives full control over every resource in the rolebinding's namespace, including the namespace itself."
  impact 0.0

  tag cis: 'kubernetes:5.1.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.1' do
    skip 'Review the output of `kubectl get clusterrolebindings -o=custom-columns=NAME:.metadata.name,ROLE:.roleRef.name,SUBJECT:.subjects[*].name` and ensure the listed principals require `cluster-admin` privileges.'
  end
end

control 'cis-kubernetes-benchmark-5.1.2' do
  title 'Minimize access to secrets'
  desc "The Kubernetes API stores secrets, which may be service account tokens for the Kubernetes API or credentials used by workloads in the cluster. Access to these secrets should be restricted to the smallest possible group of users to reduce the risk of privilege escalation.\nRationale: Inappropriate access to secrets stored within the Kubernetes cluster can allow for an attacker to gain additional access to the Kubernetes cluster or external resources whose credentials are stored as secrets."
  impact 0.0

  tag cis: 'kubernetes:5.1.2'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.2' do
    skip 'Review the users who have get, list or watch access to secrets objects in the Kubernetes API.'
  end
end

control 'cis-kubernetes-benchmark-5.1.3' do
  title 'Minimize wildcard use in Roles and ClusterRoles'
  desc "Kubernetes Roles and ClusterRoles provide access to resources based on sets of objects and actions that can be taken on those objects. It is possible to set either of these to be the wildcard '*' which matches all items. Use of wildcards is not optimal from a security perspective as it may allow for inadvertent access to be granted when new resources are added to the Kubernetes API either as CRDs or in later versions of the product.\nRationale: The principle of least privilege recommends that users are provided only the access required for their role and nothing more. The use of wildcard rights grants is likely to provide excessive rights to the Kubernetes API."
  impact 0.0

  tag cis: 'kubernetes:5.1.3'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.3' do
    skip 'Retrieve the roles defined across each namespaces in the cluster using `kubectl get roles --all-namespaces -o yaml` and review for wildcards . Retrieve the cluster roles defined in the cluster using `kubectl get clusterroles -o yaml` and review for wildcards.'
  end
end

control 'cis-kubernetes-benchmark-5.1.4' do
  title 'Minimize access to create pods'
  desc "The ability to create pods in a namespace can provide a number of opportunities for privilege escalation, such as assigning privileged service accounts to these pods or mounting hostPaths with access to sensitive data (unless Pod Security Policies are implemented to restrict this access) As such, access to create new pods should be restricted to the smallest possible group of users.\nRationale: The ability to create pods in a cluster opens up possibilities for privilege escalation and should be restricted, where possible."
  impact 0.0

  tag cis: 'kubernetes:5.1.4'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.4' do
    skip 'Review the users who have create access to pod objects in the Kubernetes API.'
  end
end

control 'cis-kubernetes-benchmark-5.1.5' do
  title 'Ensure that default service accounts are not actively used'
  desc "The default service account should not be used to ensure that rights granted to applications can be more easily audited and reviewed.\nRationale: Kubernetes provides a default service account which is used by cluster workloads where no specific service account is assigned to the pod. Where access to the Kubernetes API from a pod is required, a specific service account should be created for that pod, and rights granted to that service account. The default service account should be configured such that it does not provide a service account token and does not have any explicit rights assignments."
  impact 0.0

  tag cis: 'kubernetes:5.1.5'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.5' do
    skip 'For each namespace in the cluster, review the rights assigned to the default service account and ensure that it has no roles or cluster roles bound to it apart from the defaults.   Additionally ensure that the `automountServiceAccountToken: false` setting is in place for each default service account.'
  end
end

control 'cis-kubernetes-benchmark-5.1.6' do
  title 'Ensure that Service Account Tokens are only mounted where necessary'
  desc "Service accounts tokens should not be mounted in pods except where the workload running in the pod explicitly needs to communicate with the API server\nRationale: Mounting service account tokens inside pods can provide an avenue for privilege escalation attacks where an attacker is able to compromise a single pod in the cluster. Avoiding mounting these tokens removes this attack avenue."
  impact 0.0

  tag cis: 'kubernetes:5.1.6'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.1.6' do
    skip 'Review pod and service account objects in the cluster and ensure that the option `automountServiceAccountToken: false` is set, unless the resource explicitly requires this access.'
  end
end
