module Domain
  module BaseObject
    def apply(event, is_new_event: true)
      handler = event.handler
      handler.handle(self, event)
    end
  end
end
