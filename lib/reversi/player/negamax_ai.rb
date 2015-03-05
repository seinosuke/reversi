module Reversi::Player
  class NegamaxAI < BasePlayer

    POINT = {
      [:a, 1] => 100, [:b, 1] => -10, [:c, 1] =>  0, [:d, 1] => -1, [:e, 1] => -1, [:f, 1] =>  0, [:g, 1] => -10, [:h, 1] => 100,
      [:a, 2] => -10, [:b, 2] => -30, [:c, 2] => -5, [:d, 2] => -5, [:e, 2] => -5, [:f, 2] => -5, [:g, 2] => -30, [:h, 2] => -10,
      [:a, 3] =>   0, [:b, 3] =>  -5, [:c, 3] =>  0, [:d, 3] => -1, [:e, 3] => -1, [:f, 3] =>  0, [:g, 3] =>  -5, [:h, 3] =>   0,
      [:a, 4] =>  -1, [:b, 4] =>  -5, [:c, 4] => -1, [:d, 4] => -1, [:e, 4] => -1, [:f, 4] => -1, [:g, 4] =>  -5, [:h, 4] =>  -1,
      [:a, 5] =>  -1, [:b, 5] =>  -5, [:c, 5] => -1, [:d, 5] => -1, [:e, 5] => -1, [:f, 5] => -1, [:g, 5] =>  -5, [:h, 5] =>  -1,
      [:a, 6] =>   0, [:b, 6] =>  -5, [:c, 6] =>  0, [:d, 6] => -1, [:e, 6] => -1, [:f, 6] =>  0, [:g, 6] =>  -5, [:h, 6] =>   0,
      [:a, 7] => -10, [:b, 7] => -30, [:c, 7] => -5, [:d, 7] => -5, [:e, 7] => -5, [:f, 7] => -5, [:g, 7] => -30, [:h, 7] => -10,
      [:a, 8] => 100, [:b, 8] => -10, [:c, 8] =>  0, [:d, 8] => -1, [:e, 8] => -1, [:f, 8] =>  0, [:g, 8] => -12, [:h, 8] => 100
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
