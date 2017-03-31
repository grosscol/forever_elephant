# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "dpn/bagit"

module ForeverElephant
  module Hathitrust

    class DpnBagitValidator
      def validate(location)
        bag = DPN::Bagit::Bag.new(location)
        bag.valid?
        return bag.errors
      end
    end

  end
end
