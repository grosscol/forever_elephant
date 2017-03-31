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
    class BeginReplications < RegalBird::Source

      def execute
        wrap_execution do
          replications.map do |replication|
            RegalBird::ActionSuccess.new(:ready, {replication: replication})
          end
        end
      end

      private

      def replications
        replications = []
        client.replications(replications_query) do |response|
          raise RuntimeError, response.body unless response.success?
          replications << response.body
        end
        replications
      end

      def replications_query
        {
          to_node: ForeverElephant.config.local_namespace,
          cancelled: false,
          stored: false
        }
      end

      def client
        @client ||= RemoteClient.new(
          NodeRepo.for(ForeverElephant.config.local_namespace),
          ForeverElephant.config.logger)
      end

    end
  end
end
