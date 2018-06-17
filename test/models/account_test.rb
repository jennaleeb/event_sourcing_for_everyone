require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "plan_tier can only be free, paid or advanced" do
    account = register_account_command
    assert_raises ArgumentError do
      change_plan_command(account, new_plan_tier: 'foo')
    end

    refute_equal 'foo', account.plan_tier
  end

  test "plan_tier can transition from free to paid" do
    account = register_account_command
    change_plan_command(account, new_plan_tier: 'free')
    change_plan_command(account, new_plan_tier: 'paid')

    account = EventStore.load(Domain::AccountObject, account.uuid)

    assert_equal 'paid', account.plan_tier
  end

  test "plan_tier can only transition to advanced from paid" do
    account = register_account_command
    change_plan_command(account, new_plan_tier: 'free')

    assert_raises ArgumentError do
      change_plan_command(account, new_plan_tier: 'advanced')
    end
  end

  test "account can only become active if email is present" do
    assert_raises ArgumentError do
      register_account_command(email: nil)
    end
  end

  test "account can become active if email is present" do
    account = register_account_command

    assert account.is_active
    assert_equal 'some-email@mail.com', account.email
  end

  test "is_active is false if disabled" do
    account = register_account_command
    account = disable_command(account)

    refute account.is_active
  end

  test "email sent if disabled reason is manual" do
    account = register_account_command
    SendSorryToSeeYouGoEmailJob.expects(:perform_later).once
    account = disable_command(account, reason: Domain::AccountObject::DISABLED_REASONS[:manually_disabled])

    refute account.is_active
  end
end
