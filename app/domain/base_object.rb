module Domain
  module BaseObject
    attr_writer :uuid

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def apply(event, is_new_event: true)
      handle(event)
      publish(event, is_new_event)
    end

    def rebuild(events)
      events.each do |event|
        apply(event, is_new_event: false)
      end
    end

    private

    def handle(event)
      handler = event.handler
      if self.respond_to? handler
        public_send(handler, event)
      end
    end

    def publish(event, is_new_event)
      EventStore.save(event) if is_new_event
    end
  end
end
