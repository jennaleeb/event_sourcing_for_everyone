module Events
  module Account
    class Disabled < BaseEvent
      def handler
        DisabledHandler
      end
    end

    class DisabledHandler
      def self.handle(object, event)
        object.public_send(:account_disabled, event)
      end
    end
  end
end
