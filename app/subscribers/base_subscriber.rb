module Subscribers
  class BaseSubscriber
    attr_reader :event, :is_new_event
    def initialize(event, is_new_event)
      @event = event
      @is_new_event = is_new_event
    end

    private

    def valid?
      raise NotImplementedError, 'derived classes must implement #valid?'
    end
  end
end
