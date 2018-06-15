
module Events
  class BaseEvent
    attr_accessor :timestamp
    attr_reader :payload

    def initialize(params={})
      self.timestamp = Time.now.utc
      @payload = params[:payload]
    end

    def handler
      raise NotImplementedError, 'derrived classes must implement #handler'
    end
  end
end
