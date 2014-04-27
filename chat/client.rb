require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000
s = TCPSocket.open(hostname, port)
Thread.new do
  while (line = gets) != "q\n"
    s.puts line
  end
  s.close
end

while line = s.gets
  puts line
end
