#
# Copyright 2017, Schuberg Philis B.V.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# author: Kristian Vlaardingerbroek

cis_level = attribute('cis_level')

title '1.6 Master Node: General Security Primitives'

control 'cis-kubernetes-benchmark-1.6.1' do
  title 'Ensure that the cluster-admin role is only used where required'
  desc "The RBAC role `cluster-admin` provides wide-ranging powers over the environment and should be used only where and when needed.\n\nRationale: Kubernetes provides a set of default roles where RBAC is used. Some of these roles such as `cluster-admin` provide wide-ranging privileges which should only be applied where absolutely necessary. Roles such as `cluster-admin` allow super-user access to perform any action on any resource. When used in a `ClusterRoleBinding`, it gives full control over every resource in the cluster and in all namespaces. When used in a `RoleBinding`, it gives full control over every resource in the rolebinding's namespace, including the namespace itself."
  impact 0.0

  tag cis: 'kubernetes:1.6.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.6.1' do
    skip 'Review the output of `kubectl get clusterrolebindings -o=custom-columns=NAME:.metadata.name,ROLE:.roleRef.name,SUBJECT:.subjects[*].name` and ensure the listed principals require `cluster-admin` privileges.'
  end
end

control 'cis-kubernetes-benchmark-1.6.2' do
  title 'Create Pod Security Policies for your cluster'
  desc "Create and enforce Pod Security Policies for your cluster.\n\nRationale: A Pod Security Policy is a cluster-level resource that controls the actions that a pod can perform and what it has the ability to access. The `PodSecurityPolicy` objects define a set of conditions that a pod must run with in order to be accepted into the system. Pod Security Policies are comprised of settings and strategies that control the security features a pod has access to and hence this must be used to control pod access permissions."
  impact 0.0

  tag cis: 'kubernetes:1.6.2'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.6.2' do
    skip 'Review the output of `kubectl get psp` and ensure policies are configured per your security requirements.'
  end
end

control 'cis-kubernetes-benchmark-1.6.3' do
  title 'Create administrative boundaries between resources using namespaces'
  desc "Use namespaces to isolate your Kubernetes objects.\n\nRationale: Limiting the scope of user permissions can reduce the impact of mistakes or malicious activities. A Kubernetes namespace allows you to partition created resources into logically named groups. Resources created in one namespace can be hidden from other namespaces. By default, each resource created by a user in Kubernetes cluster runs in a default namespace, called `default`. You can create additional namespaces and attach resources and users to them. You can use Kubernetes Authorization plugins to create policies that segregate access to namespace resources between different users."
  impact 0.0

  tag cis: 'kubernetes:1.6.3'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.6.3' do
    skip 'Review the output of `kubectl get namespaces` and ensure they are the ones you need.'
  end
end

control 'cis-kubernetes-benchmark-1.6.4' do
  title 'Create network segmentation using Network Policies'
  desc "Use network policies to isolate your cluster network.\n\nRationale: Running different applications on the same Kubernetes cluster creates a risk of one compromised application attacking a neighboring application. Network segmentation is important to ensure that containers can communicate only with those they are supposed to. A network policy is a specification of how selections of pods are allowed to communicate with each other and other network endpoints. `NetworkPolicy` resources use labels to select pods and define whitelist rules which allow traffic to the selected pods in addition to what is allowed by the isolation policy for a given namespace."
  impact 0.0

  tag cis: 'kubernetes:1.6.4'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.4' do
    skip 'Review the output of `kubectl get pods --namespace=kube-system` and ensure the `NetworkPolicy` objects are the ones you need.'
  end
end

control 'cis-kubernetes-benchmark-1.6.5' do
  title 'Ensure that the seccomp profile is set to docker/default in your pod definitions'
  desc "Enable `docker/default` seccomp profile in your pod definitions.\n\nRationale: Seccomp (secure computing mode) is used to restrict the set of system calls applications can make, allowing cluster administrators greater control over the security of workloads running in the cluster. Kubernetes disables seccomp profiles by default for historical reasons. You should enable it to ensure that the workloads have restricted actions available within the container."
  impact 0.0

  tag cis: 'kubernetes:1.6.5'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.5' do
    skip 'Review all the pod definitions in your cluster and verify that `seccomp` is enabled.'
  end
end

control 'cis-kubernetes-benchmark-1.6.6' do
  title 'Apply Security Context to Your Pods and Containers'
  desc "Apply Security Context to Your Pods and Containers\n\nRationale: A security context defines the operating system security settings (uid, gid, capabilities, SELinux role, etc..) applied to a container. When designing your containers and pods, make sure that you configure the security context for your pods, containers, and volumes. A security context is a property defined in the deployment yaml. It controls the security parameters that will be assigned to the pod/container/volume. There are two levels of security context: pod level security context, and container level security context."
  impact 0.0

  tag cis: 'kubernetes:1.6.6'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.6' do
    skip 'Review the pod definitions in your cluster and verify that you have security contexts defined as appropriate.'
  end
end

control 'cis-kubernetes-benchmark-1.6.7' do
  title 'Configure Image Provenance using ImagePolicyWebhook admission controller'
  desc "Configure Image Provenance for your deployment.\n\nRationale: Kubernetes supports plugging in provenance rules to accept or reject the images in your deployments. You could configure such rules to ensure that only approved images are deployed in the cluster."
  impact 0.0

  tag cis: 'kubernetes:1.6.7'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.7' do
    skip 'Review the pod definitions in your cluster and verify that image provenance is configured as appropriate.'
  end
end

control 'cis-kubernetes-benchmark-1.6.8' do
  title 'Configure Network policies as appropriate'
  desc "Configure Network policies as appropriate.\n\nRationale: The Network Policy API is now stable. Network policy, implemented through a network plug-in, allows users to set and enforce rules governing which pods can communicate with each other. You should leverage it as appropriate in your environment."
  impact 0.0

  tag cis: 'kubernetes:1.6.8'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.8' do
    skip 'Review the network policies enforced and ensure that they are suitable for your requirements.'
  end
end

control 'cis-kubernetes-benchmark-1.6.9' do
  title 'Place compensating controls in the form of PSP and RBAC for privileged containers usage'
  desc "Use Pod Security Policies (PSP) and RBAC authorization to mitigate the risk arising from using privileged containers.\n\nRationale: A number of components used by Kubernetes clusters currently make use of privileged containers (e.g. Container Network Interface plugins). Privileged containers pose a risk to the underlying host infrastructure. You should use PSP and RBAC or other forms of authorization to mitigate the risk arising out of such privileged container usage. PSPs should be in place to restrict access to create privileged containers to specific roles only, and access to those roles should be restricted using RBAC role bindings."
  impact 0.0

  tag cis: 'kubernetes:1.6.9'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.6.8' do
    skip 'Review Pod Security Policies and RBAC authorization.'
  end
end
