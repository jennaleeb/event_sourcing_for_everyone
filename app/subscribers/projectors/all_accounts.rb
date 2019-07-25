module Projectors
  class AllAccounts < Subscribers::BaseSubscriber
    def process
      projector = projector(event)
      send(projector, event) if projector
    end

    private

    def projector(event)
      case event
      when Events::Account::Registered
        :create_account
      when Events::Account::PlanChanged
        :change_plan
      when Events::Account::Disabled
        :mark_account_disabled
      end
    end

    def create_account(event)
      account = Account.find_or_create_by!(uuid: event.object_reference_id)
      account.update(is_active: true, email: event.payload[:email])
    end

    def change_plan(event)
      account = Account.find_by(uuid: event.object_reference_id)
      account.update(plan_tier: event.payload[:new_plan]) if account
    end

    def mark_account_disabled(event)
      account = Account.find_by(uuid: event.object_reference_id)
      account.update(is_active: false) if account
    end
  end
end
