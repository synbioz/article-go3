require 'socket'
require 'benchmark'

module Comm
  def self.build_message(game, piece_index)
    message = (game.to_repr << piece_index).flatten
    message.pack('C*')
  end

  def self.send_message(server, port, message, retry_count=0)
    begin
      binary = ""
      bm = Benchmark.measure do
        s = TCPSocket.new(server, port)
        s.sendmsg(message)
        binary, _ = s.recvmsg
        s.close
      end
      bm.to_s =~ /\(\s*(\d+\.\d+)\)/
      bm = ($1.to_f * 1000).round(3)
      [binary.unpack('C*'), bm]
    rescue
      if retry_count > 2
        raise $!
      else
        send_message(server, port, message, retry_count + 1)
      end
    end
  end
end
