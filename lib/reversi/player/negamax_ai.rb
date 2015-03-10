module Reversi::Player
  class NegamaxAI < BasePlayer

    POINT = {
      [1, 1] => 100, [2, 1] => -10, [3, 1] =>  0, [4, 1] => -1, [5, 1] => -1, [6, 1] =>  0, [7, 1] => -10, [8, 1] => 100,
      [1, 2] => -10, [2, 2] => -30, [3, 2] => -5, [4, 2] => -5, [5, 2] => -5, [6, 2] => -5, [7, 2] => -30, [8, 2] => -10,
      [1, 3] =>   0, [2, 3] =>  -5, [3, 3] =>  0, [4, 3] => -1, [5, 3] => -1, [6, 3] =>  0, [7, 3] =>  -5, [8, 3] =>   0,
      [1, 4] =>  -1, [2, 4] =>  -5, [3, 4] => -1, [4, 4] => -1, [5, 4] => -1, [6, 4] => -1, [7, 4] =>  -5, [8, 4] =>  -1,
      [1, 5] =>  -1, [2, 5] =>  -5, [3, 5] => -1, [4, 5] => -1, [5, 5] => -1, [6, 5] => -1, [7, 5] =>  -5, [8, 5] =>  -1,
      [1, 6] =>   0, [2, 6] =>  -5, [3, 6] =>  0, [4, 6] => -1, [5, 6] => -1, [6, 6] =>  0, [7, 6] =>  -5, [8, 6] =>   0,
      [1, 7] => -10, [2, 7] => -30, [3, 7] => -5, [4, 7] => -5, [5, 7] => -5, [6, 7] => -5, [7, 7] => -30, [8, 7] => -10,
      [1, 8] => 100, [2, 8] => -10, [3, 8] =>  0, [4, 8] => -1, [5, 8] => -1, [6, 8] =>  0, [7, 8] => -12, [8, 8] => 100
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
