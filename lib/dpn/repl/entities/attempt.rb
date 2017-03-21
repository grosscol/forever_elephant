# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class Attempt

  def initialize(action:, state:, start_time:, end_time:, errors:)
    @action = action
    @state = state
    @start_time = start_time
    @end_time = end_time
    @errors = errors
  end

  attr_reader :start_time, :end_time, :errors

  def success?
    state == :success
  end

  def ongoing?
    state == :ongoing
  end

  def fail?
    state == :fail
  end

  def finish(successfail, errors = [])
    self.state = successfail ? :success : :fail
    self.end_time = Time.now.utc
    self.errors = errors
  end

  def succeed
    finish(true, [])
  end

  def fail(errors = [])
    finish(false, errors)
  end

  private

  attr_writer :state, :errors, :start_time, :end_time

end

