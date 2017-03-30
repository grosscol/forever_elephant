# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module Client
  module Repl

    class Validator < Action

      class DefaultMethod
        Result = Struct.new(:valid?, :validation_errors)
        def self.validate_bag(location)
          bag = DPN::Bagit::Bag.new(location)
          Result.new(bag.valid?, bag.errors)
        end
      end

      Result = Struct.new(:success?, :bag_valid?, :validation_errors, :error)

      attr_reader :event_log, :method

      def initialize(event_log, method = DefaultMethod)
        @event_log = event_log
        @method = method
      end

      def execute
        result = validate_bag(event_log.get(:unpacked_location))
        if result.success?
          event(:validated, {bag_valid: result.bag_valid?, validation_errors: result.validation_errors})
        else
          event(:unpacked, {validator: {errors: result.error}} )
        end
      end

      private

      def validate_bag(bag_location)
        begin
          result = method.validate_bag(bag_location)
          Result.new(true, result.valid?, result.validation_errors, nil)
        rescue RuntimeError, IOError, SystemCallError => e
          Result.new(false, nil, nil, "#{e.message}\n#{e.backtrace}")
        end
      end

    end
  end
end
