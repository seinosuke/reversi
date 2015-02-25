# coding: utf-8

module Reversi::Player
  class BasePlayer
    attr_accessor :my_color, :opponent_color, :board

    def initialize(color, board)
      @my_color = color
      @opponent_color = @color == :white ? :black : :white
      @board = board
    end

    def move(board)
    end

    def put_my_disk(x, y)
      @board.push_stack
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @board.put_disk(x, y, @my_color)
      @board.flip_disks(x, y, @my_color)
    end

    def put_opponent_disk(x, y)
      @board.push_stack
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @board.put_disk(x, y, @opponent_color)
      @board.flip_disks(x, y, @opponent_color)
    end

    # @return An array of my next moves.
    def my_next_moves
      @board.next_moves(@my_color)
    end

    # @return An array of opponent's next moves.
    def opponent_next_moves
      @board.next_moves(@opponent_color)
    end

    def count_my_disks
      @board.count_disks(@my_color)
    end

    def count_opponent_disks
      @board.count_disks(@opponent_color)
    end
  end
end
