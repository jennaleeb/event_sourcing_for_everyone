module Events
  module Account
    class Disabled < BaseEvent
      def handler
        :account_disabled
      end
    end
  end
end
