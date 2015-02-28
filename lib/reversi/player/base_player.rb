# coding: utf-8

module Reversi::Player
  class BasePlayer
    attr_reader :my_color, :opponent_color, :board

    def initialize(color, board)
      @my_color = color
      @opponent_color = @color == :white ? :black : :white
      @board = board
    end

    def move(board)
    end

    def put_disk(x, y, my_color = true)
      @board.push_stack
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @board.put_disk(x, y, my_color ? @my_color : @opponent_color)
      @board.flip_disks(x, y, my_color ? @my_color : @opponent_color)
    end

    # @return An array of next moves.
    def next_moves(my_color = true)
      @board.next_moves(my_color ? @my_color : @opponent_color)
    end

    def count_disks(my_color = true)
      @board.count_disks(my_color ? @my_color : @opponent_color)
    end
  end
end
