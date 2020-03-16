title '1.2 Master Node: API Server'

apiserver = attribute('apiserver')
# fallback if apiserver attribute is not defined
apiserver = kubernetes.apiserver_bin if apiserver.empty?

only_if('apiserver not found') do
  processes(apiserver).exists?
end

control 'cis-kubernetes-benchmark-1.2.1' do
  title 'Ensure that the --anonymous-auth argument is set to false'
  desc "Disable anonymous requests to the API server.\n\nRationale: When enabled, requests that are not rejected by other configured authentication methods are treated as anonymous requests. These requests are then served by the API server. You should rely on authentication to authorize access and disallow anonymous requests.\nIf you are using RBAC authorization, it is generally considered reasonable to allow anonymous access to the API Server for health checks and discovery purposes, and hence this recommendation is not scored. However, you should consider whether anonymous discovery is an acceptable risk for your purposes."
  impact 0.0

  tag cis: 'kubernetes:1.2.1'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--anonymous-auth=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.2' do
  title 'Ensure that the --basic-auth-file argument is not set'
  desc "Do not use basic authentication.\n\nRationale: Basic authentication uses plaintext credentials for authentication. Currently, the basic authentication credentials last indefinitely, and the password cannot be changed without restarting API server. The basic authentication is currently supported for convenience. Hence, basic authentication should not be used."
  impact 1.0

  tag cis: 'kubernetes:1.2.2'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--basic-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.3' do
  title 'Ensure that the --token-auth-file parameter is not set'
  desc "Do not use token based authentication.\n\nRationale: The token-based authentication utilizes static tokens to authenticate requests to the apiserver. The tokens are stored in clear-text in a file on the apiserver, and cannot be revoked or rotated without restarting the apiserver. Hence, do not use static token-based authentication."
  impact 1.0

  tag cis: 'kubernetes:1.2.3'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--token-auth-file/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.4' do
  title 'Ensure that the --kubelet-https argument is set to true'
  desc "Use https for kubelet connections.\n\nRationale: Connections from apiserver to kubelets could potentially carry sensitive data such as secrets and keys. It is thus important to use in-transit encryption for any communication between the apiserver and kubelets."
  impact 1.0

  tag cis: 'kubernetes:1.2.4'
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

