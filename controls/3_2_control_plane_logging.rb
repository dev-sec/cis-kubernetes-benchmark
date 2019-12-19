#
# Copyright 2019, Schuberg Philis B.V.
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

title '3.2 Logging'

apiserver = attribute('apiserver')
# fallback if apiserver attribute is not defined
apiserver = kubernetes.apiserver_bin if apiserver.empty?

only_if('apiserver not found') do
  processes(apiserver).exists?
end

control 'cis-kubernetes-benchmark-3.2.1' do
  title 'Ensure that a minimal audit policy is created'
  desc "Kubernetes can audit the details of requests made to the API server. The --audit-policy-file flag must be set for this logging to be enabled.\nRationale: Logging is an important detective control for all systems, to detect potential unauthorised access."
  impact 1.0

  tag cis: 'kubernetes:3.2.1'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-policy-file=(\S+)/) }
  end

  audit_policy_filea = processes(apiserver).commands.to_s.scan(/--audit-policy-file=(\S+)/)
  describe directory(audit_log_path) do
    it { should exist }
  end
end

control 'cis-kubernetes-benchmark-3.2.2' do
  title 'Ensure that the audit policy covers key security concerns'
  desc "Ensure that the audit policy created for the cluster covers key security concerns.\nRationale: Security audit logs should cover access and modification of key resources in the cluster, to enable them to form an effective part of a security environment."
  impact 0.0

  tag cis: 'kubernetes:3.2.2'
  tag level: 2

  describe 'cis-kubernetes-benchmark-3.2.2' do
    skip "Review the audit policy provided for the cluster and ensure that it covers at least the following areas: 1) Access to Secrets managed by the cluster. Care should be taken to only log Metadata for requests to Secrets, ConfigMaps, and TokenReviews, in order to avoid the risk of logging sensitive data. 2) Modification of pod and deployment objects. 3) Use of pods/exec, pods/portforward, pods/proxy and services/proxy. For most requests, minimally logging at the Metadata level is recommended (the most basic level of logging)."
  end
end
