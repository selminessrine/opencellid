class Notifier < ActionMailer::Base
  def apikey_notification(recipient)
    recipients recipient.email+",thomas.landspurg@gmail.com"
    from       "8Motions <info@8motions.com>"
    subject    "Your OpenCellID API Key!"
    body       "account" => recipient
  end
  
end
