# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"
require "pathname"
require "forever_elephant/utilities/dpn_bagit_unpacker"

module ForeverElephant
  module Hathitrust

    class Unpack < RegalBird::Action
      def initialize(event_log, method = DpnBagitUnpacker.new)
        @event_log = event_log
        @method = method
      end

      def execute
        wrap_execution do
          path = Pathname.new event_log.get(:staging_location)
          unpacked_location = method.unpack(path)
          RegalBird::ActionSuccess.new(:unpacked, {unpacked_location: unpacked_location})
        end
      end

      private
      attr_reader :method
    end

  end
end
