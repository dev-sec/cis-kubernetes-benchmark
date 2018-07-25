#
# Copyright 2018, ipt switzerland AG.
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
# author: Cyrill Ruettimann

class Kubernetes < Inspec.resource(1)
  name 'kubernetes'
  desc 'Custom resource which abstracts the various kubernetes runtimes like hyperkube'

  def initialize
    @is_hyperkube = inspec.file('/usr/bin/hyperkube').file?
    Log.debug("The kubernetes installation uses hyperkube: #{@is_hyperkube}")
  end

  def processname_apiserver
    @is_hyperkube ? 'apiserver' : 'kube-apiserver'
  end

  def processname_federation_apiserver
    'federation-apiserver'
  end

  def processname_scheduler
    'kube-scheduler'
  end

  def processname_controllermanager
    @is_hyperkube ? 'controller-manager' : 'kube-controller-manager'
  end

  def processname_federation_controllermanager
    'federation_controller_manager'
  end

  def processname_kubelet
    'kubelet'
  end
end
