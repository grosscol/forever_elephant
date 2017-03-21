# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class UnpackAttempt < Attempt
  def initialize(staging_location)
    @staging_location = staging_location
    @unpacked_location = nil
  end

  attr_reader :staging_location, :unpacked_location

  def succeed(unpacked_location)
    self.unpacked_location = unpacked_location
    finish(true, [])
  end

  private

  attr_writer :unpacked_location
end
