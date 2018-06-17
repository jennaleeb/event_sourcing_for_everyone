module Domain
  class AccountObject
    include BaseObject
    attr_accessor :is_active, :email, :plan_tier

    VALID_PLANS = ["free", "paid", "advanced"]
    DISABLED_REASONS={
      manually_disabled: 'Manually disabled',
      stripe_account_lookup_fail: 'Account lookup fail',
      payment_required: 'Payment required',
    }

    def account_registered(event)
      self.is_active = event.payload[:is_active]
      self.email = event.payload[:email]
    end

    def plan_changed(event)
      self.plan_tier = event.payload[:new_plan]
    end

    def account_disabled(event)
      self.is_active = event.payload[:is_active]
      if event.payload[:reason] == DISABLED_REASONS[:manually_disabled]
        SendSorryToSeeYouGoEmailJob.perform_later(uuid)
      end
    end
  end
end
