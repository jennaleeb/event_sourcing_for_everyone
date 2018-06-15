module Events
  module Account
    class Registered < BaseEvent
      def handler
        RegisteredHandler
      end
    end

    class RegisteredHandler
      def self.handle(object, event)
        object.public_send(:account_registered, event)
      end
    end
  end
end
