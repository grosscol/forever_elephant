class Action

  attr_reader :queue

  # @param events [Array<Event>]
  # @param queue [Symbol]
  def initialize(events, queue); end

  # @return [Event]
  def execute; end

end