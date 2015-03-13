module Reversi::Player
  class AlphaBetaAI < BasePlayer

    N = 10000.freeze

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
      alpha = -N; beta = N
      next_move = moves.map do |move|
        { :move => move, :point => evaluate(move, board, alpha, beta, 3, true) }
      end
      .max_by{ |v| v[:point] }[:move]
      put_disk(*next_move)
    end

    def evaluate(move, board, alpha, beta, depth, color)
      put_disk(*move, color)
      moves = next_moves(!color).map{ |v| v[:move] }

      if depth == 1
        status[:mine].inject(0){ |sum, xy| sum + @evaluation_value[xy] }

      elsif moves.empty?
        case depth
        when ->(n){ n.odd? }  then alpha
        when ->(n){ n.even? } then beta end

      else
        case depth
        when ->(n){ n.odd? }
          beta = N
          moves.each do |move|
            val = evaluate(move, board, alpha, beta, depth - 1, !color)
            beta = val if val < beta
            return alpha if alpha > beta
          end
          beta
        when ->(n){ n.even? }
          alpha = -N
          moves.each do |move|
            val = evaluate(move, board, alpha, beta, depth - 1, !color)
            alpha = val if val > alpha
            return beta if alpha > beta
          end
          alpha
        end
      end

    ensure
      board.undo!
    end
  end
end
