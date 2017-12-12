require 'byebug'
module Slideable

  def moves
    horizontal_moves = []
    diagonal_moves = []
    horizontal_moves = horizontal_dir if @horizontal
    diagonal_moves = diagonal_dir if @diagonal
    horizontal_moves.concat(diagonal_moves)
  end

  private

  def move_dir
  end

  def horizontal_dir
    right = grow_unblocked_moves_in_dir(0,1)
    left = grow_unblocked_moves_in_dir(0,-1)
    up = grow_unblocked_moves_in_dir(-1,0)
    down = grow_unblocked_moves_in_dir(1,0)
    right + left + up + down
  end

  def diagonal_dir
    up_left = grow_unblocked_moves_in_dir(-1, -1)
    up_right = grow_unblocked_moves_in_dir(-1, 1)
    down_left = grow_unblocked_moves_in_dir(1, -1)
    down_right = grow_unblocked_moves_in_dir(1, 1)
    up_left + up_right + down_left + down_right
  end

  def grow_unblocked_moves_in_dir(x,y)
    row, col = @pos
    moves = []
    row += x
    col += y
    while @board.on_board?([row, col]) && @board[[row, col]].is_a?(NullPiece)
      moves << [row, col]
      row += x
      col += y
    end
    if @board.on_board?([row, col]) && @board[[row,col]].color != @color
      moves << [row, col]
    end
    moves
  end

end
