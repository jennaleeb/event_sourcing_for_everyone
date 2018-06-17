require 'test_helper'

class AllAccountsTest < ActiveSupport::TestCase
  def setup
    # reset in-memory dbs
    Account.destroy_all
    EventStore.event_streams = {}
  end

  test "account projector creates a new Account record when an account_registered event occurs" do
    event = Events::Account::Registered.new(
      payload: {
        is_active: true,
        email: 'some-email@mail.com'
      }
    )
    account = EventStore.load(Domain::AccountObject)
    account.apply(event)

    assert_equal 1, Account.count
  end

  test "projector can be rebuilt from events" do
    account = register_account_command
    change_plan_command(account)

    assert_equal 2, EventStore.event_streams[account.uuid].length
    assert_equal 1, Account.count

    Account.destroy_all

    EventStore.load(Domain::AccountObject, account.uuid)

    assert_equal 1, Account.count
    assert_equal 'paid', Account.first.plan_tier
  end
end
