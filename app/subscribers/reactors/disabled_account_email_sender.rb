module Reactors
  class DisabledAccountEmailSender < Subscribers::BaseSubscriber
    def process
      return unless valid?
      SendSorryToSeeYouGoEmailJob.perform_later(event.object_reference_id)
    end

    private

    def valid?
      event.is_a?(Events::Account::Disabled) &&
      is_new_event &&
      event.payload[:reason] == Domain::AccountObject::DISABLED_REASONS[:manually_disabled]
    end
  end
end  
