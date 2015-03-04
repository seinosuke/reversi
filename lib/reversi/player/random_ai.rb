module Reversi::Player
  class RandomAI < BasePlayer

    def move(board)
      moves = next_moves.map{ |v| v[:move] }
      put_disk(*moves.sample) unless moves.empty?
    end
  end
end
