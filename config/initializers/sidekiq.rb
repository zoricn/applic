#Clear Redis queue if app restarts in development mode
if Rails.env.development?
	require 'sidekiq/api'
	Sidekiq::Queue.new.clear
  puts "Sidekiq queue cleared"
end