control 'cis-kubernetes-benchmark-1.2.5' do
  title 'Ensure that the --kubelet-client-certificate and --kubelet-client-key arguments are set as appropriate'
  desc "Enable certificate based kubelet authentication.\n\nRationale: The apiserver, by default, does not authenticate itself to the kubelet's HTTPS endpoints. The requests from the apiserver are treated anonymously. You should set up certificate-based kubelet authentication to ensure that the apiserver authenticates itself to kubelets when submitting requests."
  impact 1.0

  tag cis: 'kubernetes:1.2.5'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--kubelet-client-certificate=/) }
    it { should match(/--kubelet-client-key=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.6' do
  title 'Ensure that the --kubelet-certificate-authority argument is set as appropriate'
  desc "Verify kubelet's certificate before establishing connection.\n\nRationale: The connections from the apiserver to the kubelet are used for fetching logs for pods, attaching (through kubectl) to running pods, and using the kubelet's port-forwarding functionality. These connections terminate at the kubelet's HTTPS endpoint. By default, the apiserver does not verify the kubelet's serving certificate, which makes the connection subject to man-in-the-middle attacks, and unsafe to run over untrusted and/or public networks."
  impact 1.0

  tag cis: 'kubernetes:1.2.6'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--kubelet-certificate-authority=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.7' do
  title 'Ensure that the --authorization-mode argument is not set to AlwaysAllow'
  desc "Do not always authorize all requests.\n\nRationale: The API Server, can be configured to allow all requests. This mode should not be used on any production cluster."
  impact 1.0

  tag cis: 'kubernetes:1.2.7'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--authorization-mode=(?:.)*AlwaysAllow,*(?:.)*/) }
    it { should match(/--authorization-mode=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.8' do
  title 'Ensure that the --authorization-mode argument includes Node'
  desc "Restrict kubelet nodes to reading only objects associated with them.\n\nRationale: The Node authorization mode only allows kubelets to read `Secret`, `ConfigMap`, `PersistentVolume`, and `PersistentVolumeClaim` objects associated with their nodes."
  impact 1.0

  tag cis: 'kubernetes:1.2.8'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--authorization-mode=(?:.)*Node,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.9' do
  title 'Ensure that the --authorization-mode argument includes RBAC'
  desc "Turn on Role Based Access Control.\n\nRationale: Role Based Access Control (RBAC) allows fine-grained control over the operations that different entities can perform on different objects in the cluster. It is recommended to use the RBAC authorisation mode."
  impact 1.0

  tag cis: 'kubernetes:1.2.9'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--authorization-mode=(?:.)*RBAC,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.10' do
  title 'Ensure that the admission control plugin EventRateLimit is set'
  desc "Limit the rate at which the API server accepts requests.\n\nRationale: Using `EventRateLimit` admission control enforces a limit on the number of events that the API Server will accept in a given time slice. In a large multi-tenant cluster, there might be a small percentage of misbehaving tenants which could have a significant impact on the performance of the cluster overall. Hence, it is recommended to limit the rate of events that the API server will accept.\nNote: This is an Alpha feature in the Kubernetes 1.11 release."
  impact 1.0

  tag cis: 'kubernetes:1.2.10'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--enable-admission-plugins=(?:.)*EventRateLimit,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.11' do
  title 'Ensure that the admission control plugin AlwaysAdmit is not set'
  desc "Do not allow all requests.\n\nRationale: Setting admission control plugin `AlwaysAdmit` allows all requests and do not filter any requests."
  impact 1.0

  tag cis: 'kubernetes:1.2.11'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--enable-admission-plugins=(?:.)*AlwaysAdmit,*(?:.)*/) }
    it { should match(/--enable-admission-plugins=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.12' do
  title 'Ensure that the admission control plugin AlwaysPullImages is set'
  desc "Always pull images.\n\nRationale: Setting admission control policy to `AlwaysPullImages` forces every new pod to pull the required images every time. In a multitenant cluster users can be assured that their private images can only be used by those who have the credentials to pull them. Without this admisssion control policy, once an image has been pulled to a node, any pod from any user can use it simply by knowing the image's name, without any authorization check against the image ownership. When this plug-in is enabled, images are always pulled prior to starting containers, which means valid credentials are required."
  impact 1.0

  tag cis: 'kubernetes:1.2.12'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--enable-admission-plugins=(?:.)*AlwaysPullImages,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.13' do
  title 'Ensure that the admission control plugin SecurityContextDeny is set if PodSecurityPolicy is not used'
  desc "The SecurityContextDeny admission controller can be used to deny pods which make use of some SecurityContext fields which could allow for privilege escalation in the cluster. This
  should be used where PodSecurityPolicy is not in place within the cluster.\nRationale: SecurityContextDeny can be used to provide a layer of security for clusters which do not
  have PodSecurityPolicies enabled."
  impact 1.0

  tag cis: 'kubernetes:1.2.13'
  tag level: 1

  describe.one do
    describe processes(apiserver).commands.to_s do
      it { should match(/--enable-admission-plugins=(?:.)*SecurityContextDeny,*(?:.)*/) }
      it { should_not match(/--enable-admission-plugins=(?:.)*PodSecurityPolicy,*(?:.)*/) }
    end

    describe processes(apiserver).commands.to_s do
      it { should match(/--enable-admission-plugins=(?:.)*PodSecurityPolicy,*(?:.)*/) }
    end
  end
end

control 'cis-kubernetes-benchmark-1.2.14' do
  title 'Ensure that the admission control plugin ServiceAccount is set'
  desc "Automate service accounts management.\n\nRationale: When you create a pod, if you do not specify a service account, it is automatically assigned the `default` service account in the same namespace. You should create your own service account and let the API server manage its security tokens."
  impact 1.0

  tag cis: 'kubernetes:1.2.14'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--disable-admission-plugins=(?:.)*ServiceAccount,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.15' do
  title 'Ensure that the admission control plugin NamespaceLifecycle is set'
  desc "Reject creating objects in a namespace that is undergoing termination.\n\nRationale: Setting admission control policy to `NamespaceLifecycle` ensures that objects cannot be created in non-existent namespaces, and that namespaces undergoing termination are not used for creating the new objects. This is recommended to enforce the integrity of the namespace termination process and also for the availability of the newer objects."
  impact 1.0

  tag cis: 'kubernetes:1.2.15'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--disable-admission-plugins=(?:.)*NamespaceLifecycle,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.16' do
  title 'Ensure that the admission control plugin PodSecurityPolicy is set'
  desc "Reject creating pods that do not match Pod Security Policies.\n\nRationale: A Pod Security Policy is a cluster-level resource that controls the actions that a pod can perform and what it has the ability to access. The `PodSecurityPolicy` objects define a set of conditions that a pod must run with in order to be accepted into the system. Pod Security Policies are comprised of settings and strategies that control the security features a pod has access to and hence this must be used to control pod access permissions."
  impact 1.0

  tag cis: 'kubernetes:1.2.16'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--enable-admission-plugins=(?:.)*PodSecurityPolicy,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.17' do
  title 'Ensure that the admission control plugin NodeRestriction is set'
  desc "Limit the `Node` and `Pod` objects that a kubelet could modify.\n\nRationale: Using the `NodeRestriction` plug-in ensures that the kubelet is restricted to the `Node` and `Pod` objects that it could modify as defined. Such kubelets will only be allowed to modify their own `Node` API object, and only modify `Pod` API objects that are bound to their node."
  impact 1.0

  tag cis: 'kubernetes:1.2.17'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--enable-admission-plugins=(?:.)*NodeRestriction,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.18' do
  title 'Ensure that the --insecure-bind-address argument is not set'
  desc "Do not bind the insecure API service.\n\nRationale: If you bind the apiserver to an insecure address, basically anyone who could connect to it over the insecure port, would have unauthenticated and unencrypted access to your master node. The apiserver doesn't do any authentication checking for insecure binds and traffic to the Insecure API port is not encrpyted, allowing attackers to potentially read sensitive data in transit."
  impact 1.0

  tag cis: 'kubernetes:1.2.18'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should_not match(/--insecure-bind-address/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.19' do
  title 'Ensure that the --insecure-port argument is set to 0'
  desc "Do not bind to insecure port.\n\nRationale: Setting up the apiserver to serve on an insecure port would allow unauthenticated and unencrypted access to your master node. This would allow attackers who could access this port, to easily take control of the cluster."
  impact 1.0

  tag cis: 'kubernetes:1.2.19'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--insecure-port=0/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.20' do
  title 'Ensure that the --secure-port argument is not set to 0'
  desc "Do not disable the secure port.\n\nRationale: The secure port is used to serve https with authentication and authorization. If you disable it, no https traffic is served and all traffic is served unencrypted."
  impact 1.0

  tag cis: 'kubernetes:1.2.20'
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

control 'cis-kubernetes-benchmark-1.2.21' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.2.21'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end

# Incomplete
control 'cis-kubernetes-benchmark-1.2.22' do
  title 'Ensure that the --audit-log-path argument is set'
  desc "Enable auditing on the Kubernetes API Server and set the desired audit log path.\n\nRationale: Auditing the Kubernetes API Server provides a security-relevant chronological set of records documenting the sequence of activities that have affected system by individual users, administrators or other components of the system. Even though currently, Kubernetes provides only basic audit capabilities, it should be enabled. You can enable it by setting an appropriate audit log path."
  impact 1.0

  tag cis: 'kubernetes:1.2.22'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-path=(\S+)/) }
  end

  audit_log_path = processes(apiserver).commands.to_s.scan(/--audit-log-path=(\S+)/)
  describe directory(audit_log_path) do
    it { should exist }
  end
end

control 'cis-kubernetes-benchmark-1.2.23' do
  title 'Ensure that the --audit-log-maxage argument is set to 30 or as appropriate'
  desc "Retain the logs for at least 30 days or as appropriate.\n\nRationale: Retaining logs for at least 30 days ensures that you can go back in time and investigate or correlate any events. Set your audit log retention period to 30 days or as per your business requirements."
  impact 1.0

  tag cis: 'kubernetes:1.2.23'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxage=/) }
  end

  audit_log_maxage = processes(apiserver).commands.to_s.scan(/--audit-log-maxage=(\d+)/)

  only_if { !audit_log_maxsize.empty }
  describe audit_log_maxage.last.first.to_i do
    it { should cmp >= 30 }
  end
