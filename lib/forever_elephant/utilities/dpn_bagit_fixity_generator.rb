# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "dpn/bagit"

module ForeverElephant
  module Hathitrust

    class DpnBagitFixityGenerator
      def sha256(location)
        DPN::Bagit::Bag.new(location).fixity(:sha256)
      end
    end

  end
end
