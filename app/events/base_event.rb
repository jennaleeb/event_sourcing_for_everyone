
module Events
  class BaseEvent
    attr_reader :payload, :object_reference_id, :object_type, :timestamp

    def initialize(params = {})
      @timestamp = Time.now.utc
      @object_reference_id = params[:object_reference_id]
      @object_type = params[:object_type]
      @payload = params[:payload]
    end

    def handler
      raise NotImplementedError, 'derrived classes must implement #handler'
    end
  end
end
