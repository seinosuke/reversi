module Reversi
  class Game
    attr_accessor *Configuration::OPTIONS_KEYS
    attr_reader :options, :board, :vs_human, :status

    # Initializes a new Board object.
    def initialize(options = {})
      reset(options)
    end

    # Set the option values and start a game.
    #
    # @see #run
    def start(options = {})
      reset(options)
      mode = {:progress => @progress, :vs_human => @vs_human}
      run(mode)
    end

    private

    # Reset the instance variable, `@board`.
    def reset(options = {})
      load_config(options)
      @board = Board.new(@options)
      @player_class_b = @player_b
      @player_class_w = @player_w
      @player_b = @player_class_b.new(:black, @board)
      @player_w = @player_class_w.new(:white, @board)
    end

    # Load the configuration.
    def load_config(options = {})
      Reversi.set_defaults
      @options = Reversi.options.merge(options)
      Configuration::OPTIONS_KEYS.each do |key|
        send("#{key}=".to_sym, @options[key])
      end

      if [@player_b, @player_w].include? Reversi::Player::Human
        @vs_human = true
        @progress = false
      end
      @vs_human ||= false
    end

    # Execute a game and run until the end of the game.
    #
    # @option mode [Boolean] :progress Display the progress of the game.
    # @option mode [Boolean] :vs_human 
    def run(mode = {})
      show_board if mode[:progress]
      loop do
        break if game_over?
        @status = @board.status
        @player_b.move(@board); check_move(:black)
        show_board if mode[:progress]

        @status = @board.status
        @player_w.move(@board); check_move(:white)
        show_board if mode[:progress]
      end
      puts @board.to_s if mode[:progress] || mode[:vs_human]
    rescue Interrupt
      exit 1
    end

    # Show the current state of this game board.
    def show_board
      puts @board.to_s
      printf "\e[#{18}A"; STDOUT.flush; sleep 0.1
    end

    # Checks a move to make sure it is valid.
    def check_move(color)
      blank_diff = @status[:none].size - @board.count_disks(:none)

      case blank_diff
      when 1
        if (@board.count_disks(color) - @status[color].size) < 2
          raise MoveError, "A player must flip at least one or more opponent's disks."
        end
      when 0
        unless (@board.count_disks(:black) - @status[:black].size) == 0 &&
               (@board.count_disks(:white) - @status[:white].size) == 0
          raise MoveError, "When a player can't make a valid move, you must not place a new disk."
        end
      else
        raise MoveError, "A player must place a new disk on the board."
      end
    end

    # Whether or not this game is over.
    # Both players can't find a next move, that's the end of the game.
    def game_over?
      @player_w.next_moves.empty? && @player_b.next_moves.empty?
    end
  end
end
