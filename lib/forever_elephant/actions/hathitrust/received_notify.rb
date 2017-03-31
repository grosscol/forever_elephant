# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"

module ForeverElephant
  module Hathitrust

    class ReceivedNotify < RegalBird::Action
      def execute
        wrap_execution do
          result = client.update_replication(replication)
          if result.success?
            RegalBird::ActionSuccess.new(:received_notified, {})
          else
            RegalBird::ActionFailure.new(result.error)
          end
        end
      end

      private

      def replication
        unless @replication
          @replication = event_log.get(:replication)
          @replication[:fixity_value] = event_log.get(:fixity_value)
          @replication[:bag_valid] = event_log.get(:bag_valid)
          unless @replication[:bag_valid]
            @replication[:cancelled] = true
            @replication[:cancel_reason] = 'bag_invalid'
            @replication[:cancel_reason_detail] = event_log.get(:validation_errors).flatten.join("\n")
          end
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
