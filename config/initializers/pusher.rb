Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.host   = 'api-ap2.pusher.com'
Pusher.port   = ENV['PUSHER_PORT'].present? ? ENV['PUSHER_PORT'].to_i : 80
