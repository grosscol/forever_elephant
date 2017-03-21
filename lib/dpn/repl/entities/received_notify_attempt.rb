# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class ReceivedNotifyAttempt < Attempt
  def initialize(replication, fixity_value, bag_validity, bag_errors)
    super
    @replication = replication
    @fixity_value = fixity_value
    @bag_validity = bag_validity
    @bag_errors = bag_errors || []
  end

  attr_reader :replication, :fixity_value,
    :bag_validity, :bag_errors

end
