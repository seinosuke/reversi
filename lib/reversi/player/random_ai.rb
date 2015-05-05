module Reversi::Player
  class RandomAI < BasePlayer

    def move(board)
      moves = next_moves
      put_disk(*moves.sample) unless moves.empty?
    end
  end
end
