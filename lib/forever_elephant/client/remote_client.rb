# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module Client

  # A client connection to a remote node.
  class RemoteClient

    # Create a RemoteClient instance.  The connection is NOT
    # initialized until you issue a query.
    # @param [Node] node
    # @param [Logger] logger A logger, e.g. the Rails logger.
    def initialize(node, logger)
      @node = node
      @logger = logger
    end


    # Execute the given query.
    # @param [Query] query A Query instance.
    # @yield [DPN::Client::Response] Yields each record within the response
    #   to the passed block.
    def execute(query, &block)
      client.public_send(query.type, query.params) do |response|
        yield response
      end
      client.send(:connection).reset_all
    end

    private

    attr_reader :node, :logger

    def client
      @client ||= DPN::Client.client.configure do |c|
        c.api_root = node.api_root
        c.auth_token = node.credential
        c.logger = logger
      end
    end


  end
end


