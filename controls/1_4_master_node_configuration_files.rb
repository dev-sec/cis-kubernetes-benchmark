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

title '1.4 Master Node: Configuration Files'

control 'cis-kubernetes-benchmark-1.4.1' do
  title 'Ensure that the apiserver file permissions are set to 644 or more restrictive'
  desc "Ensure that the `apiserver` file has permissions of `644` or more restrictive.\n\nRationale: The `apiserver` file controls various parameters that set the behavior of the API server. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.1'
  tag level: 1

  only_if do
    file('/etc/kubernetes/apiserver').exist?
  end

  describe file('/etc/kubernetes/apiserver').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.2' do
  title 'Ensure that the apiserver file ownership is set to root:root'
  desc "Ensure that the `apiserver` file ownership is set to `root:root`.\n\nRationale: The `apiserver` file controls various parameters that set the behavior of the API server. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.2'
  tag level: 1

  only_if do
    file('/etc/kubernetes/apiserver').exist?
  end

  describe file('/etc/kubernetes/apiserver') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.3' do
  title 'Ensure that the config file permissions are set to 644 or more restrictive'
  desc "Ensure that the `config` file has permissions of `644` or more restrictive.\n\nRationale: The `config` file controls various parameters that set the behavior of various components of the master node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.3'
  tag level: 1

  only_if do
    file('/etc/kubernetes/config').exist?
  end

  describe file('/etc/kubernetes/config').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.4' do
  title 'Ensure that the config file ownership is set to root:root'
  desc "Ensure that the `config` file ownership is set to `root:root`.\n\nRationale: The `config` file controls various parameters that set the behavior of various components of the master node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.4'
  tag level: 1

  only_if do
    file('/etc/kubernetes/config').exist?
  end

  describe file('/etc/kubernetes/config') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.5' do
  title 'Ensure that the scheduler file permissions are set to 644 or more restrictive'
  desc "Ensure that the `scheduler` file has permissions of `644` or more restrictive.\n\nRationale: The `scheduler` file controls various parameters that set the behavior of the `kube-scheduler` service in the master node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.5'
  tag level: 1

  only_if do
    file('/etc/kubernetes/scheduler').exist?
  end

  describe file('/etc/kubernetes/scheduler').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.6' do
  title 'Ensure that the scheduler file ownership is set to root:root'
  desc "Ensure that the `scheduler` file ownership is set to `root:root`.\n\nRationale: The `scheduler` file controls various parameters that set the behavior of the `kube-scheduler` service in the master node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.6'
  tag level: 1

  only_if do
    file('/etc/kubernetes/scheduler').exist?
  end

  describe file('/etc/kubernetes/scheduler') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.7' do
  title 'Ensure that the etcd.conf file permissions are set to 644 or more restrictive'
  desc "Ensure that the `etcd.conf` file has permissions of `644` or more restrictive.\n\nRationale: The `etcd.conf` file controls various parameters that set the behavior of the `etcd` service in the master node. etcd is a highly-available key value store which Kubernetes uses for persistent storage of all of its REST API object. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.7'
  tag level: 1

  only_if do
    file('/etc/etcd/etcd.conf').exist?
  end

  describe file('/etc/etcd/etcd.conf').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.8' do
  title 'Ensure that the etcd.conf file ownership is set to root:root'
  desc "Ensure that the `etcd.conf` file ownership is set to `root:root`.\n\nRationale: The `etcd.conf` file controls various parameters that set the behavior of the `etcd` service in the master node. etcd is a highly-available key value store which Kubernetes uses for persistent storage of all of its REST API object. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.8'
  tag level: 1

  only_if do
    file('/etc/etcd/etcd.conf').exist?
  end

  describe file('/etc/etcd/etcd.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-1.4.9' do
  title 'Ensure that the flanneld file permissions are set to 644 or more restrictive'
  desc "Ensure that the `flanneld` file has permissions of `644` or more restrictive.\n\nRationale: The `flanneld` file controls various parameters that set the behavior of the `flanneld` service in the master node. Flannel is one of the various options for a simple overlay network. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:1.4.9'
  tag level: 1

  only_if do
    file('/etc/sysconfig/flanneld').exist?
  end

  describe file('/etc/sysconfig/flanneld').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.10' do
  title 'Ensure that the flanneld file ownership is set to root:root'
  desc "Ensure that the `flanneld` file ownership is set to `root:root`.\n\nRationale: The `flanneld` file controls various parameters that set the behavior of the `flanneld` service in the master node. Flannel is one of the various options for a simple overlay network. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:1.4.10'
  tag level: 1

  only_if do
    file('/etc/sysconfig/flanneld').exist?
  end

  describe file('/etc/sysconfig/flanneld') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
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
    describe file(data_dir).mode.to_s do
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
    describe file(data_dir).mode.to_s do
      it { should be_owned_by 'etcd' }
      it { should be_grouped_into 'etcd' }
    end
  else
    describe 'cis-kubernetes-benchmark-1.4.12' do
      skip 'etcd data directory not found'
    end
  end
end
