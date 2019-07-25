module Projectors
  class ActiveAccounts < Subscribers::BaseSubscriber
    cattr_accessor :active_accounts_count_report
    @@active_accounts_count_report = {active: 0, inactive: 0}

    def process
      return unless is_new_event
      projector = projector(event)
      send(projector, event) if projector
    end

    private

    def projector(event)
      case event
      when Events::Account::Registered
        :create_account
      when Events::Account::Disabled
        :remove_account
      end
    end

    def create_account(event)
      active_accounts_count_report[:active] += 1
    end

    def remove_account(event)
      active_accounts_count_report[:inactive] += 1
    end
  end
end
