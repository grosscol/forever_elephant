
# Tracks individual progress on a plan
class Progress

  attr_reader :id, :state, :events

  # @param id [String] unique id
  # @param plan [Plan]
  # @param initial_state [Symbol]
  def initialize(id, plan, initial_state)
    @id = id
    @plan = plan
    @state = initial_state.to_sym
    @events = []
  end

  # Given the current state, run the next action as directed
  # by the plan.  Store the resulting event and update the state
  # accordingly.
  def run_next
    event = @plan.action(@state).new(@events).execute
    @state = event.state.to_sym
    @events << event
  end

end