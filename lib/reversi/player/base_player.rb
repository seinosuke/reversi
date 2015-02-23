# coding: utf-8

module Reversi::Player
  class BasePlayer
    attr_accessor :color, :board

    def initialize(color, board)
      @color = color
      @board = board
    end

    def put_disk(x, y)
      @board.push_stack
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @board.put_disk(x, y, @color)
      @board.flip_disks(x, y, @color)
    end

    def move
    end

    def next_moves
      @board.next_moves(@color)
    end

    def count_disks
      @board.count_disks(@color)
    end
  end
end
