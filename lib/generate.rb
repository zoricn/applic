module Generate
  def self.token(record)
    record.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless record.class.name.constantize.exists?(token: random_token)
    end
   end
end