end

control 'cis-kubernetes-benchmark-1.2.24' do
  title 'Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate'
  desc "Retain 10 or an appropriate number of old log files.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. For example, if you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:1.2.24'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxbackup=/) }
  end

  audit_log_maxbackup = processes(apiserver).commands.to_s.scan(/--audit-log-maxbackup=(\d+)/)

  only_if { !audit_log_maxsize.empty }
  describe audit_log_maxbackup.last.first.to_i do
    it { should cmp >= 10 }
  end
end

control 'cis-kubernetes-benchmark-1.2.25' do
  title 'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate'
  desc "Rotate log files on reaching 100 MB or as appropriate.\n\nRationale: Kubernetes automatically rotates the log files. Retaining old log files ensures that you would have sufficient log data available for carrying out any investigation or correlation. If you have set file size of 100 MB and the number of old log files to keep as 10, you would approximate have 1 GB of log data that you could potentially use for your analysis."
  impact 1.0

  tag cis: 'kubernetes:1.2.25'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--audit-log-maxsize=/) }
  end

  audit_log_maxsize = processes(apiserver).commands.to_s.scan(/--audit-log-maxsize=(\d+)/)

  only_if { !audit_log_maxsize.empty }
  describe audit_log_maxsize.last.first.to_i do
    it { should cmp >= 100 }
  end
