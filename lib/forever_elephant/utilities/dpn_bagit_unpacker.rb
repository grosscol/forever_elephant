# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "pathname"
require "dpn/bagit"

module ForeverElephant
  module Hathitrust

    class DpnBagitUnpacker
      # @param file [Pathname]
      # @return [Pathname] The location of the deserialized bag.
      # @raises RuntimeError, IOError, SystemCallError
      def unpack(file)
        return file if file.directory?
        bag = DPN::Bagit::SerializedBag.new(file).unserialize!
        return Pathname.new(bag.location)
      end
    end

  end
end

