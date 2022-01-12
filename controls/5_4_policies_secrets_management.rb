# frozen_string_literal: true

cis_level = input('cis_level')

title '5.4 Policies: Secrets Management'

control 'cis-kubernetes-benchmark-5.4.1' do
  title 'Prefer using secrets as files over secrets as environment variables'
  desc "Kubernetes supports mounting secrets as data volumes or as environment variables. Minimize the use of environment variable secrets.\nRationale: It is reasonably common for application code to log out its environment (particularly in the event of an error). This will include any secret values passed in as environment variables, so secrets can easily be exposed to any user or entity who has access to the logs."
  impact 0.0

  tag cis: 'kubernetes:5.4.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.4.1' do
    skip "Review the `kubectl get all -o jsonpath='{range .items[?(@..secretKeyRef)]} {.kind} {.metadata.name} {\"\n\"}{end}' -A` command to find references to objects which use environment variables defined from secrets."
  end
end

control 'cis-kubernetes-benchmark-5.4.2' do
  title 'Consider external secret storage'
  desc "Consider the use of an external secrets storage and management system, instead of using Kubernetes Secrets directly, if you have more complex secret management needs. Ensure the solution requires authentication to access secrets, has auditing of access to and use of secrets, and encrypts secrets. Some solutions also make it easier to rotate secrets.\nRationale: Kubernetes supports secrets as first-class objects, but care needs to be taken to ensure that access to secrets is carefully limited. Using an external secrets provider can ease the management of access to secrets, especially where secrests are used across both Kubernetes and non-Kubernetes environments."
  impact 0.0

  tag cis: 'kubernetes:5.4.2'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.4.2' do
    skip 'Review your secrets management implementation.'
  end
end
