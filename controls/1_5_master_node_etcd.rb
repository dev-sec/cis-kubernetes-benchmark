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

title '1.5 Master Node: etcd'

etcd_regex = Regexp.new(%r{/usr/bin/etcd})
etcd_process = processes(etcd_regex)
etcd_env_vars = process_env_var(etcd_regex)

only_if('etcd not found') do
  etcd_process.exists?
end

control 'cis-kubernetes-benchmark-1.5.1' do
  title 'Ensure that the --cert-file and --key-file arguments are set as appropriate'
  desc "Configure TLS encryption for the etcd service.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be encrypted in transit."
  impact 1.0

  tag cis: 'kubernetes:1.5.1'
  tag level: 1

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--cert-file=/) }
    end

    describe etcd_env_vars do
      its(:ETCD_CERT_FILE) { should_not be_empty }
    end
  end

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--key-file=/) }
    end

    describe etcd_env_vars do
      its(:ETCD_KEY_FILE) { should_not be_empty }
    end
  end
end

control 'cis-kubernetes-benchmark-1.5.2' do
  title 'Ensure that the --client-cert-auth argument is set to true'
  desc "Enable client authentication on etcd service.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should not be available to unauthenticated clients. You should enable the client authentication via valid certificates to secure the access to the etcd service."
  impact 1.0

  tag cis: 'kubernetes:1.5.2'
  tag level: 1

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--client-cert-auth=true/) }
    end

    describe etcd_env_vars do
      its(:ETCD_CLIENT_CERT_AUTH) { should_not be_empty }
    end
  end
end

control 'cis-kubernetes-benchmark-1.5.3' do
  title 'Ensure that the --auto-tls argument is not set to true'
  desc "Do not use self-signed certificates for TLS.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should not be available to unauthenticated clients. You should enable the client authentication via valid certificates to secure the access to the etcd service."
  impact 1.0

  tag cis: 'kubernetes:1.5.3'
  tag level: 1

  describe etcd_process.commands.to_s do
    it { should_not match(/--auto-tls=true/) }
  end
end

control 'cis-kubernetes-benchmark-1.5.4' do
  title 'Ensure that the --peer-cert-file and --peer-key-file arguments are set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for peer connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be encrypted in transit and also amongst peers in the etcd clusters."
  impact 1.0

  tag cis: 'kubernetes:1.5.4'
  tag level: 1

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--peer-cert-file=/) }
    end

    describe etcd_env_vars do
      its(:ETCD_PEER_CERT_FILE) { should_not be_empty }
    end
  end

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--peer-key-file=/) }
    end

    describe etcd_env_vars do
      its(:ETCD_PEER_KEY_FILE) { should_not be_empty }
    end
  end
end

control 'cis-kubernetes-benchmark-1.5.5' do
  title 'Ensure that the --peer-client-cert-auth argument is set to true'
  desc "etcd should be configured for peer authentication.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be accessible only by authenticated etcd peers in the etcd cluster."
  impact 1.0

  tag cis: 'kubernetes:1.5.5'
  tag level: 1

  describe.one do
    describe etcd_process.commands.to_s do
      it { should match(/--peer-client-cert-auth=true/) }
    end

    describe etcd_env_vars do
      its(:ETCD_PEER_CLIENT_CERT_AUTH) { should_not be_empty }
    end
  end
end

control 'cis-kubernetes-benchmark-1.5.6' do
  title 'Ensure that the --peer-auto-tls argument is not set to true'
  desc "Do not use automatically generated self-signed certificates for TLS connections between peers.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be accessible only by authenticated etcd peers in the etcd cluster. Hence, do not use self-signed certificates for authentication."
  impact 1.0

  tag cis: 'kubernetes:1.5.6'
  tag level: 1

  describe etcd_process.commands.to_s do
    it { should_not match(/--peer-auto-tls=true/) }
  end
end

control 'cis-kubernetes-benchmark-1.5.9' do
  title 'Ensure that a unique Certificate Authority is used for etcd'
  desc "Use a different certificate authority for etcd from the one used for Kubernetes.\n\nRationale: etcd is a highly available key-value store used by Kubernetes deployments for persistent storage of all of its REST API objects. Its access should be restricted to specifically designated clients and peers only.\nAuthentication to etcd is based on whether the certificate presented was issued by a trusted certificate authority. There is no checking of certificate attributes such as common name or subject alternative name. As such, if any attackers were able to gain access to any certificate issued by the trusted certificate authority, they would be able to gain full access to the etcd database."
  impact 0.0

  tag cis: 'kubernetes:1.5.9'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.5.9' do
    skip 'Review if the CA used for etcd is different from the one used for Kubernetes'
  end
end
