class Piece
  def initialize(int)
    @repr = int
  end

  def image_name
    return 'empty' if empty?
    (@repr & 1 > 0 ? 't' : 's') <<
    (@repr & 4 > 0 ? 'b' : 'r') <<
    (@repr & 64 > 0 ? 'f' : 's') <<
    (@repr & 16 > 0 ? 'r' : 's')
  end

  def to_repr
    @repr
  end

  def empty?
    @repr == 0
  end

  def self.empty
    @empty_piece ||= Piece.new(0)
  end
end

class Board
  def initialize()
    @repr = Array.new(4) { Array.new(4, Piece.empty) }
  end

  def get(i, j)
    @repr[i][j]
  end

  def set(i, j, piece)
    @repr[i][j] = piece
  end

  def to_repr
    @repr.map { |line| line.map { |piece| piece.to_repr }  }
  end
end

class Stash < Array
  def initialize
    # Just don't ask where this come from...
    repr  = [85, 149, 101, 165, 89, 153, 105, 169,
             86, 150, 102, 166, 90, 154, 106, 170]
    repr.each { |int| self << Piece.new(int) }
  end

  def to_repr
    map { |piece| piece.to_repr }
  end

  def delete_at(index)
    piece = self[index]
    self[index] = Piece.empty
    piece
  end
end

class Move
  attr_reader :i, :j, :piece_index

  def initialize(i, j, piece_index)
    @i, @j, @piece_index = i, j, piece_index
  end

  def to_repr
    [@i, @j, @piece_index]
  end
end

class Game
  attr_reader :board, :stash

  def initialize
    @board = Board.new
    @stash = Stash.new
  end

  def apply_move(piece_index, move)
    piece = @stash.delete_at(piece_index)
    @board.set(move.i, move.j, piece)
  end

  def to_repr
    @board.to_repr + @stash.to_repr
  end
end
