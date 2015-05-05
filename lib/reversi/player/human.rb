module Reversi::Player
  class Human < BasePlayer

    def initialize(color, _board)
      super

      case color
      when Reversi::Board::DISK[:black] then @color = :black
      when Reversi::Board::DISK[:white] then @color = :white
      end
    end

    def move(board)
      return if next_moves.empty?
      puts board.to_s
      input_move
      printf "\e[#{18}A"; STDOUT.flush
      puts board.to_s; sleep 0.5
      printf "\e[#{18}A"; STDOUT.flush
    end

    private

    def input_move
      loop do
        print "#{@color}: "
        @input_move = gets.chomp.split("")
        exit if [['q'], ['e','x','i','t']].include? @input_move
        redo if check_size == :redo
        @input_move[0] = [*:a..:h].index(@input_move[0].to_sym) + 1
        @input_move[1] = @input_move[1].to_i
        printf "\e[#{1}A"; STDOUT.flush
        print "#{" "*9}"
        printf "\e[#{9}D"; STDOUT.flush
        redo if check_valid == :redo
        put_disk(*@input_move)
        break
      end
    end

    def check_size
      unless @input_move.size == 2
        printf "\e[#{1}A"; STDOUT.flush
        print "#{" "*(@input_move.join.size + 7)}"
        printf "\e[#{@input_move.join.size + 7}D"; STDOUT.flush
        return :redo
      end
      :valid
    end

    def check_valid
      unless next_moves.include?(@input_move)
        return :redo
      end
      :valid
    end
  end
end
