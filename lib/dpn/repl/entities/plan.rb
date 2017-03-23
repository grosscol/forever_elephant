

# Represents a series or tree of instructions.
class Plan

  def self.define(&block)
    self.new.instance_eval(&block)
  end

  def initialize
    @map = {}
  end

  # @param value [Symbol]
  # @return [Event]
  def [](value)
    @map[value.to_sym]
  end
  alias_method :action, :[]

  private

  # @param state [Symbol]
  # @param action_factory [Action.class]
  def add(state, action_factory)
    @map[state.to_sym] = action_factory
  end

end