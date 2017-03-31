# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"

module ForeverElephant
  module Hathitrust

    class StoredNotify < RegalBird::Action
      def execute
        wrap_execution do
          result = client.update_replication(replication)
          if result.success?
            RegalBird::ActionSuccess.new(:stored_notified, {})
          else
            RegalBird::ActionFailure.new(result.error)
          end
        end
      end

      private

      def replication
        unless @replication
          @replication = event_log.get(:replication)
          @replication[:stored] = true
        end
        @replication
      end

      def client
        RemoteClient.new(
          NodeRepo.for(replication[:from_node]),
          ForeverElephant.config.logger)
      end


    end
  end
end
