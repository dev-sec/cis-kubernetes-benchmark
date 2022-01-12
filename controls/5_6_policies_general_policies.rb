# frozen_string_literal: true

cis_level = input('cis_level')

title '5.6 Policies: General Policies'

control 'cis-kubernetes-benchmark-5.6.1' do
  title 'Create administrative boundaries between resources using namespaces'
  desc "Use namespaces to isolate your Kubernetes objects.\n\nRationale: Limiting the scope of user permissions can reduce the impact of mistakes or malicious activities. A Kubernetes namespace allows you to partition created resources into logically named groups. Resources created in one namespace can be hidden from other namespaces. By default, each resource created by a user in Kubernetes cluster runs in a default namespace, called `default`. You can create additional namespaces and attach resources and users to them. You can use Kubernetes Authorization plugins to create policies that segregate access to namespace resources between different users."
  impact 0.0

  tag cis: 'kubernetes:5.6.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.6.1' do
    skip 'Review the output of `kubectl get namespaces` and ensure they are the ones you need.'
  end
end

control 'cis-kubernetes-benchmark-5.6.2' do
  title 'Ensure that the seccomp profile is set to docker/default in your pod definitions'
  desc "Enable `docker/default` seccomp profile in your pod definitions.\n\nRationale: Seccomp (secure computing mode) is used to restrict the set of system calls applications can make, allowing cluster administrators greater control over the security of workloads running in the cluster. Kubernetes disables seccomp profiles by default for historical reasons. You should enable it to ensure that the workloads have restricted actions available within the container."
  impact 0.0

  tag cis: 'kubernetes:5.6.2'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.6.2' do
    skip 'Review all the pod definitions in your cluster and verify that `seccomp` is enabled.'
  end
end

control 'cis-kubernetes-benchmark-5.6.3' do
  title 'Apply Security Context to Your Pods and Containers'
  desc "Apply Security Context to Your Pods and Containers\n\nRationale: A security context defines the operating system security settings (uid, gid, capabilities, SELinux role, etc..) applied to a container. When designing your containers and pods, make sure that you configure the security context for your pods, containers, and volumes. A security context is a property defined in the deployment yaml. It controls the security parameters that will be assigned to the pod/container/volume. There are two levels of security context: pod level security context, and container level security context."
  impact 0.0

  tag cis: 'kubernetes:5.6.3'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.6.3' do
    skip 'Review the pod definitions in your cluster and verify that you have security contexts defined as appropriate.'
  end
end

control 'cis-kubernetes-benchmark-5.6.3' do
  title 'Create network segmentation using Network Policies'
  desc "Use network policies to isolate your cluster network.\n\nRationale: Running different applications on the same Kubernetes cluster creates a risk of one compromised application attacking a neighboring application. Network segmentation is important to ensure that containers can communicate only with those they are supposed to. A network policy is a specification of how selections of pods are allowed to communicate with each other and other network endpoints. `NetworkPolicy` resources use labels to select pods and define whitelist rules which allow traffic to the selected pods in addition to what is allowed by the isolation policy for a given namespace."
  impact 0.0

  tag cis: 'kubernetes:5.6.3'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.6.3' do
    skip 'Review the output of `kubectl get networkpolicy --namespace=kube-system` and ensure the `NetworkPolicy` objects are the ones you need.'
  end
end

control 'cis-kubernetes-benchmark-5.6.4' do
  title 'The default namespace should not be used'
  desc "Kubernetes provides a default namespace, where objects are placed if no namespace is specified for them. Placing objects in this namespace makes application of RBAC and other controls more difficult.\n\nRationale: Resources in a Kubernetes cluster should be segregated by namespace, to allow for security controls to be applied at that level and to make it easier to manage resources."
  impact 0.0

  tag cis: 'kubernetes:5.6.4'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.6.4' do
    skip 'List objects in default namespaceReview using `kubectl get all`. The only entries there should be system managed resources such as the kubernetes service'
  end
end
