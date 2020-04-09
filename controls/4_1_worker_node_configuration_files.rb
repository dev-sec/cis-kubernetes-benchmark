title '4.1.1 Worker Node: Configuration Files'

kubelet = attribute('kubelet')
# fallback if kubelet attribute is not defined
kubelet = kubernetes.kubelet_bin if kubelet.empty?
kubelet_conf = attribute('kubelet-conf')

only_if('kubelet not found') do
  processes(kubelet).exists?
end

control 'cis-kubernetes-benchmark-4.1.1' do
  title 'Ensure that the kubelet service file permissions are set to 644 or more restrictive'
  desc "Ensure that the `kubelet` service file has permissions of `644` or more restrictive.\n\nRationale: The `kubelet` service file controls various parameters that set the behavior of the `kubelet` service in the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:4.1.1'
  tag level: 1

  if file('/etc/systemd/system/kubelet.service.d/10-kubeadm.conf').exist?
    describe file('/etc/systemd/system/kubelet.service.d/10-kubeadm.conf').mode.to_s(8) do
      it { should match(/[0246][024][024]/) }
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.1' do
      skip 'Review the permissions on your Kubelet systemd service file.'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.2' do
  title 'Ensure that the kubelet.conf file ownership is set to root:root'
  desc "Ensure that the `kubelet.conf` file ownership is set to `root:root`.\n\nRationale: The `kubelet.conf` file is the kubeconfig file for the node, and controls various parameters that set the behavior and identity of the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root.`"
  impact 1.0

  tag cis: 'kubernetes:4.1.2'
  tag level: 1

  only_if do
    file(kubelet_conf).exist?
  end

  describe file(kubelet_conf) do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-4.1.3' do
  title 'Ensure that the proxy kubeconfig file permissions are set to 644 or more restrictive'
  desc "If `kube-proxy` is running, ensure that the proxy kubeconfig file has permissions of `644` or more restrictive.\n\nRationale: The `kube-proxy` kubeconfig file controls various parameters of the `kube-proxy` service in the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:4.1.3'
  tag level: 1

  if processes('kube-proxy').exists?
    conf_file = processes('kube-proxy').commands.first.scan(/--kubeconfig=(\S+)/).last.first

    if file(conf_file).exist?
      describe file(conf_file).mode.to_s(8) do
        it { should match(/[0246][024][024]/) }
      end
    else
      describe 'cis-kubernetes-benchmark-4.1.3' do
        skip 'kube-proxy config file configured but not found'
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.3' do
      skip 'kube-proxy process not found'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.4' do
  title 'Ensure that the proxy kubeconfig file ownership is set to root:root'
  desc "If `kube-proxy` is running, ensure that the file ownership of its kubeconfig file is set to `root:root`.\n\nRationale: The kubeconfig file for `kube-proxy` controls various parameters for the `kube-proxy` service in the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:4.1.4'
  tag level: 1

  if processes('kube-proxy').exists?
    conf_file = processes('kube-proxy').commands.first.scan(/--kubeconfig=(\S+)/).last.first

    if file(conf_file).exist?
      describe file(conf_file) do
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
    else
      describe 'cis-kubernetes-benchmark-4.1.4' do
        skip 'kube-proxy config file configured but not found'
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.4' do
      skip 'kube-proxy process not found'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.5' do
  title 'Ensure that the kubelet.conf file permissions are set to 644 or more restrictive'
  desc "Ensure that the `kubelet.conf` file has permissions of `644` or more restrictive.\n\nRationale: The `kubelet.conf` file is the kubeconfig file for the node, and controls various parameters that set the behavior and identity of the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:4.1.5'
  tag level: 1

  only_if do
    file(kubelet_conf).exist?
  end

  describe file(kubelet_conf).mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-4.1.6' do
  title 'Ensure that the kubelet service file ownership is set to root:root'
  desc "Ensure that the `kubelet` service file ownership is set to `root:root`.\n\nRationale: The `kubelet` service file controls various parameters that set the behavior of the `kubelet` service in the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:4.1.6'
  tag level: 1

  if file('/etc/systemd/system/kubelet.service.d/10-kubeadm.conf').exist?
    describe file('/etc/systemd/system/kubelet.service.d/10-kubeadm.conf') do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.6' do
      skip 'Review the ownership of your Kubelet systemd service file.'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.7' do
  title 'Ensure that the certificate authorities file permissions are set to 644 or more restrictive'
  desc "Ensure that the certificate authorities file has permissions of `644` or more restrictive.\n\nRationale: The certificate authorities file controls the authorities used to validate API requests. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:4.1.7'
  tag level: 1

  if processes('kubelet').exists?
    ca_cert_path = processes('kubelet').commands.first.scan(/--client-ca-file=(\S+)/)

    if ca_cert_path.empty?
      describe 'cis-kubernetes-benchmark-4.1.7' do
        skip 'No client CA file specified for `kubelet` process'
      end
    else
      describe file(ca_cert_path.last.first).mode.to_s(8) do
        it { should match(/[0246][024][024]/) }
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.7' do
      skip 'kubelet process not found'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.8' do
  title 'Ensure that the client certificate authorities file ownership is set to root:root'
  desc "Ensure that the certificate authorities file ownership is set to `root:root`.\n\nRationale: The certificate authorities file controls the authorities used to validate API requests. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:4.1.8'
  tag level: 1

  if processes('kubelet').exists?
    ca_cert_path = processes('kubelet').commands.to_s.scan(/--client-ca-file=(\S+)/)

    if ca_cert_path.empty?
      describe 'cis-kubernetes-benchmark-4.1.8' do
        skip 'No client CA file specified for `kubelet` process'
      end
    else
      describe file(ca_cert_path.last.first) do
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.8' do
      skip 'kubelet process not found'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.9' do
  title 'Ensure that the kubelet configuration file has permissions set to 644 or more restrictive'
  desc "Ensure that if the kubelet refers to a configuration file with the `--config` argument, that file has permissions of 644 or more restrictive.\n\nRationale: The kubelet reads various parameters, including security settings, from a config file specified by the `--config` argument. If this file is specified you should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:4.1.9'
  tag level: 1

  if processes('kubelet').exists?
    config_path = processes('kubelet').commands.first.scan(/--config=(\S+)/)

    if config_path.empty?
      describe 'cis-kubernetes-benchmark-4.1.9' do
        skip 'No config file specified for `kubelet` process'
      end
    else
      describe file(config_path.last.first).mode.to_s(8) do
        it { should match(/[0246][024][024]/) }
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.9' do
      skip 'kubelet process not found'
    end
  end
end

control 'cis-kubernetes-benchmark-4.1.10' do
  title 'Ensure that the kubelet configuration file ownership is set to root:root'
  desc "Ensure that if the kubelet refers to a configuration file with the --config argument, that file is owned by root:root.\n\nRationale: The kubelet reads various parameters, including security settings, from a config file specified by the `--config` argument. If this file is specified you should restrict its file permissions to maintain the integrity of the file. The file should be owned by root:root."
  impact 1.0

  tag cis: 'kubernetes:4.1.10'
  tag level: 1

  if processes('kubelet').exists?
    config_path = processes('kubelet').commands.first.scan(/--config=(\S+)/)

    if config_path.empty?
      describe 'cis-kubernetes-benchmark-4.1.10' do
        skip 'No config file specified for `kubelet` process'
      end
    else
      describe file(config_path.last.first) do
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
    end
  else
    describe 'cis-kubernetes-benchmark-4.1.10' do
      skip 'kubelet process not found'
    end
  end
end
