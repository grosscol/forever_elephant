# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"
require "pathname"
require "forever_elephant/utilities/rsync_retriever"

module ForeverElephant
  module Hathitrust

    class Retrieve < RegalBird::Action

      def initialize(event_log, method = RsyncRetriever.new)
        @method = method
        @event_log = event_log
      end

      def execute
        wrap_execution do
          src = Pathname.new event_log.get(:source_location)
          dest = Pathname.new event_log.get(:staging_location)
          FileUtils.mkdir_p dest.dirname
          method.retrieve(src, dest) do |result|
            RegalBird::ActionSuccess.new(:retrieved, {})
          end
        end
      end

      private
      attr_reader :event_log, :method
    end

  end
end
