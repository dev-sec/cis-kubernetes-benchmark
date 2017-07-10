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

title '2.2 Worker Node: Configuration Files'

control 'cis-kubernetes-benchmark-2.2.1' do
  title 'Ensure that the config file permissions are set to 644 or more restrictive'
  desc "Ensure that the `config` file has permissions of `644` or more restrictive.\n\nRationale: The `config` file controls various parameters that set the behavior of various components of the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:2.2.1'
  tag level: 1

  only_if do
    file('/etc/kubernetes/config').exist?
  end

  describe file('/etc/kubernetes/config').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-2.2.2' do
  title 'Ensure that the config file ownership is set to root:root'
  desc "Ensure that the `config` file ownership is set to `root:root`.\n\nRationale: The `config` file controls various parameters that set the behavior of various components of the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:2.2.2'
  tag level: 1

  only_if do
    file('/etc/kubernetes/config').exist?
  end

  describe file('/etc/kubernetes/config') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-2.2.3' do
  title 'Ensure that the kubelet file permissions are set to 644 or more restrictive'
  desc "Ensure that the `kubelet` file has permissions of `644` or more restrictive.\n\nRationale: The `kubelet` file controls various parameters that set the behavior of the `kubelet` service in the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:2.2.3'
  tag level: 1

  only_if do
    file('/etc/kubernetes/kubelet').exist?
  end

  describe file('/etc/kubernetes/kubelet').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-2.2.4' do
  title 'Ensure that the kubelet file ownership is set to root:root'
  desc "Ensure that the `kubelet` file ownership is set to `root:root`.\n\nRationale: The `kubelet` file controls various parameters that set the behavior of the `kubelet` service in the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:2.2.4'
  tag level: 1

  only_if do
    file('/etc/kubernetes/kubelet').exist?
  end

  describe file('/etc/kubernetes/kubelet') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'cis-kubernetes-benchmark-2.2.5' do
  title 'Ensure that the proxy file permissions are set to 644 or more restrictive'
  desc "Ensure that the `proxy` file has permissions of `644` or more restrictive.\n\nRationale: The `proxy` file controls various parameters that set the behavior of the `kube-proxy` service in the worker node. You should restrict its file permissions to maintain the integrity of the file. The file should be writable by only the administrators on the system."
  impact 1.0

  tag cis: 'kubernetes:2.2.5'
  tag level: 1

  only_if do
    file('/etc/kubernetes/proxy').exist?
  end

  describe file('/etc/kubernetes/proxy').mode.to_s do
    it { should match(/[0246][024][024]/) }
  end
end

control 'cis-kubernetes-benchmark-2.2.6' do
  title 'Ensure that the proxy file ownership is set to root:root'
  desc "Ensure that the `proxy` file ownership is set to `root:root`.\n\nRationale: The `proxy` file controls various parameters that set the behavior of the `kube-proxy` service in the worker node. You should set its file ownership to maintain the integrity of the file. The file should be owned by `root:root`."
  impact 1.0

  tag cis: 'kubernetes:2.2.6'
  tag level: 1

  only_if do
    file('/etc/kubernetes/proxy').exist?
  end

  describe file('/etc/kubernetes/proxy') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
