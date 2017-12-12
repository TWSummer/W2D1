module Stepable
  def moves
    moves = []

    @diffs.each do |diff|
      new_pos = [@pos[0]+diff[0], @pos[1]+diff[1]]
      if @board.on_board?(new_pos) && (@color != @board[new_pos].color)
        moves << new_pos
      end
    end
    moves
  end

  def move_diffs

  end
end
