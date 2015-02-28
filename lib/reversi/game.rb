# coding: utf-8

module Reversi
  class Game
    attr_accessor *Configuration::OPTIONS_KEYS
    attr_accessor :board, :vs_human, :status

    def initialize(options = {})
      Reversi.set_defaults
      options = Reversi.options.merge(options)
      Configuration::OPTIONS_KEYS.each do |key|
        send("#{key}=".to_sym, options[key])
      end

      if @player_b == Reversi::Player::Human || @player_w == Reversi::Player::Human
        @vs_human = true
        @progress = false
      end
      @vs_human ||= false
      @board = Board.new(options)
      @player_b = @player_b.new(:black, @board)
      @player_w = @player_w.new(:white, @board)
    end

    def start
      options = {:progress => @progress, :vs_human => @vs_human}
      run(options)
    end

    def run(options)
      show_board if options[:progress]
      loop do
        break if game_over?
        update_status
        @player_b.move(@board); check_move(:black)
        show_board if options[:progress]

        update_status
        @player_w.move(@board); check_move(:white)
        show_board if options[:progress]
      end
      puts @board.to_s if options[:progress] || options[:vs_human]
    end

    private

    def update_status
      @status = {
        :none  => @board.count_disks(:none),
        :black => @board.count_disks(:black),
        :white => @board.count_disks(:white)
      }
    end

    # Show the current status of this game board.
    def show_board
      puts @board.to_s
      printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
    end

    # Checks a move to make sure it is valid.
    def check_move(color)
      blank_diff = @status[:none] - @board.count_disks(:none)
      case blank_diff
      when 1
        if (@board.count_disks(color) - @status[color]) < 2
          raise MoveError, "A player must flip at least one or more opponent disks."
        end
      when 0
        unless (@board.count_disks(:black) - @status[:black]) == 0 &&
               (@board.count_disks(:white) - @status[:white]) == 0
          raise MoveError, "When a player can't make a valid move, you must not place a new disk."
        end
      else raise MoveError, "A player must place a new disk on the board."
      end
    end

    # Whether or not this game is over.
    # Both players can't find a next move, that's the end of the game.
    def game_over?
      @player_w.my_next_moves.empty? && @player_b.my_next_moves.empty?
    end
  end
end
