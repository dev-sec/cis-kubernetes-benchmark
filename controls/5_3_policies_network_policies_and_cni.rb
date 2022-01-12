# frozen_string_literal: true

cis_level = input('cis_level')

title '5.3 Policies: Network Policies and CNI'

control 'cis-kubernetes-benchmark-5.3.1' do
  title 'Ensure that the CNI in use supports Network Policies'
  desc "There are a variety of CNI plugins available for Kubernetes. If the CNI in use does not support Network Policies it may not be possible to effectively restrict traffic in the cluster.\n\nRationale: Kubernetes network policies are enforced by the CNI plugin in use. As such it is important to ensure that the CNI plugin supports both Ingress and Egress network policies."
  impact 0.0

  tag cis: 'kubernetes:5.3.1'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.3.1' do
    skip 'Review the documentation of CNI plugin in use by the cluster, and confirm that it supports Ingress and Egress network policies.'
  end
end

control 'cis-kubernetes-benchmark-5.3.2' do
  title 'Ensure that all Namespaces have Network Policies defined'
  desc "Use network policies to isolate traffic in your cluster network.\n\nRationale: Running different applications on the same Kubernetes cluster creates a risk of one compromised application attacking a neighboring application. Network segmentation is important to ensure that containers can communicate only with those they are supposed to. A network policy is a specification of how selections of pods are allowed to communicate with each other and other network endpoints. Network Policies are namespace scoped. When a network policy is introduced to a given namespace, all traffic not allowed by the policy is denied. However, if there are no network policies in a namespace all traffic will be allowed into and out of the pods in that namespace."
  impact 0.0

  tag cis: 'kubernetes:5.3.2'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.3.2' do
    skip 'Run the `kubectl --all-namespaces get networkpolicy` command and review the NetworkPolicy objects created in the cluster. Ensure that each namespace defined in the cluster has at least one Network Policy.'
  end
end
