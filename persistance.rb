class Room
  attr_reader :key
  attr_accessor :game, :selected_piece, :won

  def initialize(key)
    @key  = key
    @game = Game.new
    @won  = false
  end

  def apply_move(move)
    @game.apply_move(selected_piece, move)
    self.selected_piece = move.piece_index
  end
end

class Building < Hash
  def create_room
    key = generate_key
    self[key] = Room.new(key)
  end

private

  def generate_key
    rand(36**10).to_s(36)
  end
end
