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

title '2.1 Worker Node: Kubelet'

kubelet = attribute('kubelet')
# fallback if kubelet attribute is not defined
kubelet = kubernetes.kubelet_bin if kubelet.empty?

only_if('kubelet not found') do
  processes(kubelet).exists?
end

control 'cis-kubernetes-benchmark-2.1.1' do
  title 'Ensure that the --anonymous-auth argument is set to false'
  desc "Disable anonymous requests to the Kubelet server.\n\nRationale: When enabled, requests that are not rejected by other configured authentication methods are treated as anonymous requests. These requests are then served by the Kubelet server. You should rely on authentication to authorize access and disallow anonymous requests."
  impact 1.0

  tag cis: 'kubernetes:2.1.1'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--anonymous-auth=false/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.2' do
  title 'Ensure that the --authorization-mode argument is not set to AlwaysAllow'
  desc "Do not allow all requests. Enable explicit authorization.\n\nRationale: Kubelets, by default, allow all authenticated requests (even anonymous ones) without needing explicit authorization checks from the apiserver. You should restrict this behavior and only allow explicitly authorized requests."
  impact 1.0

  tag cis: 'kubernetes:2.1.2'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should_not match(/--authorization-mode=(?:.)*AlwaysAllow,*(?:.)*/) }
    it { should match(/--authorization-mode=/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.3' do
  title 'Ensure that the --client-ca-file argument is set as appropriate'
  desc "Enable Kubelet authentication using certificates.\n\nRationale: The connections from the apiserver to the kubelet are used for fetching logs for pods, attaching (through kubectl) to running pods, and using the kubelet's port-forwarding functionality. These connections terminate at the kubelet's HTTPS endpoint. By default, the apiserver does not verify the kubelet's serving certificate, which makes the connection subject to man-in-the-middle attacks, and unsafe to run over untrusted and/or public networks. Enabling Kubelet certificate authentication ensures that the apiserver could authenticate the Kubelet before submitting any requests."
  impact 1.0

  tag cis: 'kubernetes:2.1.3'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--client-ca-file=/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.4' do
  title 'Ensure that the --read-only-port argument is set to 0'
  desc "Disable the read-only port.\n\nRationale: The Kubelet process provides a read-only API in addition to the main Kubelet API. Unauthenticated access is provided to this read-only API which could possibly retrieve potentially sensitive information about the cluster."
  impact 1.0

  tag cis: 'kubernetes:2.1.4'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--read-only-port=0/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.5' do
  title 'Ensure that the --streaming-connection-idle-timeout argument is not set to 0'
  desc "Do not disable timeouts on streaming connections.\n\nRationale: Setting idle timeouts ensures that you are protected against Denial-of-Service attacks, inactive connections and running out of ephemeral ports. **Note:** By default, `--streaming-connection-idle-timeout` is set to 4 hours which might be too high for your environment. Setting this as appropriate would additionally ensure that such streaming connections are timed out after serving legitimate use cases."
  impact 1.0

  tag cis: 'kubernetes:2.1.5'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should_not match(/--streaming-connection-idle-timeout=0/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.6' do
  title 'Ensure that the --protect-kernel-defaults argument is set to true'
  desc "Protect tuned kernel parameters from overriding kubelet default kernel parameter values.\n\nRationale: Kernel parameters are usually tuned and hardened by the system administrators before putting the systems into production. These parameters protect the kernel and the system. Your kubelet kernel defaults that rely on such parameters should be appropriately set to match the desired secured system state. Ignoring this could potentially lead to running pods with undesired kernel behavior."
  impact 1.0

  tag cis: 'kubernetes:2.1.6'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--protect-kernel-defaults=true/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.7' do
  title 'Ensure that the --make-iptables-util-chains argument is set to true'
  desc "Allow Kubelet to manage iptables.\n\nRationale: Kubelets can automatically manage the required changes to iptables based on how you choose your networking options for the pods. It is recommended to let kubelets manage the changes to iptables. This ensures that the iptables configuration remains in sync with pods networking configuration. Manually configuring iptables with dynamic pod network configuration changes might hamper the communication between pods/containers and to the outside world. You might have iptables rules too restrictive or too open."
  impact 1.0

  tag cis: 'kubernetes:2.1.7'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--make-iptables-util-chains=true/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.8' do
  title 'Ensure that the --hostname-override argument is not set'
  desc "Do not override node hostnames.\n\nRationale: Overriding hostnames could potentially break TLS setup between the kubelet and the apiserver. Additionally, with overridden hostnames, it becomes increasingly difficult to associate logs with a particular node and process them for security analytics. Hence, you should setup your kubelet nodes with resolvable FQDNs and avoid overriding the hostnames with IPs."
  impact 1.0

  tag cis: 'kubernetes:2.1.8'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should_not match(/--hostname-override/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.9' do
  title 'Ensure that the --event-qps argument is set to 0'
  desc "Do not limit event creation.\n\nRationale: It is important to capture all events and not restrict event creation. Events are an important source of security information and analytics that ensure that your environment is consistently monitored using the event data."
  impact 1.0

  tag cis: 'kubernetes:2.1.9'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--event-qps=0/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.10' do
  title 'Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate'
  desc "Setup TLS connection on the Kubelets.\n\nRationale: Kubelet communication contains sensitive parameters that should remain encrypted in transit. Configure the Kubelets to serve only HTTPS traffic."
  impact 1.0

  tag cis: 'kubernetes:2.1.10'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--tls-cert-file=/) }
    it { should match(/--tls-private-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.11' do
  title '[Deprecated] Ensure that the --cadvisor-port argument is set to 0'
  desc "[Deprecated] Disable cAdvisor.\n\nRationale: cAdvisor provides potentially sensitive data and there's currently no way to block access to it using anything other than iptables. It does not require authentication/authorization to connect to the cAdvisor port. Hence, you should disable the port.\n**Note** The cAdvisor port setting was deprecated in Kubernetes v1.10 and will be removed in v1.12."
  impact 0.0

  tag cis: 'kubernetes:2.1.11'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--cadvisor-port=0/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.12' do
  title 'Ensure that the --rotate-certificates argument is not set to false'
  desc "Enable kubelet client certificate rotation.\n\nRationale: The `--rotate-certificates` setting causes the kubelet to rotate its client certificates by creating new CSRs as its existing credentials expire. This automated periodic rotation ensures that the there are no downtimes due to expired certificates and thus addressing availability in the CIA security triad.\n**Note:**This recommendation only applies if you let kubelets get their certificates from the API server. In case your kubelet certificates come from an outside authority/tool (e.g. Vault) then you need to take care of rotation yourself.\n**Note:** This feature also require the `RotateKubeletClientCertificate` feature gate to be enabled (which is the default since Kubernetes v1.7)"
  impact 1.0

  tag cis: 'kubernetes:2.1.12'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--feature-gates=(?:.)*RotateKubeletClientCertificate=true,*(?:.)*/) }
    it { should match(/--rotate-certificates=true/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.13' do
  title 'Ensure that the RotateKubeletServerCertificate argument is set to true'
  desc "Enable kubelet server certificate rotation.\n\nRationale: `RotateKubeletServerCertificate` causes the kubelet to both request a serving certificate after bootstrapping its client credentials and rotate the certificate as its existing credentials expire. This automated periodic rotation ensures that the there are no downtimes due to expired certificates and thus addressing availability in the CIA security triad.\nNote: This recommendation only applies if you let kubelets get their certificates from the API server. In case your kubelet certificates come from an outside authority/tool (e.g. Vault) then you need to take care of rotation yourself."
  impact 1.0

  tag cis: 'kubernetes:2.1.13'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--feature-gates=(?:.)*RotateKubeletServerCertificate=true,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-2.1.14' do
  title 'Ensure that the Kubelet only makes use of Strong Cryptographic Ciphers'
  desc "Ensure that the Kubelet is configured to only use strong cryptographic ciphers.\n\nRationale: TLS ciphers have had a number of known vulnerabilities and weaknesses, which can reduce the protection provided by them. By default Kubernetes supports a number of TLS ciphersuites including some that have security concerns, weakening the protection provided."
  impact 0.0

  tag cis: 'kubernetes:2.1.14'
  tag level: 1

  describe processes(kubelet).commands.to_s do
    it { should match(/--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256/) }
  end
end
