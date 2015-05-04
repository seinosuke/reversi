module Reversi::Player
  class BasePlayer
    attr_reader :my_color, :opponent_color, :board

    # Initializes a new BasePlayer object.
    def initialize(color, board)
      @my_color = color
      @opponent_color = 
        @my_color == Reversi::Board::DISK[:white] ? 
        Reversi::Board::DISK[:black] : Reversi::Board::DISK[:white]
      @board = board
    end

    # Override this method in your original subclass.
    def move(board)
    end

    # Places a supplied color's disk on specified position,
    # and flips the opponent's disks.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param my_color [Boolean] my color or opponent's color
    def put_disk(x, y, my_color = true)
      @board.push_stack
      color = my_color ? @my_color : @opponent_color
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @board.flip_disks(x, y, color)
    end

    # Returns an array of the next moves.
    #
    # @param my_color [Boolean] my color or opponent's color
    # @return [Hash] the next moves
    def next_moves(my_color = true)
      color = my_color ? @my_color : @opponent_color
      @board.next_moves(color)
    end

    # Returns a number of the supplied color's disks.
    #
    # @param my_color [Boolean] my color or opponent's color
    # @return [Integer] a number of the supplied color's disks
    def count_disks(my_color = true)
      color = my_color ? @my_color : @opponent_color
      @board.count_disks(color)
    end

    # Returns a hash containing the coordinates of each color.
    #
    # @return [Hash{Symbol => Array<Symbol, Integer>}]
    def status
      convert = {
        :black => @my_color == Reversi::Board::DISK[:black] ? :mine : :opponent,
        :white => @my_color == Reversi::Board::DISK[:white] ? :mine : :opponent,
        :none  => :none }
      Hash[*@board.status.map{ |k, v| [convert[k], v] }.flatten(1)]
    end
  end
end
