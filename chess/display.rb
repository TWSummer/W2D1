require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0],board)
  end

  def play
    while true
      render
      @cursor.get_input
    end
  end

  def get_move
    @possible_moves = get_first_pos
    @possible_moves << @first_pos
    get_sec_pos
    if @first_pos == @sec_pos
      get_move
    else
      [@first_pos,@sec_pos.dup]
    end
  end


  def render
    system("clear")
    @board.board.each.with_index do |row, rowidx|
      row.each.with_index do |piece, colidx|
        render_piece(piece.to_s, [rowidx,colidx])
      end
      puts
    end
    nil
  end

  private

  def get_first_pos
    possible_moves = []
    while possible_moves.empty?
      @first_pos = nil

      while @first_pos.nil?
        render
        @first_pos = @cursor.get_input
      end
      @first_pos = @first_pos.dup
      possible_moves = @board[@first_pos].valid_moves
    end
    possible_moves
  end

  def get_sec_pos
    @sec_pos = nil
    until @possible_moves.include?(@sec_pos)
      render
      @sec_pos = @cursor.get_input
    end
  end

  def render_piece(string, pos)
    color = @board[pos].color
    if pos == @cursor.cursor_pos
      print string.colorize(:color => color, :background => :red)
    elsif pos == @first_pos
      print string.colorize(:color => color, :background => :yellow)
    else
      print string.colorize(color)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.populate
  display = Display.new(board)
  display.play
end
