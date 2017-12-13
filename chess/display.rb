require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0],board)
  end

  def get_move(color)
    @possible_moves = get_first_pos(color)
    @possible_moves << @first_pos
    get_sec_pos(color)
    test_move(color)
  end

  def make_move(move)
    @board[move[0]], @board[move[1]] = NullPiece.instance, @board[move[0]]
    @board[move[0]].pos = move[0].dup
    @board[move[1]].pos = move[1].dup
  end

  def render(color=nil)
    system("clear")
    @board.board.each.with_index do |row, rowidx|
      row.each.with_index do |piece, colidx|
        render_piece(piece.to_s, [rowidx,colidx])
      end
      puts
    end
    puts "#{color.to_s.capitalize} make move" unless color.nil?
    nil
  end

  def checkmate?(color)
    checkmate = false
    checkmate = any_moves?(color) if in_check?(color)
    checkmate
  end

  private

  def any_moves?(color)
    all_pieces_pos = find_my_pieces(color)
    all_my_moves = []
    all_pieces_pos.each do |pos|
      @board[pos].valid_moves.each do |end_move|
        all_my_moves << [pos, end_move]
      end
    end
    all_my_moves = all_my_moves.reject do |pair_pos|
      test_check?(pair_pos, color)
    end
    all_my_moves.empty?
  end

  def test_move(color)
    if @first_pos == @sec_pos
      return get_move(color)
    else
      return revert_if_check(color)
    end
    nil
  end

  def revert_if_check(color)
    first_piece = @board[@first_pos]
    second_piece = @board[@sec_pos]
    make_move([@first_pos,@sec_pos])
    if in_check?(color)
      @board[@first_pos] = first_piece
      @board[@sec_pos] = second_piece
      return get_move(color)
    end
  end

  def test_check?(move, color)
    first_piece = @board[move[0]]
    second_piece = @board[move[1]]
    make_move(move)
    check_status = in_check?(color)
    @board[move[0]] = first_piece
    @board[move[1]] = second_piece
    check_status
  end

  def find_my_pieces(color)
    my_positions = []
    @board.board.each.with_index do |row, rowidx|
      row.each.with_index do |piece, colidx|
        if @board[[rowidx, colidx]].color == color
          my_positions << [rowidx, colidx]
        end
      end
    end
    my_positions
  end

  def in_check?(color)
    king_position = find_king(color)
    opponent_positions = find_other_pieces(color)
    all_opponent_moves = []
    opponent_positions.each do |pos|
      all_opponent_moves.concat(@board[pos].valid_moves)
    end
    all_opponent_moves.include?(king_position)
  end

  def find_king(color)
    @board.board.each.with_index do |row, rowidx|
      row.each.with_index do |piece, colidx|
        if @board[[rowidx, colidx]].to_s == "♔ " && @board[[rowidx, colidx]].color == color
          return [rowidx, colidx]
        end
      end
    end
    nil
  end

  def find_other_pieces(color)
    other_positions = []
    @board.board.each.with_index do |row, rowidx|
      row.each.with_index do |piece, colidx|
        unless @board[[rowidx, colidx]].color == color || @board[[rowidx, colidx]].is_a?(NullPiece)
          other_positions << [rowidx, colidx]
        end
      end
    end
    other_positions
  end

  def get_first_pos(color)
    possible_moves = []
    while possible_moves.empty?
      @first_pos = nil

      while @first_pos.nil?
        render(color)
        @first_pos = @cursor.get_input
        unless @first_pos.nil?
          @first_pos = nil unless @board[@first_pos].color == color
        end
      end
      @first_pos = @first_pos.dup
      possible_moves = @board[@first_pos].valid_moves
    end
    possible_moves
  end

  def get_sec_pos(color)
    @sec_pos = nil
    until @possible_moves.include?(@sec_pos)
      render(color)
      @sec_pos = @cursor.get_input
    end
  end

  def render_piece(string, pos)
    sum = pos.reduce(:+)
    background = sum.even? ? :white : :light_white
    color = @board[pos].color
    if pos == @cursor.cursor_pos
      print string.colorize(:color => color, :background => :light_yellow)
    elsif pos == @first_pos
      print string.colorize(:color => color, :background => :yellow)
    else
      print string.colorize(:color => color, :background => background)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.populate
  display = Display.new(board)
  display.play
end
