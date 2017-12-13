require_relative 'piece'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
  end

  def populate
    @board.each.with_index do |row,rowidx|
      row.each_index do |colidx|
        if rowidx >= 2 && rowidx <= 5
          @board[rowidx][colidx] = NullPiece.instance
        elsif rowidx == 0
          @board[rowidx] = end_row(rowidx, :black)
        elsif rowidx == 1
          @board[rowidx][colidx] = Pawn.new(self, [rowidx, colidx], :black)
        elsif rowidx == 7
          @board[rowidx] = end_row(rowidx, :red)
        elsif rowidx == 6
          @board[rowidx][colidx] = Pawn.new(self, [rowidx, colidx], :red)
        end
      end
    end
  end

  def [](position)
    row,col = position
    @board[row][col]
  end

  def []=(position, value)
    row,col = position
    @board[row][col] = value
  end

  def on_board?(pos)
    row, col = pos
    row >= 0 && row <= 7 && col >= 0 && col <= 7
  end

  private

  def end_row(row, color)
    pieces = []
    pieces << Rook.new(self, [row, 0], color)
    pieces << Knight.new(self, [row, 1], color)
    pieces << Bishop.new(self, [row, 2], color)
    pieces << Queen.new(self, [row, 3], color)
    pieces << King.new(self, [row, 4], color)
    pieces << Bishop.new(self, [row, 5], color)
    pieces << Knight.new(self, [row, 6], color)
    pieces << Rook.new(self, [row, 7], color)
  end

end
