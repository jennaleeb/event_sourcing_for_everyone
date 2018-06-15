
module Events
  class BaseEvent
    attr_accessor :timestamp
    attr_reader :object_reference_id
    attr_reader :payload

    def initialize(params={})
      self.timestamp = Time.now.utc
      @object_reference_id = params[:object_reference_id]
      @payload = params[:payload]
    end

    def handler
      raise NotImplementedError, 'derrived classes must implement #handler'
    end
  end
end
