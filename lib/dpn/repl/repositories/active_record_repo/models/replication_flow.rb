# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class ReplicationFlow < ActiveRecord::Base
  has_many :retrieval_attempts, dependent: :destroy
  has_many :unpack_attempts, dependent: :destroy
  has_many :validate_attempts, dependent: :destroy
  has_many :fixity_attempts, dependent: :destroy
  has_many :received_notify_attempts, dependent: :destroy
  has_many :store_attempts, dependent: :destroy
  has_many :stored_notify_attempts, dependent: :destroy

  def self.successful(table)
    joins(table).where(table => {success: true})
  end

  def self.ongoing(table)
    joins(table).where(table => {end_time: nil})
  end

end
