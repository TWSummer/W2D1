require_relative 'display'

class Game
  def initialize
    @board = Board.new
    @board.populate
    @display = Display.new(@board)

  end

  def play
    until won?
      move = @display.get_move
      make_move(move)

    end
  end

  private

  def won?
    return false
  end

  def make_move(move)

    @board[move[0]], @board[move[1]] = @board[move[1]], @board[move[0]]
    @board[move[0]].pos = move[0].dup
    @board[move[1]].pos = move[1].dup
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
