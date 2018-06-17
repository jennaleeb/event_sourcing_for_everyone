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


    def register(params = {})
      raise ArgumentError unless params[:email].present?
      apply(
        Events::Account::Registered.new(
          object_reference_id: self.uuid,
          object_type: self.class,
          payload: {
            is_active: true,
            email: params[:email]
          }
        )
      )
    end

    def change_plan(new_plan_tier:)
      raise ArgumentError unless VALID_PLANS.include?(new_plan_tier)

      if self.plan_tier == 'free' && new_plan_tier == 'advanced'
        raise ArgumentError, 'illegal plan transition'
      end

      apply(
        Events::Account::PlanChanged.new(
          object_reference_id: self.uuid,
          object_type: self.class.to_s,
          payload: {
            old_plan: self.plan_tier,
            new_plan: new_plan_tier
          }
        )
      )
    end

    def disable(reason:)
      apply(
        Events::Account::Disabled.new(
          object_reference_id: self.uuid,
          object_type: self.class.to_s,
          payload: {
            is_active: false,
            reason: reason
          }
        )
      )
    end

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
