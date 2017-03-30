# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module Client
  module Repl

    class Unpacker < Action

      Result = Struct.new(:success?, :path, :error)

      class DefaultMethod
        Result = Struct.new(:success?, :bag, :error)

        # @raises RuntimeError, IOError, SystemCallError
        def self.unpack_tar(file)
          bag = DPN::Bagit::SerializedBag.new(file).unserialize!
          Result.new(true, bag, nil)
        end
      end

      attr_reader :event_log, :method

      def initialize(event_log, method = DefaultMethod)
        @event_log = event_log
        @method = method
      end

      def execute
        result = unpack_bag(event_log.get(:staging_location))
        if result.success?
          event(:unpacked, {unpacked_location: result.path})
        else
          event(:retrieved, {unpacker: {errors: result.error}})
        end
      end

      private

      # @param path [String] bag location
      # @return Result that responds to #success?
      def unpack_bag(path)
        return Result.new(true, path, nil) if File.directory?(path)
        case File.extname path
        when ".tar"
          safe_unpack { method.unpack_tar(path) }
        else
          Result.new(false, nil, "Unrecognized file type #{File.extname(path)}")
        end
      end

      # @param file [String] location of a serialized bag (.tar file)
      def safe_unpack(&block)
        begin
          result = block.call
          Result.new(result.success?, result.bag&.location, result.error)
        rescue RuntimeError, IOError, SystemCallError => e
          Result.new(false, nil, "#{e.message}\n#{e.backtrace}")
        end
      end


    end
  end
end


# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class Unpacker < Action

  attr_reader :event_log, :method

  def initialize(event_log, method = DefaultMethod)
    @event_log = event_log
    @method = method
  end

  def execute
    path = event_log.get(:staging_location)
    if File.directory?(path)
      event(:unpacked, {unpacked_location: path})
    else
      if File.extname(path) == ".tar"
        begin
          bag = DPN::Bagit::SerializedBag.new(path).unserialize!
          event(:unpacked, {unpacked_location: bag.location})
        rescue RuntimeError, IOError, SystemCallError => e
          event(:retrieved, {unpacker: {errors: ["#{e.message}\n#{e.backtrace}"]}})
        end
      else
        event(:retrieved, {unpacker: {errors: ["Unrecognized file type #{File.extname(path)}"]}})
      end
    end
  end

end

