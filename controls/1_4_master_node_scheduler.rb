title '1.4 Master Node: Scheduler'

scheduler = attribute('scheduler')
# fallback if scheduler attribute is not defined
scheduler = kubernetes.scheduler_bin if scheduler.empty?

only_if('scheduler not found') do
  processes(scheduler).exists?
end

control 'cis-kubernetes-benchmark-1.4.1' do
  title 'Ensure that the --profiling argument is set to false'
  desc "Disable profiling, if not needed.\n\nRationale: Profiling allows for the identification of specific performance bottlenecks. It generates a significant amount of program data that could potentially be exploited to uncover system and program details. If you are not experiencing any bottlenecks and do not need the profiler for troubleshooting purposes, it is recommended to turn it off to reduce the potential attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.4.1'
  tag level: 1

  describe processes(scheduler).commands.to_s do
    it { should match(/--profiling=false/) }
  end
end

control 'cis-kubernetes-benchmark-1.4.2' do
  title 'Ensure that the --address argument is set to 127.0.0.1'
  desc "Do not bind the scheduler service to non-loopback insecure addresses.\n\nRationale: The Scheduler API service which runs on port 10251/TCP by default is used for health and metrics information and is available without authentication or encryption. As such it should only be bound to a localhost interface, to minimize the cluster's attack surface."
  impact 1.0

  tag cis: 'kubernetes:1.4.2'
  tag level: 1

  describe.one do
    describe processes(scheduler).commands.to_s do
      it { should match(/--address=127\.0\.0\.1/) }
    end
    describe processes(scheduler).commands.to_s do
      it { should match(/--bind-address=127\.0\.0\.1/) }
    end
  end
end
