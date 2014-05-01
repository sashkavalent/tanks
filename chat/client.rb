require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000
socket = TCPSocket.open(hostname, port)
Thread.new do
  while (line = gets) != "q\n"
    socket.puts line
  end
  socket.close
end

while line = socket.gets
  puts line
end
