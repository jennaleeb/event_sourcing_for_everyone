require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "plan_tier can only be free, paid or advanced" do
    account = Domain::AccountObject.new
    assert_raises ArgumentError do
      account.change_plan(new_plan_tier: 'foo')
    end

    refute_equal 'foo', account.plan_tier
  end

  test "plan_tier can transition from free to paid" do
    account = Domain::AccountObject.new
    account.change_plan(new_plan_tier: 'free')
    account.change_plan(new_plan_tier: 'paid')

    assert_equal 'paid', account.plan_tier
  end

  test "plan_tier can only transition to advanced from paid" do
    account = Domain::AccountObject.new
    account.change_plan(new_plan_tier: 'free')

    assert_raises ArgumentError do
      account.change_plan(new_plan_tier: 'advanced')
    end
  end

  test "account can only become active if email is present" do
    account = Domain::AccountObject.new
    assert_raises ArgumentError do
      account.register(email: nil)
    end
  end

  test "account can become active if email is present" do
    account = Domain::AccountObject.new
    account.register(email: 'some-email@mail.com')

    assert account.is_active
    assert_equal 'some-email@mail.com', account.email
  end

  test "is_active is false if disabled" do
    account = Domain::AccountObject.new
    account.disable(reason: nil)

    refute account.is_active
  end

  test "email sent if disabled reason is manual" do
    account = Domain::AccountObject.new
    SendSorryToSeeYouGoEmailJob.expects(:perform_later).once
    account.disable(reason: Domain::AccountObject::DISABLED_REASONS[:manually_disabled])

    refute account.is_active
  end
end
