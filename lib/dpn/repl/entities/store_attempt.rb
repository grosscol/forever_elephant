# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class StoreAttempt < Attempt
  def initialize(bag, staging_location, unpacked_location)
    @bag = bag
    @staging_location = staging_location
    @unpacked_location = unpacked_location
  end

  attr_reader :bag, :staging_location, :unpacked_location
end
