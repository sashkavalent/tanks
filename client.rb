load 'requirements.rb'

begin
  server = TCPSocket.open(ARGV.first || Constants::HOSTNAME, Constants::PORT)
rescue Errno::ECONNREFUSED => e
  # sleep 1
  retry
end
window = GameWindow.new(server, nil)

window.show
