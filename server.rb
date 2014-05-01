load 'requirements.rb'
window = GameWindow.new

require 'socket'                # Get sockets from stdlib
server = TCPServer.open(Constants::PORT)   # Socket to listen on port 2000
window.client = server.accept

window.show
