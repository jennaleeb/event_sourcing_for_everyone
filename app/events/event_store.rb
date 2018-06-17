
class EventStore
  cattr_accessor :event_streams

  @@event_streams={}

  def self.save(event)
    current_stream = @@event_streams[event.object_reference_id] || []
    current_stream << event
    @@event_streams[event.object_reference_id] = current_stream
  end

  def self.load(klass, uuid = nil)
    object = klass.new
    object.uuid = uuid
    events = @@event_streams[uuid]
    object.rebuild(events) if events.present?
    object
  end
end
