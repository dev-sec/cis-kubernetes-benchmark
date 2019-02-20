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

title '1.4 Master Node: Configuration Files'

control 'cis-kubernetes-benchmark-1.4.1' do
  title 'Ensure that the API server pod specification file permissions are set to 644 or more restrictive'
  desc "Ensure that the API server pod specification file has permissions of `644` or more restrictive.\n\nRationale: The API server pod specification file controls various parameters that set the behavior of the API server. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.1'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-apiserver.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-apiserver.yaml').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.2' do
  title 'Ensure that the API server pod specification file ownership is set to root:root'
  desc "Ensure that the API server pod specification file ownership is set to `root:root`.\n\nRationale: The API server pod specification file controls various parameters that set the behavior of the API server. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.2'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-apiserver.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-apiserver.yaml') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.3' do
  title 'Ensure that the controller manager pod specification file permissions are set to 644 or more restrictive'
  desc "Ensure that the controller manager pod specification file has permissions of `644` or more restrictive.\n\nRationale: The controller manager pod specification file controls various parameters that set the behavior of the Controller Manager on the master node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.3'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-controller-manager.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-controller-manager.yaml').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.4' do
  title 'Ensure that the controller manager pod specification file ownership is set to root:root'
  desc "Ensure that the controller manager pod specification file ownership is set to `root:root`.\n\nRationale: The controller manager pod specification file controls various parameters that set the behavior of various components of the master node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.4'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-controller-manager.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-controller-manager.yaml') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.5' do
  title 'Ensure that the scheduler pod specification file permissions are set to 644 or more restrictive'
  desc "Ensure that the scheduler pod specification file has permissions of `644` or more restrictive.\n\nRationale: The scheduler pod specification file controls various parameters that set the behavior of the Scheduler service in the master node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.5'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-scheduler.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-scheduler.yaml').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.6' do
  title 'Ensure that the scheduler pod specification file ownership is set to root:root'
  desc "Ensure that the scheduler pod specification file ownership is set to `root:root`.\n\nRationale: The scheduler pod specification file controls various parameters that set the behavior of the `kube-scheduler` service in the master node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.6'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/kube-scheduler.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/kube-scheduler.yaml') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.7' do
  title 'Ensure that the etcd pod specification file permissions are set to 644 or more restrictive'
  desc "Ensure that the `/etc/kubernetes/manifests/etcd.yaml` file has permissions of `644` or more restrictive.\n\nRationale: The etcd pod specification file `/etc/kubernetes/manifests/etcd.yaml` controls various parameters that set the behavior of the `etcd` service in the master node. etcd is a highly-available key-value store which Kubernetes uses for persistent storage of all of its REST API object. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.7'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/etcd.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/etcd.yaml').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.8' do
  title 'Ensure that the etcd pod specification file ownership is set to root:root'
  desc "Ensure that the `/etc/kubernetes/manifests/etcd.yaml` file ownership is set to `root:root`.\n\nRationale: The etcd pod specification file `/etc/kubernetes/manifests/etcd.yaml` controls various parameters that set the behavior of the `etcd` service in the master node. etcd is a highly-available key-value store which Kubernetes uses for persistent storage of all of its REST API object. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.8'
  tag level: 1

  only_if do
    file('/etc/kubernetes/manifests/etcd.yaml').exist?
  end

  describe file('/etc/kubernetes/manifests/etcd.yaml') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.9' do
  title 'Ensure that the Container Network Interface file permissions are set to 644 or more restrictive'
  desc "Ensure that the Container Network Interface files have permissions of `644` or more restrictive.\n\nRationale: Container Network Interface provides various networking options for overlay networking. You should consult their documentation and restrict their respective file permissions to maintain the integrity of those files. Those files should be writable by only the administrators on the system."
  impact 0.0

  tag cis: 'kubernetes:1.4.9'
  tag level: 1

  if file('/etc/sysconfig/flanneld').exist?
    describe file('/etc/sysconfig/flanneld').mode.to_s(8) do
      it { should match(/[0246][024][024]/) }
    end
  else
    describe 'cis-kubernetes-benchmark-1.4.9' do
      skip 'Review the permissions on your CNI configuration file(s).'
    end
  end

end

