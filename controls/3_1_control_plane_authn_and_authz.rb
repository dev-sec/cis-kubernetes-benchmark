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

title '3.1 Control Plane Configuration'

control 'cis-kubernetes-benchmark-3.1.1' do
  title 'Client certificate authentication should not be used for users'
  desc "Kubernetes provides the option to use client certificates for user authentication. However as there is no way to revoke these certificates when a user leaves an organization or loses their credential, they are not suitable for this purpose. It is not possible to fully disable client certificate use within a cluster as it is used for component to component authentication.\nRationale: With any authentication mechanism the ability to revoke credentials if they are compromised or no longer required, is a key control. Kubernetes client certificate authentication does not allow for this due to a lack of support for certificate revocation."
  impact 1.0

  tag cis: 'kubernetes:3.1.1'
  tag level: 2

  describe 'cis-kubernetes-benchmark-3.1.1' do
    skip 'Review user access to the cluster and ensure that users are not making use of Kubernetes client certificate authentication.'
  end
end
