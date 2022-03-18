# frozen_string_literal: true

class ProcessEnvVar < Inspec.resource(1)
  name 'process_env_var'
  desc 'Custom resource to lookup environment variables for a process'
  example "
    describe process_env_var('etcd2') do
      its(:ETCD_DATA_DIR) { should match(%r{/var/lib/etcd2}) }
    end
  "

  # As described here https://github.com/inspec/inspec/blob/main/lib/inspec/resource.rb#L111
  # Inspec has a weird behaviour concerning super
  def initialize(process)
    @process = inspec.processes(process)
  end

  def respond_to_missing?(name)
    Log.debug("Missing #{name}")
  end

  def method_missing(name)
    read_params[name.to_s] || ''
  end

  def params
    return @params if defined?(@params)

    @file = inspec.file("/proc/#{@process.pids.first}/environ")
    unless @file.file?
      skip_resource "Can't find environ file for #{@process}"
      return @params = {}
    end

    @content = @file.content
    if @content.empty? && !@file.empty?
      skip_resource "Can't read environ file for #{@process}"
      return @params = {}
    end

    @params = @content.split("\0").map { |i| i.split('=', 2) }.to_h
  end

  def to_s
    "Enviroment variables for #{@process}"
  end
end
