Dir.glob('./{config,lib,services,views,forms,controllers}/init.rb').each do |file|
  require file
end

run MessengerApp
