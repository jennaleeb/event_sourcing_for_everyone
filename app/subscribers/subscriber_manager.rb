class SubscriberManager
  def self.notify_subscribers(event, is_new_event)
    ALL_SUBSCRIBERS.each do |subscriber|
      subscriber.new(event, is_new_event).process
    end
  end

  ALL_SUBSCRIBERS = [
    Projectors::AllAccounts,
    Projectors::ActiveAccounts,
    Reactors::DisabledAccountEmailSender
  ]
end
