# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class RetrievalAttempt < Attempt
  def initialize(source_location, staging_location)
    super
    @source_location = source_location
    @staging_location = staging_location
  end

  attr_reader :source_location, :staging_location

end
