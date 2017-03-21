# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class IReplicationFlowRepo
  def find_by_replication_id(id); end
  def find(id); end
  def save(flow); end

  def retrieved; end
  def unpacked; end
  def validated; end
  def fixity_complete; end
  def received_notified; end
  def stored; end
  def stored_notified; end

  def retrieval_ongoing; end
  def unpack_ongoing; end
  def validate_ongoing; end
  def fixity_ongoing; end
  def received_notify_ongoing; end
  def store_ongoing; end
  def stored_notify_ongoing; end
end
