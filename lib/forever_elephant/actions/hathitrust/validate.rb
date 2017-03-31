# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"
require "pathname"
require "forever_elephant/utilities/dpn_bagit_validator"

module ForeverElephant
  module Hathitrust

    class Validate < RegalBird::Action
      def initialize(event_log, method = DpnBagitValidator.new)
        @event_log = event_log
        @method = method
      end

      def execute
        wrap_execution do
          path = Pathname.new event_log.get(:unpacked_location)
          safe_validate { method.validate(path) }
        end
      end

      private

      attr_reader :event_log, :method

      def safe_validate(&block)
        begin
          errors = block.call
          RegalBird::ActionSuccess.new(:validated, {
            bag_valid: errors.empty?,
            validation_errors: errors
          })
        rescue RuntimeError, IOError, SystemCallError => e
          RegalBird::ActionFailure.new("#{e.message}\n#{e.backtrace}")
        end
      end

    end
  end
end
