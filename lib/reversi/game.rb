# coding: utf-8

module Reversi
  class Game
    attr_accessor *Configuration::OPTIONS_KEYS
    attr_accessor :board, :black_disks, :white_disks, :vs_human

    def initialize(options = {})
      Reversi.set_defaults
      options = Reversi.options.merge(options)
      Configuration::OPTIONS_KEYS.each do |key|
        send("#{key}=".to_sym, options[key])
      end

      if @player_b == Reversi::Player::Human || @player_w == Reversi::Player::Human
        @vs_human = true
        @display_progress = false
      end
      @vs_human ||= false
      @board = Board.new(options)
      @player_b = @player_b.new(:black, @board)
      @player_w = @player_w.new(:white, @board)
    end

    def start
      @display_progress ? run_with_progress : run
    end

    def run
      loop do
        break if game_over?
        @black_disks = [@board.count_disks(:none), @player_b.count_my_disks]
        @player_b.move(@board)
        check_move_b

        @white_disks = [@board.count_disks(:none), @player_w.count_my_disks]
        @player_w.move(@board)
        check_move_w
      end
      puts @board.to_s if @vs_human
    end

    def run_with_progress
      puts @board.to_s
      printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
      loop do
        break if game_over?
        @black_disks = [@board.count_disks(:none), @player_b.count_my_disks]
        @player_b.move(@board)
        check_move_b
        puts @board.to_s
        printf "\e[#{18}A"; STDOUT.flush; sleep 0.1

        @white_disks = [@board.count_disks(:none), @player_w.count_my_disks]
        @player_w.move(@board)
        check_move_w
        puts @board.to_s
        printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
      end
      puts @board.to_s
    end

    private

    # Checks player_b's move to make sure it is valid.
    def check_move_b
      blank_diff = @black_disks[0] - @board.count_disks(:none)
      unless [0, 1].include?(blank_diff)
        raise MoveError, "a player must place a new piece on the board"
      end
      if blank_diff == 1 && (@player_b.count_my_disks - @black_disks[1]) < 2
        raise MoveError, "a player must flip at least one or more opponent disks"
      end
    end

    # Checks player_w's move to make sure it is valid.
    def check_move_w
      blank_diff = @white_disks[0] - @board.count_disks(:none)
      unless [0, 1].include?(blank_diff)
        raise MoveError, "a player must place a new piece on the board"
      end
      if blank_diff == 1 && (@player_w.count_my_disks - @white_disks[1]) < 2
        raise MoveError, "a player must flip at least one or more opponent disks"
      end
    end

    # Whether or not this game is over.
    # Both players can't find a next move, that's the end of the game.
    def game_over?
      @player_w.my_next_moves.empty? && @player_b.my_next_moves.empty?
    end
  end
end
