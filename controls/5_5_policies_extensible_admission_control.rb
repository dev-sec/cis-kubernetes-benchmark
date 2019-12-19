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

cis_level = attribute('cis_level')

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
