# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"
require "pathname"
require "forever_elephant/utilities/dpn_bagit_fixity_generator"

module ForeverElephant
  module Hathitrust

    class GenerateFixity < RegalBird::Action
      def initialize(event_log, method = DpnBagitFixityGenerator.new)
        @method = method
        @event_log = event_log
      end

      def execute
        wrap_execution do
          unpacked_location = Pathname.new event_log.get(:unpacked_location)
          fixity = method.sha256(unpacked_location)
          RegalBird::ActionSuccess.new(:fixity_generated, {fixity_value: fixity})
        end
      end

      private
      attr_reader :method

    end
  end
end
