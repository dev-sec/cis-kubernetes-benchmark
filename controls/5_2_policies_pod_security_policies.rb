# frozen_string_literal: true

cis_level = input('cis_level')

title '5.2 Policies: Pod Security Policies'

control 'cis-kubernetes-benchmark-5.2.1' do
  title 'Minimize the admission of privileged containers'
  desc "Do not generally permit containers to be run with the `securityContext.privileged` flag set to `true`.\n\nRationale: Privileged containers have access to all Linux Kernel capabilities and devices. A container running with full privileges can do almost everything that the host can do. This flag exists to allow special use-cases, like manipulating the network stack and accessing devices.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit privileged containers.\nIf you need to run privileged containers, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:5.2.1'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.1' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.priveged}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-5.2.2' do
  title 'Minimize the admission of containers wishing to share the host  process ID namespace'
  desc "Do not generally permit containers to be run with the `hostPID` flag set to true.\n\nRationale: A container running in the host's PID namespace can inspect processes running outside the container. If the container also has access to ptrace capabilities this can be used to escalate privileges outside of the container.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host PID namespace.\nIf you need to run containers which require hostPID, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:5.2.2'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.2' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostPID}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-5.2.3' do
  title 'Minimize the admission of containers wishing to share the host IPC namespace'
  desc "Do not generally permit containers to be run with the `hostIPC` flag set to true.\n\nRationale: A container running in the host's IPC namespace can use IPC to interact with processes outside the container.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host IPC namespace.\nIf you have a requirement to containers which require hostIPC, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:5.2.3'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.3' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostIPC}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-5.2.4' do
  title 'Minimize the admission of containers wishing to share the host  network namespace'
  desc "Do not generally permit containers to be run with the `hostNetwork`flag set to true.\n\nRationale: A container running in the host's network namespace could access the local loopback device, and could access network traffic to and from other pods.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to share the host network namespace.\nIf you have need to run containers which require hostNetwork, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:5.2.4'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.4' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.hostNetwork}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-5.2.5' do
  title 'Minimize the admission of containers with allowPrivilegeEscalation'
  desc "Do not generally permit containers to be run with the `allowPrivilegeEscalation` flag set to true.\n\nRationale: A container running with the `allowPrivilegeEscalation` flag set to `true` may have processes that can gain more privileges than their parent.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit containers to allow privilege escalation. The option exists (and is defaulted to true) to permit setuid binaries to run.\nIf you have need to run containers which use setuid binaries or require privilege escalation, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 1.0

  tag cis: 'kubernetes:5.2.5'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.5' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.allowPrivilegeEscalation}'` and verify at least one is not set to `true`."
  end
end

control 'cis-kubernetes-benchmark-5.2.6' do
  title 'Minimize the admission of root containers'
  desc "Do not generally permit containers to be run as the root user.\n\nRationale: Containers may run as any Linux user. Containers which run as the root user, whilst constrained by Container Runtime security features still have a escalated likelihood of container breakout.\nIdeally, all containers should run as a defined non-UID 0 user.\nThere should be at least one PodSecurityPolicy (PSP) defined which does not permit root users in a container.\nIf you need to run root containers, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:5.2.6'
  tag level: 2

  only_if {  cis_level == 2 }

  describe 'cis-kubernetes-benchmark-5.2.6' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.runAsUser.rule}'` and verify at least one returns `MustRunAsNonRoot` or `MustRunAs` with the range of UIDs not including 0."
  end
end

control 'cis-kubernetes-benchmark-5.2.7' do
  title 'Minimize the admission of containers with the NET_RAW capability'
  desc "Do not generally permit containers with the potentially dangerous NET_RAW capability.\nRationale: Containers run with a default set of capabilities as assigned by the Container runtime. By default this can include potentially dangerous capabilities. With Docker as the container runtime the NET_RAW capability is enabled which may be misused by malicious containers. Ideally, all containers should drop this capability. There should be at least one PodSecurityPolicy (PSP) defined which prevents containers with the NET_RAW capability from launching. If you need to run containers with this capability, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:5.2.7'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.7' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.requireDropCapabilities}'` and verify at least one returns `NET_RAW` or `ALL`."
  end
end

control 'cis-kubernetes-benchmark-5.2.8' do
  title 'Do not admit containers with dangerous capabilities'
  desc "Do not generally permit containers with potentially dangerous capabilities.\n\nRationale: Containers run with a default set of capabilities as assigned by the Container Runtime. By default this can include potentially dangerous capabilities. By default with Docker as the container runtime the NET_RAW capability is enabled which may be misused by malicious containers.\nIdeally, all containers should drop this capability.\nThere should be at least one PodSecurityPolicy (PSP) defined which prevents containers with the NET_RAW capability from launching.\nIf you need to run containers with this capability, this should be defined in a separate PSP and you should carefully check RBAC controls to ensure that only limited service accounts and users are given permission to access that PSP."
  impact 0.0

  tag cis: 'kubernetes:5.2.8'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.8' do
    skip 'Get the set of PSPs with the `kubectl get psp` command. Verify that there are no PSPs present which have allowedCapabilities set to anything other than an empty array.'
  end
end

control 'cis-kubernetes-benchmark-5.2.9' do
  title 'Minimize the admission of containers with capabilities assigned'
  desc "Do not generally permit containers with capabilities.\n\nRationale: Containers run with a default set of capabilities as assigned by the Container Runtime. Capabilities are parts of the rights generally granted on a Linux system to the root user. In many cases applications running in containers do not require any capabilities to operate, so from the perspective of the principal of least privilege use of capabilities should be minimized."
  impact 0.0

  tag cis: 'kubernetes:5.2.9'
  tag level: 1

  describe 'cis-kubernetes-benchmark-5.2.9' do
    skip "Get the set of PSPs with the `kubectl get psp` command. For each PSP review the output of `kubectl get psp <name> -o=jsonpath='{.spec.requiredDropCapabilities}'` and check whether capabilities have been forbidden."
  end
end
