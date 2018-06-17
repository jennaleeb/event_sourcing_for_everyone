module Commands
  module Account
    module ChangePlan
      class Command < BaseCommand
        attr_reader :args, :payload
        def validate!
          account = EventStore.load(Domain::AccountObject, args[:object_reference_id])

          raise ArgumentError, 'object_reference_id is missing' if args[:object_reference_id].nil?
          raise ArgumentError, 'plan tier is missing' if args[:new_plan_tier].nil?
          raise ArgumentError, 'plan tier is invalid' unless Domain::AccountObject::VALID_PLANS.include?(args[:new_plan_tier])
          raise ArgumentError, 'invalid transition' if account.plan_tier == 'free' && args[:new_plan_tier] == 'advanced'
        end
      end

      class CommandHandler
        def handle(command)
          account = EventStore.load(Domain::AccountObject, command.args[:object_reference_id])
          account.apply(
            Events::Account::PlanChanged.new(
              object_reference_id: command.args[:object_reference_id],
              payload: {
                old_plan: account.plan_tier,
                new_plan: command.args[:new_plan_tier]
              }
            )
          )
        end
      end
    end
  end
end

