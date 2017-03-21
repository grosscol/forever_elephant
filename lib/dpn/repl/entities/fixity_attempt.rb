# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class FixityAttempt < Attempt
  def initialize(unpacked_location)
    @value = ""
    @unpacked_location = unpacked_location
  end

  attr_reader :unpacked_location, :value

  def succeed(value)
    self.value = value
    finish(true, [])
  end

  private

  attr_writer :value
end

