# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class ReplicationFlow

  def initialize(replication_id:, link:, from_node:, bag:)
    @replication_id = replication_id
    @link = link
    @from_node = from_node
    @bag = bag
    @retrieval_attempts = []
    @unpack_attempts = []
    @validate_attempts = []
    @fixity_attempts = []
    @received_notify_attempts = []
    @store_attempts = []
    @stored_notify_attempts = []
  end

  attr_reader :replication_id, :link, :from_node, :bag

  def retrieved?
    @retrieved ||= is_successful?(retrieval_attempts)
  end
  def unpacked?
    @unpacked ||= is_successful?(unpack_attempts)
  end
  def validated?
    @validated ||= is_successful?(validate_attempts)
  end
  def fixity_complete?
    @fixity_complete ||= is_successful?(fixity_attempts)
  end
  def received_notified?
    @received_notified ||= is_successful?(received_notify_attempts)
  end
  def stored?
    @stored ||= is_successful?(store_attempts)
  end
  def stored_notified?
    @stored_notified ||= is_successful?(stored_notify_attempts)
  end

  def retrieval_ongoing?
    @retrieval_ongoing ||= is_ongoing?(retrieval_attempts)
  end
  def unpack_ongoing?
    @unpack_ongoing ||= is_ongoing?(unpack_attempts)
  end
  def validate_ongoing?
    @validate_ongoing ||= is_ongoing?(validate_attempts)
  end
  def fixity__ongoing?
    @fixity_ongoing ||= is_ongoing?(fixity_attempts)
  end
  def received_notify_ongoing?
    @received_notify_ongoing ||= is_ongoing?(received_notify_attempts)
  end
  def store_ongoing?
    @store_ongoing ||= is_ongoing?(store_attempts)
  end
  def stored_notify_ongoing?
    @stored_notify_ongoing ||= is_ongoing?(stored_notify_attempts)
  end

  def source_location
    link
  end

  def staging_location
    File.join(Rails.configuration.staging_dir.to_s, from_node, File.basename(link))
  end

  def unpacked_location
    @unpacked_location ||= unpack_attempts.select(&:success?).first&.unpacked_location || ""
  end

  def bag_valid?
    @bag_valid ||= validate_attempts.select(&:success?).first&.bag_valid? || ""
  end

  def validation_errors
    @validation_errors ||= validate_attempts.select(&:success?).first&.validation_errors || []
  end

  def fixity_value
    @fixity_value ||= fixity_attempts.select(&:success?).first&.value || ""
  end

  private

  def is_successful?(attempts)
    !attempts.select(&:success?).empty?
  end

  def is_ongoing?(attempts)
    !attempts.select(&:is_ongoing?).empty?
  end

  attr_accessor :retrieval_attempts, :unpack_attempts,
    :validate_attempts, :fixity_attempts,
    :received_notify_attempts, :store_attempts,
    :stored_notify_attempts

end
