# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class RsyncRetriever < Action

  SSH_OPTIONS = [
    "-o BatchMode=yes",
    "-o ConnectTimeout=3",
    "-o ChallengeResponseAuthentication=no",
    "-o PasswordAuthentication=no",
    "-o UserKnownHostsFile=/dev/null",
    "-o StrictHostKeyChecking=no",
    "-i #{Rails.configuration.transfer_private_key}"
  ]

  RSYNC_OPTIONS = ["-a --partial -q -k --copy-unsafe-links -e 'ssh #{SSH_OPTIONS.join(" ")}' "]

  Result = Struct.new(:success?, :error)

  def initialize(event_log, method = Rsync)
    @method = method
    @event_log = event_log
  end

  def execute
    @start_time = Time.now.utc
    result = transfer(event_log.get(:source_location), event_log.get(:staging_location))
    if result.success?
      event(:retrieved, {})
    else
      event(:ready, {rsync_retriever: { errors: result.error}})
    end
  end

  private

  attr_reader :event_log, :method



  def transfer(source, destination)
    begin
      parent_folder = File.dirname(destination)
      FileUtils.mkdir_p(parent_folder) unless File.exist?(parent_folder)
      method.run(source, destination, RSYNC_OPTIONS) do |result|
        result
      end
    rescue IOError, SystemCallError => e
      Result.new(false, "#{e.message}\n#{e.backtrace.join("\n")}")
    end
  end



end