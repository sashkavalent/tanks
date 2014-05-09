load 'requirements.rb'

server = TCPServer.open(Constants::PORT)
window = GameWindow.new(nil, server.accept)

sleep 0.5

window.show
