# frozen_string_literal: true

cis_level = input('cis_level')

title '5.5 Policies: Extensible Admission Control'

control 'cis-kubernetes-benchmark-5.5.1' do
  title 'Configure Image Provenance using ImagePolicyWebhook admission controller'
  desc "Configure Image Provenance for your deployment.\n\nRationale: Kubernetes supports plugging in provenance rules to accept or reject the images in your deployments. You could configure such rules to ensure that only approved images are deployed in the cluster."
  impact 0.0

  tag cis: 'kubernetes:5.5.1'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.5.1' do
    skip 'Review the pod definitions in your cluster and verify that image provenance is configured as appropriate.'
  end
end
