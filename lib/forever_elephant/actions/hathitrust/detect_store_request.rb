# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "forever_elephant/node_repo"
require "forever_elephant/remote_client"
require "regal_bird"
require "pathname"

module ForeverElephant
  module Hathitrust
    class DetectStoreRequest < RegalBird::Action

      def execute
        wrap_execution do
          if replication[:cancelled]
            RegalBird::ActionSuccess.new(:cancelled, {})
          elsif replication[:store_requested]
            RegalBird::ActionSuccess.new(:store_requested, {})
          else
            RegalBird::ActionNoop.new
          end
        end
      end

      private

      def replication
        client.replication(event_log.get(:replication)[:replication_id])
      end

      def client
        @client ||= RemoteClient.new(
          NodeRepo.for(ForeverElephant.config.local_namespace),
          ForeverElephant.config.logger)
      end

    end
  end
end
