module Events
  module Account
    class PlanChanged < BaseEvent
      def handler
        :plan_changed
      end
    end
  end
end
