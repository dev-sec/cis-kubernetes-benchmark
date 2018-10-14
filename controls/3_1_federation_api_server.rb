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

title '3.1 Federation API Server'

federation_apiserver = attribute('federation_apiserver')
# fallback if federation_apiserver attribute is not defined
federation_apiserver = kubernetes.federation_apiserver_bin if federation_apiserver.empty?

only_if('federation api server not found') do
  processes(federation_apiserver).exists?
end

control 'cis-kubernetes-benchmark-3.1.1' do
  title 'Ensure that the --anonymous-auth argument is set to false'
  desc "Disable anonymous requests to the federation API server.\n\nRationale: When enabled, requests that are not rejected by other configured authentication methods are treated as anonymous requests. These requests are then served by the federation API server. You should rely on authentication to authorize access and disallow anonymous requests."
  impact 1.0

  tag cis: 'kubernetes:3.1.1'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--anonymous-auth=false/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.2' do
  title 'Ensure that the --basic-auth-file argument is not set'
  desc "Do not use basic authentication.\n\nRationale: Basic authentication uses plaintext credentials for authentication. Currently, the basic authentication credentials last indefinitely, and the password cannot be changed without restarting the federation API server. The basic authentication is currently supported for convenience. Hence, basic authentication should not be used."
  impact 1.0

  tag cis: 'kubernetes:3.1.2'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should_not match(/--basic-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.3' do
  title 'Ensure that the --insecure-allow-any-token argument is not set'
  desc "Do not allow any insecure tokens.\n\nRationale: Accepting insecure tokens would allow any token without actually authenticating anything. User information is parsed from the token and connections are allowed."
  impact 1.0

  tag cis: 'kubernetes:3.1.3'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should_not match(/--insecure-allow-any-token/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.4' do
  title 'Ensure that the --insecure-bind-address argument is not set'
  desc "Do not bind to insecure addresses.\n\nRationale: If you bind the federation apiserver to an insecure address, basically anyone who could connect to it over the insecure port, would have unauthenticated and unencrypted access to it. The federation apiserver doesn't do any authentication checking for insecure binds and neither the insecure traffic is encrypted. Hence, you should not bind the federation apiserver to an insecure address."
  impact 1.0

  tag cis: 'kubernetes:3.1.4'
  tag level: 1

  describe.one do
    describe processes(federation_apiserver).commands.to_s do
      it { should match(/--insecure-bind-address=127\.0\.0\.1/) }
    end
    describe processes(federation_apiserver).commands.to_s do
      it { should_not match(/--insecure-bind-address/) }
    end
  end
end

control 'cis-kubernetes-benchmark-3.1.5' do
  title 'Ensure that the --insecure-port argument is set to 0'
  desc "Do not bind to insecure port.\n\nRationale: Setting up the federation apiserver to serve on an insecure port would allow unauthenticated and unencrypted access to it. It is assumed that firewall rules are set up such that this port is not reachable from outside of the cluster. But, as a defense in depth measure, you should not use an insecure port."
  impact 1.0

  tag cis: 'kubernetes:3.1.5'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--insecure-port=0/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.6' do
  title 'Ensure that the --secure-port argument is not set to 0'
  desc "Do not disable the secure port.\n\nRationale: The secure port is used to serve https with authentication and authorization. If you disable it, no https traffic is served and all traffic is served unencrypted."
  impact 1.0

  tag cis: 'kubernetes:3.1.6'
  tag level: 1

  describe.one do
    describe processes(federation_apiserver).commands.to_s do
      it { should match(/--secure-port=([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])/) }
    end
    describe processes(federation_apiserver).commands.to_s do
      it { should_not match(/--secure-port/) }
    end
  end
end

control 'cis-kubernetes-benchmark-3.1.7' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:3.1.7'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.8' do
  title 'Ensure that the admission control policy is not set to AlwaysAdmit'
  desc "Do not allow all requests.\n\nRationale: Setting admission control policy to `AlwaysAdmit` allows all requests and do not filter any requests."
  impact 1.0

  tag cis: 'kubernetes:3.1.8'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should_not match(/--admission-control=(?:.)*AlwaysAdmit,*(?:.)*/) }
    it { should match(/--admission-control=/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.9' do
  title 'Ensure that the admission control policy is set to NamespaceLifecycle'
  desc "Reject creating objects in a namespace that is undergoing termination.\n\nRationale: Setting admission control policy to `NamespaceLifecycle` ensures that the namespaces undergoing termination are not used for creating the new objects. This is recommended to enforce the integrity of the namespace termination process and also for the availability of the newer objects."
  impact 1.0

  tag cis: 'kubernetes:3.1.9'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*NamespaceLifecycle,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.10' do
  title 'Ensure that the --audit-log-path argument is set as appropriate'
  desc "Enable auditing on kubernetes federation apiserver and set the desired audit log path as appropriate.\n\nRationale: Auditing Kubernetes federation apiserver provides a security-relevant chronological set of records documenting the sequence of activities that have affected system by individual users, administrators or other components of the system. Even though currently, Kubernetes provides only basic audit capabilities, it should be enabled. You can enable it by setting an appropriate audit log path."
  impact 1.0

  tag cis: 'kubernetes:3.1.10'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--audit-log-path=/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.11' do
  title 'Ensure that the --audit-log-maxage argument is set to 30 or as appropriate'
  desc "Retain the logs for at least 30 days or as appropriate.\n\nRationale: Retaining logs for at least 30 days ensures that you can go back in time and investigate or correlate any events. Set your audit log retention period to 30 days or as per your business requirements."
  impact 1.0

  tag cis: 'kubernetes:3.1.11'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--audit-log-maxage=/) }
  end

  audit_log_maxage = processes(federation_apiserver).commands.to_s.scan(/--audit-log-maxage=(\d+)/)

  unless audit_log_maxage.empty?
    describe audit_log_maxage.last.first.to_i do
      it { should cmp >= 30 }
    end
  end
end

control 'cis-kubernetes-benchmark-3.1.12' do
  title 'Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate'
  desc "Retain 10 or an appropriate number of old log files.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. For example, if you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:3.1.12'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--audit-log-maxbackup=/) }
  end

  audit_log_maxbackup = processes(federation_apiserver).commands.to_s.scan(/--audit-log-maxbackup=(\d+)/)

  unless audit_log_maxbackup.empty?
    describe audit_log_maxbackup.last.first.to_i do
      it { should cmp >= 10 }
    end
  end
end

control 'cis-kubernetes-benchmark-3.1.13' do
  title 'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate'
  desc "Rotate log files on reaching 100 MB or as appropriate.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. If you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:3.1.13'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--audit-log-maxsize=/) }
  end

  audit_log_maxsize = processes(federation_apiserver).commands.to_s.scan(/--audit-log-maxsize=(\d+)/)

  unless audit_log_maxsize.empty?
    describe audit_log_maxsize.last.first.to_i do
      it { should cmp >= 100 }
    end
  end
end

control 'cis-kubernetes-benchmark-3.1.14' do
  title 'Ensure that the --authorization-mode argument is not set to AlwaysAllow'
  desc "Do not always authorize all requests.\n\nRationale: The federation apiserver, by default, allows all requests. You should restrict this behavior to only allow the authorization modes that you explicitly use in your environment. For example, if you don't use REST APIs in your environment, it is a good security best practice to switch-off that capability."
  impact 1.0

  tag cis: 'kubernetes:3.1.14'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should_not match(/--authorization-mode=(?:.)*AlwaysAllow,*(?:.)*/) }
    it { should match(/--authorization-mode=/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.15' do
  title 'Ensure that the --token-auth-file parameter is not set'
  desc "Do not use token based authentication.\n\nRationale: The token-based authentication utilizes static tokens to authenticate requests to the federation apiserver. The tokens are stored in clear-text in a file on the federation apiserver, and cannot be revoked or rotated without restarting the federation apiserver. Hence, do not use static token-based authentication."
  impact 1.0

  tag cis: 'kubernetes:3.1.15'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should_not match(/--token-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.16' do
  title 'Ensure that the --service-account-lookup argument is set to true'
  desc "Validate service account before validating token.\n\nRationale: By default, the apiserver only verifies that the authentication token is valid. However, it does not validate that the service account token mentioned in the request is actually present in etcd. This allows using a service account token even after the corresponding service account is deleted. This is an example of time of check to time of use security issue."
  impact 1.0

  tag cis: 'kubernetes:3.1.16'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--service-account-lookup=true/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.17' do
  title 'Ensure that the --service-account-key-file argument is set as appropriate'
  desc "Explicitly set a service account public key file for service accounts on the federation apiserver.\n\nRationale: By default, if no `--service-account-key-file` is specified to the federation apiserver, it uses the private key from the TLS serving certificate to verify the account tokens. To ensure that the keys for service account tokens could be rotated as needed, a separate public/private key pair should be used for signing service account tokens. Hence, the public key should be specified to the apiserver with `--service-account-key-file`."
  impact 1.0

  tag cis: 'kubernetes:3.1.17'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--service-account-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.18' do
  title 'Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for client connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be protected by client authentication. This requires the federation API server to identify itself to the etcd server using a client certificate and key."
  impact 1.0

  tag cis: 'kubernetes:3.1.18'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--etcd-certfile=/) }
    it { should match(/--etcd-keyfile=/) }
  end
end

control 'cis-kubernetes-benchmark-3.1.19' do
  title 'Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate'
  desc "Setup TLS connection on the federation API server.\n\nRationale: Federation API server communication contains sensitive parameters that should remain encrypted in transit. Configure the federation API server to serve only HTTPS traffic."
  impact 1.0

  tag cis: 'kubernetes:3.1.19'
  tag level: 1

  describe processes(federation_apiserver).commands.to_s do
    it { should match(/--tls-cert-file=/) }
    it { should match(/--tls-private-key-file=/) }
  end
end
