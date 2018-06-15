class Account < ApplicationRecord

  validates :plan_tier, inclusion: { in: ['free', 'paid', 'advanced'] }

  DISABLED_REASONS={
    manually_disabled: 'Manually disabled',
    stripe_account_lookup_fail: 'Account lookup fail',
    payment_required: 'Payment required',
  }


  def register(params = {})
    raise ArgumentError unless params[:email].present?
    account_registered(
      Events::Account::Registered.new(
        payload: {
          is_active: true,
          email: params[:email]
        }
      )
    )
  end

  def change_plan(new_plan_tier:)
    if self.plan_tier == 'free' && new_plan_tier == 'advanced'
      raise ArgumentError, 'illegal plan transition'
    end

    plan_changed(
      Events::Account::PlanChanged.new(
        payload: {
          old_plan: self.plan_tier,
          new_plan: new_plan_tier
        }
      )
    )
  end

  def disable(reason:)
    account_disabled(
      Events::Account::Disabled.new(
        payload: {
          is_active: false,
          reason: reason
        }
      )
    )
  end

  private

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
      SendSorryToSeeYouGoEmailJob.perform_later(id)
    end
  end
end
