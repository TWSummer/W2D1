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
      @board[move[0]], @board[move[1]] = @board[move[1]], @board[move[0]]
    end
  end

  def won?
    return false
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
