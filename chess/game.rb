require_relative 'display'
require_relative 'player'
class Game
  def initialize(current_name, alt_name)
    @current = Player.new(current_name, :light_black)
    @alt = Player.new(alt_name, :black)
    @board = Board.new
    @board.populate
    @display = Display.new(@board)
  end

  def play
    until won?
      @display.get_move(@current.color)

      switch_players!
    end
    @display.render
    puts "Game over."
  end

  private

  def switch_players!
    @current, @alt = @alt, @current
  end

  def won?
    @display.checkmate?(@current.color)
  end

  def make_move(move)

    @board[move[0]], @board[move[1]] = NullPiece.instance, @board[move[0]]
    @board[move[0]].pos = move[0].dup
    @board[move[1]].pos = move[1].dup
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new("Edward", "Theo")
  game.play
end
