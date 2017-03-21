# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class StoredNotifyAttempt < Attempt
  def initialize(replication)
    super
    @replication = replication
  end

  attr_reader :replication
end
