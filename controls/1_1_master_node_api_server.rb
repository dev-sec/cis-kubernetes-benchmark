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

title '1.1 Master Node: API Server'

apiserver = attribute('apiserver')
# fallback if apiserver attribute is not defined
apiserver = kubernetes.apiserver_bin if apiserver.empty?

only_if('apiserver not found') do
  processes(apiserver).exists?
end

control 'cis-kubernetes-benchmark-1.1.1' do
  title 'Ensure that the --anonymous-auth argument is set to false'
  desc "Disable anonymous requests to the API server.\n\nRationale: When enabled, requests that are not rejected by other configured authentication methods are treated as anonymous requests. These requests are then served by the API server. You should rely on authentication to authorize access and disallow anonymous requests."
  impact 1.0

  tag cis: 'kubernetes:1.1.1'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--anonymous-auth=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.2' do
  title 'Ensure that the --basic-auth-file argument is not set'
  desc "Do not use basic authentication.\n\nRationale: Basic authentication uses plaintext credentials for authentication. Currently, the basic authentication credentials last indefinitely, and the password cannot be changed without restarting API server. The basic authentication is currently supported for convenience. Hence, basic authentication should not be used."
  impact 1.0

  tag cis: 'kubernetes:1.1.2'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--basic-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.3' do
  title 'Ensure that the --insecure-allow-any-token argument is not set'
  desc "Do not allow any insecure tokens\n\nRationale: Accepting insecure tokens would allow any token without actually authenticating anything. User information is parsed from the token and connections are allowed."
  impact 1.0

  tag cis: 'kubernetes:1.1.3'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--insecure-allow-any-token/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.4' do
  title 'Ensure that the --kubelet-https argument is set to true'
  desc "Use https for kubelet connections.\n\nRationale: Connections from apiserver to kubelets could potentially carry sensitive data such as secrets and keys. It is thus important to use in-transit encryption for any communication between the apiserver and kubelets."
  impact 1.0

  tag cis: 'kubernetes:1.1.4'
  tag level: 1

  describe.one do
    describe processes(apiserver).commands.to_s do
      it { should match(/--kubelet-https=true/) }
    end
    describe processes(apiserver).commands.to_s do
      it { should_not match(/--kubelet-https/) }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.5' do
  title 'Ensure that the --insecure-bind-address argument is not set'
  desc "Do not bind to non-loopback insecure addresses.\n\nRationale: If you bind the apiserver to an insecure address, basically anyone who could connect to it over the insecure port, would have unauthenticated and unencrypted access to your master node. The apiserver doesn't do any authentication checking for insecure binds and neither the insecure traffic is encrypted. Hence, you should not bind the apiserver to an insecure address."
  impact 1.0

  tag cis: 'kubernetes:1.1.5'
  tag level: 1

  describe.one do
    describe processes(apiserver).commands.to_s do
      it { should match(/--insecure-bind-address=127\.0\.0\.1/) }
    end
    describe processes(apiserver).commands.to_s do
      it { should_not match(/--insecure-bind-address/) }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.6' do
  title 'Ensure that the --insecure-port argument is set to 0'
  desc "Do not bind to insecure port.\n\nRationale: Setting up the apiserver to serve on an insecure port would allow unauthenticated and unencrypted access to your master node. It is assumed that firewall rules are set up such that this port is not reachable from outside of the cluster. But, as a defense in depth measure, you should not use an insecure port."
  impact 1.0

  tag cis: 'kubernetes:1.1.6'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--insecure-port=0/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.7' do
  title 'Ensure that the --secure-port argument is not set to 0'
  desc "Do not disable the secure port.\n\nRationale: The secure port is used to serve https with authentication and authorization. If you disable it, no https traffic is served and all traffic is served unencrypted."
  impact 1.0

  tag cis: 'kubernetes:1.1.7'
  tag level: 1

  describe.one do
    describe processes(apiserver).commands.to_s do
      it { should match(/--secure-port=([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])/) }
    end
    describe processes(apiserver).commands.to_s do
      it { should_not match(/--secure-port/) }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.8' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.1.8'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.9' do
  title 'Ensure that the --repair-malformed-updates argument is set to false'
  desc "Disable fixing of malformed updates.\n\nRationale: The apiserver will potentially attempt to fix the update requests to pass the validation even if the requests are malformed. Malformed requests are one of the potential ways to interact with a service without legitimate information. Such requests could potentially be used to sabotage apiserver responses."
  impact 1.0

  tag cis: 'kubernetes:1.1.9'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--repair-malformed-updates=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.10' do
  title 'Ensure that the admission control policy is not set to AlwaysAdmit'
  desc "Do not allow all requests.\n\nRationale: Setting admission control policy to `AlwaysAdmit` allows all requests and do not filter any requests."
  impact 1.0

  tag cis: 'kubernetes:1.1.10'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--admission-control=(?:.)*AlwaysAdmit,*(?:.)*/) }
    it { should match(/--admission-control=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.11' do
  title 'Ensure that the admission control policy is set to AlwaysPullImages'
  desc "Always pull images.\n\nRationale: Setting admission control policy to `AlwaysPullImages` forces every new pod to pull the required images every time. In a multitenant cluster users can be assured that their private images can only be used by those who have the credentials to pull them. Without this admisssion control policy, once an image has been pulled to a node, any pod from any user can use it simply by knowing the image's name, without any authorization check against the image ownership. When this plug-in is enabled, images are always pulled prior to starting containers, which means valid credentials are required."
  impact 1.0

  tag cis: 'kubernetes:1.1.11'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*AlwaysPullImages,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.12' do
  title 'Ensure that the admission control policy is set to DenyEscalatingExec'
  desc "Deny execution of `exec` and `attach` commands in privileged pods.\n\nRationale: Setting admission control policy to `DenyEscalatingExec` denies `exec` and `attach` commands to pods that run with escalated privileges that allow host access. This includes pods that run as privileged, have access to the host IPC namespace, and have access to the host PID namespace."
  impact 1.0

  tag cis: 'kubernetes:1.1.12'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*DenyEscalatingExec,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.13' do
  title 'Ensure that the admission control policy is set to SecurityContextDeny'
  desc "Restrict pod level SecurityContext customization. Instead of using a customized SecurityContext for your pods, use a Pod Security Policy (PSP), which is a cluster-level resource that controls the actions that a pod can perform and what it has the ability to access.\n\nRationale: Setting admission control policy to `SecurityContextDeny` denies the pod level SecurityContext customization. Any attempts to customize the SecurityContexts that are not explicitly defined in the Pod Security Policy (PSP) are blocked. This ensures that all the pods adhere to the PSP defined by your organization and you have a uniform pod level security posture."
  impact 1.0

  tag cis: 'kubernetes:1.1.13'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*SecurityContextDeny,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.14' do
  title 'Ensure that the admission control policy is set to NamespaceLifecycle'
  desc "Reject creating objects in a namespace that is undergoing termination.\n\nRationale: Setting admission control policy to `NamespaceLifecycle` ensures that objects cannot be created in non-existent namespaces, and that namespaces undergoing termination are not used for creating the new objects. This is recommended to enforce the integrity of the namespace termination process and also for the availability of the newer objects."
  impact 1.0

  tag cis: 'kubernetes:1.1.14'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*NamespaceLifecycle,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.15' do
  title 'Ensure that the --audit-log-path argument is set as appropriate'
  desc "Enable auditing on kubernetes apiserver and set the desired audit log path as appropriate.\n\nRationale: Auditing Kubernetes apiserver provides a security-relevant chronological set of records documenting the sequence of activities that have affected system by individual users, administrators or other components of the system. Even though currently, Kubernetes provides only basic audit capabilities, it should be enabled. You can enable it by setting an appropriate audit log path."
  impact 1.0

  tag cis: 'kubernetes:1.1.15'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-path=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.16' do
  title 'Ensure that the --audit-log-maxage argument is set to 30 or as appropriate'
  desc "Retain the logs for at least 30 days or as appropriate.\n\nRationale: Retaining logs for at least 30 days ensures that you can go back in time and investigate or correlate any events. Set your audit log retention period to 30 days or as per your business requirements."
  impact 1.0

  tag cis: 'kubernetes:1.1.16'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxage=/) }
  end

  audit_log_maxage = processes(apiserver).commands.to_s.scan(/--audit-log-maxage=(\d+)/)

  unless audit_log_maxage.empty?
    describe audit_log_maxage.last.first.to_i do
      it { should cmp >= 30 }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.17' do
  title 'Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate'
  desc "Retain 10 or an appropriate number of old log files.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. For example, if you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:1.1.17'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxbackup=/) }
  end

  audit_log_maxbackup = processes(apiserver).commands.to_s.scan(/--audit-log-maxbackup=(\d+)/)

  unless audit_log_maxbackup.empty?
    describe audit_log_maxbackup.last.first.to_i do
      it { should cmp >= 10 }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.18' do
  title 'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate'
  desc "Rotate log files on reaching 100 MB or as appropriate.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. If you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:1.1.18'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxsize=/) }
  end

  audit_log_maxsize = processes(apiserver).commands.to_s.scan(/--audit-log-maxsize=(\d+)/)

  unless audit_log_maxsize.empty?
    describe audit_log_maxsize.last.first.to_i do
      it { should cmp >= 100 }
    end
  end