end

control 'cis-kubernetes-benchmark-1.2.26' do
  title 'Ensure that the --request-timeout argument is set as appropriate'
  desc "Set global request timeout for API server requests as appropriate.\n\nRationale: Setting global request timeout allows extending the API server request timeout limit to a duration appropriate to the user's connection speed. By default, it is set to 60 seconds which might be problematic on slower connections making cluster resources inaccessible once the data volume for requests exceeds what can be transmitted in 60 seconds. But, setting this timeout limit to be too large can exhaust the API server resources making it prone to Denial-of-Service attack. Hence, it is recommended to set this limit as appropriate and change the default limit of 60 seconds only if needed."
  impact 1.0

  tag cis: 'kubernetes:1.2.26'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.2.26' do
    skip 'If you have a request timeout set, verify that it is set to an appropriate value'
  end
end

control 'cis-kubernetes-benchmark-1.2.27' do
  title 'Ensure that the --service-account-lookup argument is set to true'
  desc "Validate service account before validating token.\n\nRationale: If `--service-account-lookup` is not enabled, the apiserver only verifies that the authentication token is valid, and does not validate that the service account token mentioned in the request is actually present in etcd. This allows using a service account token even after the corresponding service account is deleted. This is an example of time of check to time of use security issue."
  impact 1.0

  tag cis: 'kubernetes:1.2.27'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--service-account-lookup=true/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.28' do
  title 'Ensure that the --service-account-key-file argument is set as appropriate'
  desc "Explicitly set a service account public key file for service accounts on the apiserver.\n\nRationale: By default, if no `--service-account-key-file` is specified to the apiserver, it uses the private key from the TLS serving certificate to verify service account tokens. To ensure that the keys for service account tokens could be rotated as needed, a separate public/private key pair should be used for signing service account tokens. Hence, the public key should be specified to the apiserver with `--service-account-key-file`."
  impact 1.0

  tag cis: 'kubernetes:1.2.28'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--service-account-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.29' do
  title 'Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for client connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be protected by client authentication. This requires the API server to identify itself to the etcd server using a client certificate and key."
  impact 1.0

  tag cis: 'kubernetes:1.2.29'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--etcd-certfile=/) }
    it { should match(/--etcd-keyfile=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.30' do
  title 'Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate'
  desc "Setup TLS connection on the API server.\n\nRationale: API server communication contains sensitive parameters that should remain encrypted in transit. Configure the API server to serve only HTTPS traffic."
  impact 1.0

  tag cis: 'kubernetes:1.2.30'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--tls-cert-file=/) }
    it { should match(/--tls-private-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.31' do
  title 'Ensure that the --client-ca-file argument is set as appropriate'
  desc "Setup TLS connection on the API server.\n\nRationale: API server communication contains sensitive parameters that should remain encrypted in transit. Configure the API server to serve only HTTPS traffic. If `--client-ca-file` argument is set, any request presenting a client certificate signed by one of the authorities in the `client-ca-file` is authenticated with an identity corresponding to the CommonName of the client certificate."
  impact 1.0

  tag cis: 'kubernetes:1.2.31'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--client-ca-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.32' do
  title 'Ensure that the --etcd-cafile argument is set as appropriate'
  desc "etcd should be configured to make use of TLS encryption for client connections.\n\nRationale: etcd is a highly-available key value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be protected by client authentication. This requires the API server to identify itself to the etcd server using a SSL Certificate Authority file."
  impact 1.0

  tag cis: 'kubernetes:1.2.32'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--etcd-cafile/) }
  end
