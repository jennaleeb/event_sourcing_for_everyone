
class EventStore
  cattr_accessor :event_streams

  @@event_streams={}

  def self.save(object)
    current_stream = @@event_streams[object.uuid] || []
    current_stream << object.dirty_events
    @@event_streams[object.uuid] = current_stream.flatten!
  end

  def self.load(klass, uuid = nil)
    object = klass.new
    object.uuid = uuid
    events = @@event_streams[uuid] || []
    object.rebuild(events)
    object
  end
end
