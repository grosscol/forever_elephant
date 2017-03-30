# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module Client
  module Repl

    class FixityGenerator < Action

      class DefaultMethod
        def self.sha256(location)
          DPN::Bagit::Bag.new(location).fixity(:sha256)
        end
      end

      Result = Struct.new(:success?, :value, :error)



      def execute
        result = fixity(event_log.get(:unpacked_location))
        if result.success?
          event(:fixity_complete, {fixity_value: result.value})
        else
          event(:validated, {fixity_generator: {errors: result.error}})
        end
      end

      private

      def fixity(bag_location)
        begin
          Result.new(true, method.sha256(bag_location), nil)
        rescue RuntimeError, IOError, SystemCallError => e
          Result.new(false, nil, "#{e.message}\n#{e.backtrace}")
        end
      end

    end
  end
end
