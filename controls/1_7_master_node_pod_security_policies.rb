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

cis_level = attribute('cis_level')

title '1.7 Master Node: Pod Security Policies'

control 'cis-kubernetes-benchmark-1.7.1' do
  title 'Do not admit privileged containers'
  desc "Do not generally permit containers to be run with the `securityContext.privileged` flag set to `true`.\n\nRationale: Privileged containers have access to all Linux Kernel capabilities and devices. A container running with full privileges can do almost everything that the host can do. This flag exists to allow special use-cases, like manipulating the network stack and accessing devices.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit privileged containers.\nIf you need to run privileged containers, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:1.7.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.7.1' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.priveged}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-1.7.2' do
  title 'Do not admit containers wishing to share the host process ID namespace'
  desc "Do not generally permit containers to be run with the `hostPID` flag set to true.\n\nRationale: A container running in the host's PID namespace can inspect processes running outside the container. If the container also has access to ptrace capabilities this can be used to escalate privileges outside of the container.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host PID namespace.\nIf you need to run containers which require hostPID, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:1.7.2'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.7.2' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostPID}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-1.7.3' do
  title 'Do not admit containers wishing to share the host IPC namespace'
  desc "Do not generally permit containers to be run with the `hostIPC` flag set to true.\n\nRationale: A container running in the host's IPC namespace can use IPC to interact with processes outside the container.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host IPC namespace.\nIf you have a requirement to containers which require hostIPC, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:1.7.3'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.7.3' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostIPC}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-1.7.4' do
  title 'Do not admit containers wishing to share the host network namespace'
  desc "Do not generally permit containers to be run with the `hostNetwork`flag set to true.\n\nRationale: A container running in the host's network namespace could access the local loopback device, and could access network traffic to and from other pods.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host network namespace.\nIf you have need to run containers which require hostNetwork, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:1.7.4'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.7.4' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostNetwork}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-1.7.5' do
  title 'Do not admit containers with allowPrivilegeEscalation'
  desc "Do not generally permit containers to be run with the `allowPrivilegeEscalation` flag set to true.\n\nRationale: A container running with the `allowPrivilegeEscalation` flag set to `true` may have processes that can gain more privileges than their parent.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to allow privilege escalation. The option exists (and is defaulted to true) to permit setuid binaries to run.\nIf you have need to run containers which use setuid binaries or require privilege escalation, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:1.7.5'
  tag level: 1

  describe 'cis-kubernetes-benchmark-1.7.5' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.allowPrivilegeEscalation}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-1.7.6' do
  title 'Do not admit root containers'
  desc "Do not generally permit containers to be run as the root user.\n\nRationale: Containers may run as any Linux user. Containers which run as the root user, whilst constrained by Container Runtime security features still have a escalated likelihood of container breakout.\nIdeally, all containers should run as a defined non-UID 0 user.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit root users in a container.\nIf you need to run root containers, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:1.7.6'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.7.6' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.runAsUser.rule}'` and verify at least one returns `MustRunAsNonRoot` or `MustRunAs` with the range of UIDs not including 0."
  end
end

control 'cis-kubernetes-benchmark-1.7.7' do
  title 'Do not admit containers with dangerous capabilities'
  desc "Do not generally permit containers with potentially dangerous capabilities.\n\nRationale: Containers run with a default set of capabilities as assigned by the Container Runtime. By default this can include potentially dangerous capabilities. By default with Docker as the container runtime the NET_RAW capability is enabled which may be misused by malicious containers.\nIdeally, all containers should drop this capability.\nThere should be at least one PodSecurityPolicy (PSP) defined which prevents containers with the NET_RAW capability from launching.\nIf you need to run containers with this capability, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:1.7.7'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-1.7.7' do
    skip "For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.requiredDropCapabilities}'` and verify at least one returns `NET_RAW` or `ALL`."
  end
end
