title '1.3 Master Node: Controller Manager'

controller_manager = attribute('controller_manager')
# fallback if scheduler attribute is not defined
controller_manager = kubernetes.controllermanager_bin if controller_manager.empty?

only_if('controller manager not found') do
  processes(controller_manager).exists?
end

control 'cis-kubernetes-benchmark-1.3.1' do
  title 'Ensure that the --terminated-pod-gc-threshold argument is set as appropriate'
  desc "Activate garbage collector on pod termination, as appropriate.\n\nRationale: Garbage collection is important to ensure sufficient resource availability and avoiding degraded performance and availability. In the worst case, the system might crash or just be unusable for a long period of time. The current setting for garbage collection is 12,500 terminated pods which might be too high for your system to sustain. Based on your system resources and tests, choose an appropriate threshold value to activate garbage collection."
  impact 1.0

  tag cis: 'kubernetes:1.3.1'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--terminated-pod-gc-threshold=/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.2' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.3.2'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.3' do
  title 'Ensure that the --use-service-account-credentials argument is set to true'
  desc "Use individual service account credentials for each controller.\n\nRationale: The controller manager creates a service account per controller in the `kube-system` namespace, generates a credential for it, and builds a dedicated API client with that service account credential for each controller loop to use. Setting the `--use-service-account-credentials` to `true` runs each control loop within the controller manager using a separate service account credential. When used in combination with RBAC, this ensures that the control loops run with the minimum permissions required to perform their intended tasks."
  impact 1.0

  tag cis: 'kubernetes:1.3.3'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--use-service-account-credentials=true/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.4' do
  title 'Ensure that the --service-account-private-key-file argument is set as appropriate'
  desc "Explicitly set a service account private key file for service accounts on the controller manager.\n\nRationale: To ensure that keys for service account tokens can be rotated as needed, a separate public/private key pair should be used for signing service account tokens. The private key should be specified to the controller manager with `--service-account-private-key-file` as appropriate."
  impact 1.0

  tag cis: 'kubernetes:1.3.4'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--service-account-private-key-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.5' do
  title 'Ensure that the --root-ca-file argument is set as appropriate'
  desc "Allow pods to verify the API server's serving certificate before establishing connections.\n\nRationale: Processes running within pods that need to contact the API server must verify the API server's serving certificate. Failing to do so could be a subject to man-in-the-middle attacks. Providing the root certificate for the API server's serving certificate to the controller manager with the `--root-ca-file` argument allows the controller manager to inject the trusted bundle into pods so that they can verify TLS connections to the API server."
  impact 1.0

  tag cis: 'kubernetes:1.3.5'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--root-ca-file=/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.6' do
  title 'Ensure that the RotateKubeletServerCertificate argument is set to true'
  desc "Enable kubelet server certificate rotation on controller-manager.\n\nRationale: `RotateKubeletServerCertificate` causes the kubelet to both request a serving certificate after bootstrapping its client credentials and rotate the certificate as its existing credentials expire. This automated periodic rotation ensures that the there are no downtimes due to expired certificates and thus addressing availability in the CIA security triad.\nNote: This recommendation only applies if you let kubelets get their certificates from the API server. In case your kubelet certificates come from an outside authority/tool (e.g. Vault) then you need to take care of rotation yourself."
  impact 1.0

  tag cis: 'kubernetes:1.3.6'
  tag level: 1

  describe processes(controller_manager).commands.to_s do
    it { should match(/--feature-gates=(?:.)*RotateKubeletServerCertificate=true,*(?:.)*/) }
  end
end

control 'cis-kubernetes-benchmark-1.3.7' do
  title 'Ensure that the --address argument is set to 127.0.0.1'
  desc "Do not bind the Controller Manager service to non-loopback insecure addresses.\n\nRationale: The Controller Manager API service which runs on port 10252/TCP by default is used for health and metrics information and is available without authentication or encryption. As such it should only be bound to a localhost interface, to minimize the cluster's attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.3.7'
  tag level: 1

  describe.one do
    describe processes(controller_manager).commands.to_s do
      it { should match(/--address=127\.0\.0\.1/) }
    end
    describe processes(controller_manager).commands.to_s do
      it { should match(/--bind-address=127\.0\.0\.1/) }
    end
  end
end
