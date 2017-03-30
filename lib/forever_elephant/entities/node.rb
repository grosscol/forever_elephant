

class Node

  attr_reader :namespace, :api_root, :credential

  def initialize(namespace:, api_root:, credential:)
    @namespace = namespace
    @api_root = api_root
    @credential = credential
  end

end
