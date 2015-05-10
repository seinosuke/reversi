module Reversi
  class Board
    attr_reader :options, :stack

    DISK = {
      :none  =>  0,
      :black => -1,
      :white =>  1
    }.freeze

    DISK_COLOR = {
      :black   => 30,
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenda => 35,
      :cyan    => 36,
      :white   => 37,
      :gray    => 90
    }.freeze

    # Initializes a new Board object.
    #
    # @see Reversi::Game
    # @see Reversi::Configration
    # @return [Reversi::Board]
    def initialize(options = {})
      @options = options
      @stack = []
      board_initialize

      [:disk_color_b, :disk_color_w].each do |color|
        if @options[color].is_a?(Symbol) || @options[color].is_a?(String)
          @options[color] = DISK_COLOR[@options[color].to_sym].to_i
        end
      end

      @options[:initial_position].each do |color, positions|
        positions.each{ |position| put_disk(*position, DISK[color]) }
      end

      if @options[:disk_b].size != 1 || @options[:disk_w].size != 1
        raise OptionError, "The length of the disk string must be one."
      end
    end

    # Returns a string of the game board in human-readable form.
    #
    # @return [String]
    def to_s
      "     #{[*'a'..'h'].join("   ")}\n" <<
      "   #{"+---"*8}+\n" <<
      (0..63).map do |i|
        case 1
        when black_getter[63 - i] then "\e[#{@options[:disk_color_b]}m#{@options[:disk_b]}\e[0m"
        when white_getter[63 - i] then "\e[#{@options[:disk_color_w]}m#{@options[:disk_w]}\e[0m"
        else " "
        end
      end
      .map{ |e| "| #{e} |" }.each_slice(8).map(&:join)
      .map{ |line| line.gsub(/\|\|/, "|") }
      .tap{ |lines| break (0..7).map{ |i| " #{i+1} #{lines[i]}" } }
      .join("\n   #{"+---"*8}+\n") <<
      "\n   #{"+---"*8}+\n"
    end

    # Pushes an array of the game board onto a stack.
    # The stack size limit is 3(default).
    def push_stack
      bb = {:black => black_getter,:white => white_getter}
      @stack.push(Marshal.load(Marshal.dump(bb)))
      @stack.shift if @stack.size > @options[:stack_limit]
    end

    # Pops a hash of the game board off of the stack,
    # and that is stored in the instance variable.(`@bit_board`)
    def undo!
      bb = @stack.pop
      black_setter(bb[:black])
      white_setter(bb[:white])
    end
  end
end
