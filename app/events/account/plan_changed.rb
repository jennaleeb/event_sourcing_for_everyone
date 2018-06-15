module Events
  module Account
    class PlanChanged < BaseEvent
      def handler
        PlanChangedHandler
      end
    end

    class PlanChangedHandler
      def self.handle(object, event)
        object.public_send(:plan_changed, event)
      end
    end
  end
end
