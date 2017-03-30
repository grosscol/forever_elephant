# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require 'pairtree'

module Client
  module Repl

    class Storer < Action

      class DefaultMethod
        RSYNC_OPTIONS = ["-r -k --partial -q --copy-unsafe-links"]

        def self.store(source, uuid)
          pairtree = Pairtree.at(Rails.configuration.repo_dir, create: true)
          ppath = pairtree.mk(uuid)
          rsync(File.join(source, "*"), ppath.path)
        end

        def self.rsync(source, destination)
          Rsync.run(source, destination, RSYNC_OPTIONS) do |result|
            result
          end
        end
      end

      Result = Struct.new(:success?, :error)


      def initialize(event_log, method = DefaultMethod)
        @event_log = event_log
        @method = method
      end

      def store
        result = store_bag
        if result.success?
          FileUtils.remove_entry_secure event_log.get(:staging_location)
          FileUtils.remove_entry_secure event_log.get(:unpacked_location)
          event(:stored, {})
        else
          event(:received_notified, {storer: {errors: result.error}})
        end
      end

      private

      attr_reader :event_log, :method

      def store_bag
        begin
          result = method.store(event_log.get(:unpacked_location), event_log.get(:bag))
          Result.new(result.success?, result.error)
        rescue IOError, SystemCallError => e
          Result.new(false, "#{e.message}\n#{e.backtrace}")
        end
      end
    end

  end
end
