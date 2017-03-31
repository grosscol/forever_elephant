# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "regal_bird"
require 'pairtree'

module ForeverElephant
  module Hathitrust

    class Store < RegalBird::Action

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

      def better
        wrap_executation do
          unpacked_location = Pathname.new event_log.get(:unpacked_location)
          uuid = event_log.get(:bag)
          result = safe_store { method.store(unpacked_location, bag) }
          if result.success?
            FileUtils.remove_entry_secure event_log.get(:staging_location)
            FileUtils.remove_entry_secure event_log.get(:unpacked_location)
          end
          result
        end
      end

      private

      attr_reader :event_log, :method

      def safe_store(&block)
        begin
          block.call
          RegalBird::ActionSuccess.new(:stored, {})
        rescue IOError, SystemCallError => e
          RegalBird::ActionFailure.new("#{e.message}\n#{e.backtrace}")
        end
      end

    end

  end
end