control 'cis-kubernetes-benchmark-1.4.10' do
  title 'Ensure that the Container Network Interface file ownership is set to root:root'
  desc "Ensure that the Container Network Interface files have ownership set to `root:root`.\n\nRationale: Container Network Interface provides various networking options for overlay networking. You should consult their documentation and restrict their respective file permissions to maintain the integrity of those files. Those files should be owned by `root:root`."
  impact 0.0

  tag cis: 'kubernetes:1.4.10'
  tag level: 1

  if file('/etc/sysconfig/flanneld').exist?
    describe file('/etc/sysconfig/flanneld') do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  else
    describe 'cis-kubernetes-benchmark-1.4.10' do
      skip 'Review the ownership of your CNI configuration file(s).'
    end
  end
end

control 'cis-kubernetes-benchmark-1.4.11' do
  title 'Ensure that the etcd data directory permissions are set to 700 or more restrictive'
  desc "Ensure that the etcd data directory has permissions of `700` or more restrictive.\n\nRationale: etcd is a highly-available key-value store used by Kubernetes deployments for persistent storage of all of its REST API objects. This data directory should be protected from any unauthorized reads or writes. It should not be readable or writable by any group members or the world."
  impact 1.0

  tag cis: 'kubernetes:1.4.11'
  tag level: 1

  etcd_process = processes(Regexp.new(%r{/usr/bin/etcd}))
  data_dir = ''

  catch(:stop) do
    if etcd_process.exists?
      if (data_dir = etcd_process.commands.to_s.scan(/--data-dir=(\S+)/).last)
        data_dir = data_dir.first
        throw :stop
      end

      if (data_dir = file("/proc/#{etcd_process.pids.first}/environ").content.split("\0").select { |i| i[/^ETCD_DATA_DIR/] }.first.to_s.split('=', 2).last.to_s)
        throw :stop
      end
    end
  end

  if !data_dir.empty?
    describe file(data_dir).mode.to_s(8) do
      it { should match(/[01234567]00/) }
    end
  else
    describe 'cis-kubernetes-benchmark-1.4.11' do
      skip 'etcd data directory not found'
    end
  end
end

control 'cis-kubernetes-benchmark-1.4.12' do
  title 'Ensure that the etcd data directory ownership is set to etcd:etcd'
  desc "Ensure that the etcd data directory ownership is set to `etcd:etcd`.\n\nRationale: etcd is a highly-available key-value store used by Kubernetes deployments for persistent storage of all of its REST API objects. This data directory should be protected from any unauthorized reads or writes. It should be owned by `etcd:etcd`."
  impact 1.0

  tag cis: 'kubernetes:1.4.12'
  tag level: 1

  etcd_process = processes(Regexp.new(%r{/usr/bin/etcd}))
  data_dir = ''

  catch(:stop) do
    if etcd_process.exists?
      if (data_dir = etcd_process.commands.to_s.scan(/--data-dir=(\S+)/).last)
        data_dir = data_dir.first
        throw :stop
      end

      if (data_dir = file("/proc/#{etcd_process.pids.first}/environ").content.split("\0").select { |i| i[/^ETCD_DATA_DIR/] }.first.to_s.split('=', 2).last.to_s)
        throw :stop
      end
    end
  end

  if !data_dir.empty?
    describe file(data_dir) do
      it { should be_owned_by 'etcd' }
      it { should be_grouped_into 'etcd' }
    end
  else
    describe 'cis-kubernetes-benchmark-1.4.12' do
      skip 'etcd data directory not found'
    end
  end
end

