# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "rsync"

module ForeverElephant
  class RsyncRetriever

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

    def retrieve(source, destination)
      RSync.run(source, destination, RSYNC_OPTIONS) do |result|
        result
      end
    end

  end
end
