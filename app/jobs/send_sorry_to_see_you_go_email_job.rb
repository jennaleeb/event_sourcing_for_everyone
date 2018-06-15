class SendSorryToSeeYouGoEmailJob < ApplicationJob
  def perform(id)
    account = Account.find_by(id: id)
    # send email to account.email
    # no job queing system added, just example
  end
end
