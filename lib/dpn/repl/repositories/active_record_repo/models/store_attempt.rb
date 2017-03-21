# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class StoreAttempt < ActiveRecord::Base
  belongs_to :replication_flow
  scope :ongoing, -> { where(end_time: nil) }
  scope :successful, -> { where(success: true) }
end
