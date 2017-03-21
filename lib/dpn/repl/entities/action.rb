class Action

  def initialize(thinger, flow, queue)
    @thinger = thinger
    @flow = flow
    @queue = queue
  end

  attr_reader :queue

  def execute
    @thinger.execute(@flow)
  end

end