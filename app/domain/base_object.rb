module Domain
  module BaseObject
    attr_writer :uuid

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def apply(event, is_new_event: true)
      handler = event.handler
      handler.handle(self, event)
      persist_events(event) if is_new_event
    end

    def rebuild(events)
      events.each do |event|
        apply(event, is_new_event: false)
      end
    end

    def dirty_events
      @dirty_events ||= []
    end

    private

    def persist_events(event)
      dirty_events.push(event)
      EventStore.save(self)
      clear_dirty_events
    end

    def clear_dirty_events
      @dirty_events = []
    end
  end
end
