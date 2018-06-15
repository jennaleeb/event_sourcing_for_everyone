require 'test_helper'

class EventStoreTest < ActiveSupport::TestCase
  def setup
    EventStore.event_streams = {} # "resetting db"
  end

  test 'event stream is empty if no events' do
    account = Account.new
    assert_equal ({}), EventStore.event_streams
  end

  test 'stores events in event stream' do
    account = Account.new
    account.apply(account_registered_event)
    assert_equal 1, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'some-email@mail.com'
    }), EventStore.event_streams[account.uuid].first.payload

    account = EventStore.load(Account, account.uuid)
    account.apply(account_disabled_event)
    assert_equal 2, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: false,
      reason: 'some reason'
    }), EventStore.event_streams[account.uuid].last.payload
  end

  test 'different objects different event streams' do
    account = Account.new
    account.apply(account_registered_event)
    assert_equal 1, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'some-email@mail.com'
    }), EventStore.event_streams[account.uuid].first.payload

    another_account = Account.new
    another_account.apply(account_registered_event('another_email@mail.com'))
    assert_equal 1, EventStore.event_streams[another_account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'another_email@mail.com'
    }), EventStore.event_streams[another_account.uuid].first.payload
  end

  test 'events are cleared after saving to db/repository layer' do
    account = Account.new
    event = Events::Account::Registered.new(
      payload: {
        is_active: true,
        email: 'some-email@mail.com'
      }
    )
    account.apply(event)

    assert_equal [], account.dirty_events
  end

  test 'load recreates from events' do
    account = Account.new
    account.apply(account_registered_event)
    account.apply(plan_changed_event)
    account.apply(account_disabled_event)

    account = EventStore.load(Account, account.uuid)

    refute account.is_active
    assert_equal 'paid', account.plan_tier
  end

  test 'load works even if no events' do
    account = Account.new
    account = EventStore.load(Account, account.uuid)

    refute account.is_active
  end

  test 'save handles no events gracefully' do
    account = Account.new
    event_stream = EventStore.save(account)

    assert event_stream.empty?
  end

  private

  def account_registered_event(email = 'some-email@mail.com')
    Events::Account::Registered.new(
      payload: {
        is_active: true,
        email: email
      }
    )
  end

  def plan_changed_event
    Events::Account::PlanChanged.new(
      payload: {
        old_plan: 'free',
        new_plan: 'paid'
      }
    )
  end

  def account_disabled_event
    Events::Account::Disabled.new(
      payload: {
        is_active: false,
        reason: 'some reason'
      }
    )
  end
end
