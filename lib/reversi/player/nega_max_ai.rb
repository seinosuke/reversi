module Reversi::Player
  class NegaMaxAI < BasePlayer

    def initialize(_color, _board)
      super

      point = [
        100, -10,  0, -1, -1,  0, -10, 100,
        -10, -30, -5, -5, -5, -5, -30, -10,
          0,  -5,  0, -1, -1,  0,  -5,   0,
         -1,  -5, -1, -1, -1, -1,  -5,  -1,
         -1,  -5, -1, -1, -1, -1,  -5,  -1,
          0,  -5,  0, -1, -1,  0,  -5,   0,
        -10, -30, -5, -5, -5, -5, -30, -10,
        100, -10,  0, -1, -1,  0, -10, 100
      ]
      @evaluation_value = 
        Hash[(1..8).map{ |x| (1..8).map{ |y| [[x, y], point.shift] } }.flatten(1) ]
    end

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
        status[:mine].inject(0){ |sum, xy| sum + @evaluation_value[xy] }
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
