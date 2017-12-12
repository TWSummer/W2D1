require_relative 'module_sliding'
require_relative 'module_stepping'
require 'singleton'

class Piece
  attr_reader :color, :position
  def initialize(board, position, color)
    @board = board
    @pos = position
    @color = color
  end

  def to_s
    "x"
  end

  def valid_moves
    possible_moves
  end


end

class NullPiece < Piece
  include Singleton
  def initialize
    @color = :red
  end

  def to_s
    " "
  end

  def possible_moves
    []
  end
end

class SlidingPiece < Piece
  include Slideable
  def initialize(board, position, color)
    super(board, position, color)
  end

  def possible_moves
    moves
  end
end

class Bishop < SlidingPiece
  include Slideable
  def initialize(board, position, color)
    @diagonal = true
    @horizontal = false
    super(board, position, color)
  end

  def to_s
    "B"
  end

end

class Rook < SlidingPiece
  include Slideable
  def initialize(board, position, color)
    @diagonal = false
    @horizontal = true
    super(board, position, color)
  end

  def to_s
    "R"
  end

end

class Queen < SlidingPiece
  include Slideable
  def initialize(board, position, color)
    @diagonal = true
    @horizontal = true
    super(board, position, color)
  end

  def to_s
    "Q"
  end

end

class SteppingPiece < Piece
  include Stepable
  def initialize(board, position, color)
    super(board, position, color)
  end

  def possible_moves
    moves
  end
end

class Knight < SteppingPiece
  def initialize(board, position, color)
    @diffs = [[1,2],[-1,2],[2,1],[-2,1],[2,-1],[-2,-1],[1,-2],[-1,-2]]
    super(board, position, color)
  end

  def to_s
    "K"
  end

end

class King < SteppingPiece
  def initialize(board, position, color)
    @diffs = [[1,0],[-1,1],[1,1],[-1,0],[1,-1],[-1,-1],[0,-1],[0,1]]
    super(board, position, color)
  end

  def to_s
    "O"
  end

end

class Pawn < Piece
  def initialize(board, position, color)
    @start_row = position[0]
    @direction = @start_row == 1 ? 1 : -1
    super(board, position, color)
  end

  def to_s
    "X"
  end 
end