end

control 'cis-kubernetes-benchmark-1.1.19' do
  title 'Ensure that the --authorization-mode argument is not set to AlwaysAllow'
  desc "Do not always authorize all requests.\n\nRationale: The apiserver, by default, allows all requests. You should restrict this behavior to only allow the authorization modes that you explicitly use in your environment. For example, if you don't use REST APIs in your environment, it is a good security best practice to switch off that capability."
  impact 1.0

  tag cis: 'kubernetes:1.1.19'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--authorization-mode=(?:.)*AlwaysAllow,*(?:.)*/) }
    it { should match(/--authorization-mode=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.20' do
  title 'Ensure that the --token-auth-file parameter is not set'
  desc "Do not use token based authentication.\n\nRationale: The token-based authentication utilizes static tokens to authenticate requests to the apiserver. The tokens are stored in clear-text in a file on the apiserver, and cannot be revoked or rotated without restarting the apiserver. Hence, do not use static token-based authentication."
  impact 1.0

  tag cis: 'kubernetes:1.1.20'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--token-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.21' do
  title 'Ensure that the --kubelet-certificate-authority argument is set as appropriate'
  desc "Verify kubelet's certificate before establishing connection.\n\nRationale: The connections from the apiserver to the kubelet are used for fetching logs for pods, attaching (through kubectl) to running pods, and using the kubelet's port-forwarding functionality. These connections terminate at the kubelet's HTTPS endpoint. By default, the apiserver does not verify the kubelet's serving certificate, which makes the connection subject to man-in-the-middle attacks, and unsafe to run over untrusted and/or public networks."
  impact 1.0

  tag cis: 'kubernetes:1.1.21'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--kubelet-certificate-authority=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.22' do
  title 'Ensure that the --kubelet-client-certificate and --kubelet-client-key arguments are set as appropriate'
  desc "Enable certificate based kubelet authentication.\n\nRationale: The apiserver, by default, does not authenticate itself to the kubelet's HTTPS endpoints. The requests from the apiserver are treated anonymously. You should set up certificate-based kubelet authentication to ensure that the apiserver authenticates itself to kubelets when submitting requests."
  impact 1.0

  tag cis: 'kubernetes:1.1.22'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--kubelet-client-certificate=/) }
    it { should match(/--kubelet-client-key=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.23' do
  title 'Ensure that the --service-account-lookup argument is set to true'
  desc "Validate service account before validating token.\n\nRationale: By default, the apiserver only verifies that the authentication token is valid. However, it does not validate that the service account token mentioned in the request is actually present in etcd. This allows using a service account token even after the corresponding service account is deleted. This is an example of time of check to time of use security issue."
  impact 1.0

  tag cis: 'kubernetes:1.1.23'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--service-account-lookup=true/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.24' do
  title 'Ensure that the admission control policy is set to PodSecurityPolicy'
  desc "Reject creating pods that do not match Pod Security Policies.\n\nRationale: A Pod Security Policy is a cluster-level resource that controls the actions that a pod can perform and what it has the ability to access. The `PodSecurityPolicy` objects define a set of conditions that a pod must run with in order to be accepted into the system. Pod Security Policies are comprised of settings and strategies that control the security features a pod has access to and hence this must be used to control pod access permissions."
  impact 1.0

  tag cis: 'kubernetes:1.1.25'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*PodSecurityPolicy,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.25' do
  title 'Ensure that the --service-account-key-file argument is set as appropriate'
  desc "Explicitly set a service account public key file for service accounts on the apiserver.\n\nRationale: By default, if no `--service-account-key-file` is specified to the apiserver, it uses the private key from the TLS serving certificate to verify service account tokens. To ensure that the keys for service account tokens could be rotated as needed, a separate public/private key pair should be used for signing service account tokens. Hence, the public key should be specified to the apiserver with `--service-account-key-file`."
  impact 1.0

  tag cis: 'kubernetes:1.1.25'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--service-account-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.26' do
  title 'Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for client connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be protected by client authentication. This requires the API server to identify itself to the etcd server using a client certificate and key."
  impact 1.0

  tag cis: 'kubernetes:1.1.26'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--etcd-certfile=/) }
    it { should match(/--etcd-keyfile=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.27' do
  title 'Ensure that the admission control policy is set to ServiceAccount'
  desc "Automate service accounts management.\n\nRationale: When you create a pod, if you do not specify a service account, it is automatically assigned the `default` service account in the same namespace. You should create your own service account and let the API server manage its security tokens."
  impact 1.0

  tag cis: 'kubernetes:1.1.27'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*ServiceAccount,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.28' do
  title 'Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate'
  desc "Setup TLS connection on the API server.\n\nRationale: API server communication contains sensitive parameters that should remain encrypted in transit. Configure the API server to serve only HTTPS traffic."
  impact 1.0

  tag cis: 'kubernetes:1.1.28'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--tls-cert-file=/) }
    it { should match(/--tls-private-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.29' do
  title 'Ensure that the --client-ca-file argument is set as appropriate'
  desc "Setup TLS connection on the API server.\n\nRationale: API server communication contains sensitive parameters that should remain encrypted in transit. Configure the API server to serve only HTTPS traffic. If `--client-ca-file` argument is set, any request presenting a client certificate signed by one of the authorities in the `client-ca-file` is authenticated with an identity corresponding to the CommonName of the client certificate."
  impact 1.0

  tag cis: 'kubernetes:1.1.29'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--client-ca-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.30' do
  title 'Ensure that the --etcd-cafile argument is set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for client connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be protected by client authentication. This requires the API server to identify itself to the etcd server using a SSL Certificate Authority file."
  impact 1.0

  tag cis: 'kubernetes:1.1.30'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--etcd-cafile/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.31' do
  title 'Ensure that the --authorization-mode argument is set to Node'
  desc "Restrict kubelet nodes to reading only objects associated with them.\n\nRationale: The Node authorization mode only allows kubelets to read Secret, ConfigMap, PersistentVolume, and PersistentVolumeClaim objects associated with their nodes."
  impact 1.0

  tag cis: 'kubernetes:1.1.31'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--authorization-mode=(?:.)*Node,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.32' do
  title 'Ensure that the admission control policy is set to NodeRestriction'
  desc "Limit the Node and Pod objects that a kubelet could modify.\n\nRationale: Using the NodeRestriction plug-in ensures that the kubelet is restricted to the Node and Pod objects that it could modify as defined. Such kubelets will only be allowed to modify their own Node API object, and only modify Pod API objects that are bound to their node."
  impact 1.0

  tag cis: 'kubernetes:1.1.32'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*NodeRestriction,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.33' do
  title 'Ensure that the --experimental-encryption-provider-config argument is set as appropriate'
  desc "Encrypt etcd key-value store.\n\nRationale: etcd is a highly available key-value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be encrypted at rest to avoid any disclosures."
  impact 1.0

  tag cis: 'kubernetes:1.1.33'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--experimental-encryption-provider-config=/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.34' do
  title 'Ensure that the encryption provider is set to aescbc'
  desc "Use aescbc encryption provider.\n\nRationale: aescbc is currently the strongest encryption provider, It should be preferred over other providers."
  impact 1.0

  tag cis: 'kubernetes:1.1.34'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.1.34' do
    skip 'Review the `EncryptionConfig` file and verify that `aescbc` is used as the encryption provider.'
  end
end

control 'cis-kubernetes-benchmark-1.1.35' do
  title 'Ensure that the admission control policy is set to EventRateLimit'
  desc "Limit the rate at which the API server accepts requests.\n\nRationale: Using EventRateLimit admission control enforces a limit on the number of events that the API Server will accept in a given time slice. In a large multi-tenant cluster, there might be a small percentage of misbehaving tenants which could have a significant impact on the performance of the cluster overall. Hence, it is recommended to limit the rate of events that the API server will accept.\nNote: This is an Alpha feature in the Kubernetes 1.8 release."
  impact 1.0

  tag cis: 'kubernetes:1.1.35'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--admission-control=(?:.)*EventRateLimit,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.36' do
  title 'Ensure that the AdvancedAuditing argument is not set to false'
  desc "Do not disable advanced auditing.\n\nRationale: AdvancedAuditing enables a much more general API auditing pipeline, which includes support for pluggable output backends and an audit policy specifying how different requests should be audited. Additionally, this enables auditing of failed authentication, authorization and login attempts which could prove crucial for protecting your production clusters. It is thus recommended not to disable advanced auditing."
  impact 1.0

  tag cis: 'kubernetes:1.1.36'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--feature-gates=(?:.)*AdvancedAuditing=false,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.1.37' do
  title 'Ensure that the --request-timeout argument is set as appropriate'
  desc "Set global request timeout for API server requests as appropriate.\n\nRationale: Setting global request timeout allows extending the API server request timeout limit to a duration appropriate to the user's connection speed. By default, it is set to 60 seconds which might be problematic on slower connections making cluster resources inaccessible once the data volume for requests exceeds what can be transmitted in 60 seconds. But, setting this timeout limit to be too large can exhaust the API server resources making it prone to Denial-of-Service attack. Hence, it is recommended to set this limit as appropriate and change the default limit of 60 seconds only if needed."
  impact 1.0

  tag cis: 'kubernetes:1.1.37'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.1.37' do
    skip 'If you have a request timeout set, verify that it is set to an appropriate value'
  end
end
