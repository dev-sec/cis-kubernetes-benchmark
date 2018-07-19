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
    @file = inspec.file('/usr/bin/hyperkube')
    @hyperkube = @file.file?
    Log.debug("The installation is hyperkube=#{@hyperkube}")
  end

  def hyperkube
    @hyperkube
  end

  def processname_apiserver
    plain = 'kube-apiserver'
    hyperkube = 'apiserver'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end

  def processname_federation_apiserver
    plain = 'federation-apiserver'
    hyperkube = 'federation-apiserver'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end

  def processname_scheduler
    plain = 'kube-scheduler'
    hyperkube = 'kube-scheduler'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end

  def processname_controllermanager
    plain = 'kube-controller-manager'
    hyperkube = 'controller-manager'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end

  def processname_federation_controllermanager
    plain = 'federation_controller_manager'
    hyperkube = 'federation_controller_manager'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end

  def processname_kubelet
    plain = 'kubelet'
    hyperkube = 'kubelet'
    processname = plain

    processname = hyperkube if @hyperkube

    processname
  end
end