end

control 'cis-kubernetes-benchmark-1.2.33' do
  title 'Ensure that the --encryption-provider-config argument is set as appropriate'
  desc "Encrypt etcd key-value store.\n\nRationale: etcd is a highly available key-value store used by Kubernetes deployments for persistent storage of all of its REST API objects. These objects are sensitive in nature and should be encrypted at rest to avoid any disclosures."
  impact 1.0

  tag cis: 'kubernetes:1.2.33'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--encryption-provider-config=(\S+)/) }
  end

  encryption_provider_config = processes(apiserver).commands.to_s.scan(/--encryption-provider-config=(\S+)/).flatten.first
  describe directory(encryption_provider_config) do
    it { should exist }
  end
end

control 'cis-kubernetes-benchmark-1.2.34' do
  title 'Ensure that encryption providers are appropriately configured'
  desc "Where etcd encryption is used, appropriate providers should be configured.\nRationale: Where etcd encryption is used, it is important to ensure that the appropriate set of encryption providers is used. Currently, the aescbc, kms and secretbox are likely to be appropriate options."
  impact 1.0

  tag cis: 'kubernetes:1.2.34'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.2.34' do
    skip 'Review the `EncryptionConfig` file and verify that `aescbc` or `kms` or `secretbox` is used as the encryption provider.'
  end

  describe processes(apiserver).commands.to_s do
    it { should match(/--encryption-provider-config=(\S+)/) }
  end

  encryption_provider_config = processes(apiserver).commands.to_s.scan(/--encryption-provider-config=(\S+)/).flatten.first

  describe file(encryption_provider_config) do
    it { should exist }
  end

  yaml_config = yaml(encryption_provider_config)

  describe yaml(encryption_provider_config) do
    its(['resources']) { should_not be nil }
  end

  only_if { !yaml_config['resources'].empty? && !yaml_config['resources'][0]['providers'].empty? }
  yaml_config['resources'].each do |resource|
    resource['providers'].each_entry do |provider|
      provider.each_key do |provider_name|
        describe "#{provider_name} must be in identify, aescbc, kms, secretbox" do
          it { be_in %w[identity aescbc kms secretbox] }
        end
      end
    end
  end
end

control 'cis-kubernetes-benchmark-1.2.35' do
  title 'Ensure that the API Server only makes use of Strong Cryptographic Ciphers'
  desc "Ensure that the API server is configured to only use strong cryptographic ciphers.\n\nRationale: TLS ciphers have had a number of known vulnerabilities and weaknesses, which can reduce the protection provided by them. By default Kubernetes supports a number of TLS ciphersuites including some that have security concerns, weakening the protection provided."
  impact 0.0

  tag cis: 'kubernetes:1.2.35'
  tag level: 1

  describe processes(apiserver).commands.to_s do
    it { should match(/--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384/) }
  end
end
