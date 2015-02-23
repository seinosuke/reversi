# coding: utf-8

module Reversi::Player
  class RandomAI < BasePlayer

    def move
      put_disk(*next_moves.sample) unless next_moves.empty?
    end
  end
end
