module Reversi::Player
  class NegamaxAI < Reversi::Player::BasePlayer

    POINT = {
      [:a, 1] =>  30, [:b, 1] => -12, [:c, 1] =>  0, [:d, 1] => -1, [:e, 1] => -1, [:f, 1] =>  0, [:g, 1] => -12, [:h, 1] =>  30,
      [:a, 2] => -12, [:b, 2] => -15, [:c, 2] => -3, [:d, 2] => -3, [:e, 2] => -3, [:f, 2] => -3, [:g, 2] => -15, [:h, 2] => -12,
      [:a, 3] =>   0, [:b, 3] =>  -3, [:c, 3] =>  0, [:d, 3] => -1, [:e, 3] => -1, [:f, 3] =>  0, [:g, 3] =>  -3, [:h, 3] =>   0,
      [:a, 4] =>  -1, [:b, 4] =>  -3, [:c, 4] => -1, [:d, 4] => -1, [:e, 4] => -1, [:f, 4] => -1, [:g, 4] =>  -3, [:h, 4] =>  -1,
      [:a, 5] =>  -1, [:b, 5] =>  -3, [:c, 5] => -1, [:d, 5] => -1, [:e, 5] => -1, [:f, 5] => -1, [:g, 5] =>  -3, [:h, 5] =>  -1,
      [:a, 6] =>   0, [:b, 6] =>  -3, [:c, 6] =>  0, [:d, 6] => -1, [:e, 6] => -1, [:f, 6] =>  0, [:g, 6] =>  -3, [:h, 6] =>   0,
      [:a, 7] => -12, [:b, 7] => -15, [:c, 7] => -3, [:d, 7] => -3, [:e, 7] => -3, [:f, 7] => -3, [:g, 7] => -15, [:h, 7] => -12,
      [:a, 8] =>  30, [:b, 8] => -12, [:c, 8] =>  0, [:d, 8] => -1, [:e, 8] => -1, [:f, 8] =>  0, [:g, 8] => -12, [:h, 8] =>  30
    }.freeze

    def move(board)
      moves = next_moves.map{ |v| v[:move] }
      return if moves.empty?

      next_move = moves.map do |move|
        { :move => move, :point => evaluate(move, board, 1, true) }
      end
      .max_by{ |v| v[:point] }[:move]
      put_disk(*next_move)
    end

    def evaluate(move, board, depth, color)
      put_disk(*move, color)
      moves = next_moves(!color).map{ |v| v[:move] }

      if depth == 3
        status[:mine].inject(0){ |sum, xy| sum + POINT[xy] }
      elsif moves.empty?
        -100
      else
        -( moves.map{ |move| evaluate(move, board, depth + 1, !color) }.max )
      end

    ensure
      board.undo!
    end
  end
end
