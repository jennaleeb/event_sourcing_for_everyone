class Account < ApplicationRecord

  validates :plan_tier, inclusion: { in: ['free', 'paid', 'advanced'] }

  DISABLED_REASONS={
    manually_disabled: 'Manually disabled',
    stripe_account_lookup_fail: 'Account lookup fail',
    payment_required: 'Payment required',
  }


  def register(params = {})
    raise ArgumentError unless params[:email].present?
    self.is_active = true
    self.email = params[:email]
  end

  def change_plan(new_plan_tier:)
    if self.plan_tier == 'free' && new_plan_tier == 'advanced'
      raise ArgumentError, 'illegal plan transition'
    end

    self.plan_tier = new_plan_tier
  end

  def disable(reason:)
    if reason == DISABLED_REASONS[:manually_disabled]
      SendSorryToSeeYouGoEmailJob.perform_later(id)
    end
    self.is_active = false
  end
end
