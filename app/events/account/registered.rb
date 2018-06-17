module Events
  module Account
    class Registered < BaseEvent
      def handler
        :account_registered
      end
    end
  end
end
