require 'socket'

module Comm
  def self.build_message(game, piece_index)
    message = (game.to_repr << piece_index).flatten
    message.pack('C*')
  end

  def self.send_message(server, port, message, retry_count=0)
    begin
      s = TCPSocket.new(server, port)
      s.sendmsg(message)
      binary, _ = s.recvmsg
      s.close
      binary.unpack('C*')
    rescue
      if retry_count > 2
        raise $!
      else
        send_message(server, port, message, retry_count + 1)
      end
    end
  end
end
