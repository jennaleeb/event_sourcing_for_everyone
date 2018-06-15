class Account < ApplicationRecord

  validates :plan_tier, inclusion: { in: ['free', 'paid', 'advanced'] }

  DISABLED_REASONS={
    manually_disabled: 'Manually disabled',
    stripe_account_lookup_fail: 'Account lookup fail',
    payment_required: 'Payment required',
  }


  def register(params = {})
    raise ArgumentError unless params[:email].present?
    account_registered(params)
  end

  def change_plan(new_plan_tier:)
    if self.plan_tier == 'free' && new_plan_tier == 'advanced'
      raise ArgumentError, 'illegal plan transition'
    end

    plan_changed(new_plan_tier)
  end

  def disable(reason:)
    account_disabled(reason)
  end

  private

  def account_registered(params)
    self.is_active = true
    self.email = params[:email]
  end

  def plan_changed(new_plan_tier)
    self.plan_tier = new_plan_tier
  end

  def account_disabled(reason)
    self.is_active = false
    if reason == DISABLED_REASONS[:manually_disabled]
      SendSorryToSeeYouGoEmailJob.perform_later(id)
    end
  end
end
