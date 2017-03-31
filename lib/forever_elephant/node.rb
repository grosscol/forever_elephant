# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module ForeverElephant

  class Node

    attr_reader :namespace, :api_root, :credential

    def initialize(namespace:, api_root:, credential:)
      @namespace = namespace
      @api_root = api_root
      @credential = credential
    end

  end

end