control 'cis-kubernetes-benchmark-1.4.13' do
  title 'Ensure that the admin.conf file permissions are set to 644 or more restrictive'
  desc "Ensure that the `admin.conf` file has permissions of `644` or more restrictive.\n\nRationale: The `admin.conf` is the administrator kubeconfig file defining various settings for the administration of the cluster. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.13'
  tag level: 1

  only_if do
    file('/etc/kubernetes/admin.conf').exist?
  end

  describe file('/etc/kubernetes/admin.conf').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.14' do
  title 'Ensure that the admin.conf file ownership is set to root:root'
  desc "Ensure that the `admin.conf` file ownership is set to `root:root`.\n\nRationale: The `admin.conf` file contains the admin credentials for the cluster. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.14'
  tag level: 1

  only_if do
    file('/etc/kubernetes/admin.conf').exist?
  end

  describe file('/etc/kubernetes/admin.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.15' do
  title 'Ensure that the scheduler.conf file has permissions of 644 or more restrictive'
  desc "Ensure that the `scheduler.conf` file has permissions of `644` or more restrictive.\n\nRationale: The `scheduler.conf` file is the kubeconfig file for the Scheduler. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.15'
  tag level: 1

  only_if do
    file('/etc/kubernetes/scheduler.conf').exist?
  end

  describe file('/etc/kubernetes/scheduler.conf').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.16' do
  title 'Ensure that the scheduler.conf file ownership is set to root:root'
  desc "Ensure that the `scheduler.conf` file ownership is set to `root:root`.\n\nRationale: The `scheduler.conf` file is the kubeconfig file for the Scheduler. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.16'
  tag level: 1

  only_if do
    file('/etc/kubernetes/scheduler.conf').exist?
  end

  describe file('/etc/kubernetes/scheduler.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.17' do
  title 'Ensure that the controller-manager.conf file permissions are set to 644 or more restrictive'
  desc "Ensure that the `controller-manager.conf` file has permissions of 644 or more restrictive.\n\nRationale: The `controller-manager.conf` file is the kubeconfig file for the Controller Manager. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.17'
  tag level: 1

  only_if do
    file('/etc/kubernetes/controller-manager.conf').exist?
  end

  describe file('/etc/kubernetes/controller-manager.conf').mode.to_s(8) do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.18' do
  title 'Ensure that the controller-manager.conf file ownership is set to root:root'
  desc "Ensure that the `controller-manager.conf` file ownership is set to `root:root`.\n\nRationale: The `controller-manager.conf` file is the kubeconfig file for the Controller Manager. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.18'
  tag level: 1

  only_if do
    file('/etc/kubernetes/controller-manager.conf').exist?
  end

  describe file('/etc/kubernetes/controller-manager.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.19' do
  title 'Ensure that the Kubernetes PKI directory and file ownership is set to root:root'
  desc "Ensure that the Kubernetes PKI directory and file ownership is set to `root:root`.\n\nRationale: Kubernetes makes use of a number of certificates as part of its operation. You should set the ownership of the directory containing the PKI information and all files in that directory to maintain their integrity. The directory and files should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.19'
  tag level: 1

  only_if do
    directory('/etc/kubernetes/pki').exist?
  end

  describe directory('/etc/kubernetes/pki') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.20' do
  title 'Ensure that the Kubernetes PKI certificate file permissions are set to 644 or more restrictive'
  desc "Ensure that Kubernetes PKI certificate files have permissions of `644` or more restrictive.\n\nRationale: Kubernetes makes use of a number of certificate files as part of the operation of its components. The permissions on these files should be set to `644` or more restrictive to protect their integrity."
  impact 1.0

  tag cis: 'kubernetes:1.4.20'
  tag level: 1

  only_if do
    directory('/etc/kubernetes/pki').exist?
  end

  cert_files = command('find /etc/kubernetes/pki -type f -name *.crt').stdout.split
  if cert_files.empty?
    describe 'cis-kubernetes-benchmark-1.4.20' do
      skip 'No certificate files found'
    end
  else
    cert_files.each do |cert|
      describe file(cert).mode.to_s(8) do
        it { should match(/[0246][024][024]/) }
      end
    end
  end
end

control 'cis-kubernetes-benchmark-1.4.21' do
  title 'Ensure that the Kubernetes PKI key file permissions are set to 600'
  desc "Ensure that Kubernetes PKI key files have permissions of `600`.\n\nRationale: Kubernetes makes use of a number of key files as part of the operation of its components. The permissions on these files should be set to `600` to protect their integrity and confidentiality."
  impact 1.0

  tag cis: 'kubernetes:1.4.21'
  tag level: 1

  only_if do
    directory('/etc/kubernetes/pki').exist?
  end

  key_files = command('find /etc/kubernetes/pki -type f -name *.key').stdout.split
  if key_files.empty?
    describe 'cis-kubernetes-benchmark-1.4.21' do
      skip 'No private key files found'
    end
  else
    key_files.each do |key|
      describe file(key) do
        its('mode') { should cmp '0600' }
      end
    end
  end
end
