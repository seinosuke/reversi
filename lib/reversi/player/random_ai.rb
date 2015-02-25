# coding: utf-8

module Reversi::Player
  class RandomAI < BasePlayer

    def move(board)
      put_my_disk(*my_next_moves.sample) unless my_next_moves.empty?
    end
  end
end
