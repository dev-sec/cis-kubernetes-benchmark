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

title '3.2 Federation Controller Manager'

federation_controller_manager = attribute('federation_controller_manager')
# fallback if federation_apiserver attribute is not defined
federation_controller_manager = kubernetes.federation_controllermanager_bin if federation_controller_manager.empty?

only_if('federation controller manager not found') do
  processes(federation_controller_manager).exists?
end

control 'cis-kubernetes-benchmark-3.2.1' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:3.2.1'
  tag level: 1

  describe processes(federation_controller_manager).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end
