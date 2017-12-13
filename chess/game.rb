require_relative 'display'
require_relative 'player'

class Game

  def initialize(current_name, alt_name)
    @current = Player.new(current_name, :red)
    @alt = Player.new(alt_name, :black)
    @board = Board.new
    @board.populate
    @display = Display.new(@board)
  end

  def self.start_game
    puts "Player 1: What is your name?"
    name1 = gets.chomp
    puts "Player 2: What is your name?"
    name2 = gets.chomp
    Game.new(name1, name2).play
  end

  def play
    until won?
      @display.get_move(@current.color)
      switch_players!
    end

    @display.render
    puts "Game Over"
    puts "#{@alt.name} wins!"
  end

  private

  def switch_players!
    @current, @alt = @alt, @current
  end

  def won?
    @display.checkmate?(@current.color)
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.start_game
end
