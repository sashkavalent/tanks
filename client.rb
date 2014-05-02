load 'requirements.rb'
require 'socket'

window = GameWindow.new
begin
  window.server = TCPSocket.open(ARGV.first || Constants::HOSTNAME, Constants::PORT)
rescue Errno::ECONNREFUSED => e
  sleep 1
  retry
end

window.show
