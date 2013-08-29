require 'socket'

module Comm
  def self.build_message(game, piece_index)
    game_repr  = game.to_repr
    numbers = [game_repr['Board'], game_repr['Stash'], piece_index].flatten
    numbers.pack('C*')
  end

  def self.send_message(server, port, message)
    s = TCPSocket.new(server, port)
    s.sendmsg(message)
    binary, _ = s.recvmsg
    s.close
    binary.unpack('C*')
  end
end
