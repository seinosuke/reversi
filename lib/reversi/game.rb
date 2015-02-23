# coding: utf-8

module Reversi
  class Game
    attr_accessor *Configuration::OPTIONS_KEYS
    attr_accessor :board

    def initialize(options = {})
      Reversi.set_defaults
      options = Reversi.options.merge(options)

      Configuration::OPTIONS_KEYS.each do |key|
        send("#{key}=".to_sym, options[key])
      end

      @board = Board.new(options)
      @player_b = @player_b.new(:black, @board)
      @player_w = @player_w.new(:white, @board)
    end

    def before
      @board.put_disk(:d, 4, :black)
      @board.put_disk(:e, 5, :black)
      @board.put_disk(:f, 5, :white)
      puts @board.to_s
    end

    def start
      puts @board.to_s
      printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
      loop do
        break if game_over?
        @player_b.move
        puts @board.to_s
        printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
        @player_w.move
        puts @board.to_s
        printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
      end
      puts @board.to_s
      puts "black " << @player_b.count_disks.to_s
      puts "white " << @player_w.count_disks.to_s
    end

    private

    def game_over?
      @player_w.next_moves.empty? && @player_b.next_moves.empty?
    end
  end
end
