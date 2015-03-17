module Reversi
  class Board
    attr_reader :options

    DISK = {
      :none  =>  0,
      :wall  =>  2,
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
      [:disk_color_b, :disk_color_w].each do |color|
        if @options[color].is_a?(Symbol) || @options[color].is_a?(String)
          @options[color] = DISK_COLOR[@options[color].to_sym].to_i
        end
      end
      board_initialize
      @options[:initial_position].each do |color, positions|
        positions.each{ |position| put_disk(*position, color) }
      end
    end

    # Returns a string of the game board in human-readable form.
    #
    # @return [String]
    def to_s
      "     #{[*'a'..'h'].join("   ")}\n" <<
      "   #{"+---"*8}+\n" <<
      columns[1][1..-2].zip(*columns[2..8].map{ |col| col[1..-2] })
      .map{ |row| row.map do |e|
        case e
        when  0 then " "
        when -1 then "\e[#{@options[:disk_color_b]}m#{@options[:disk_b]}\e[0m"
        when  1 then "\e[#{@options[:disk_color_w]}m#{@options[:disk_w]}\e[0m"
        end
      end
      .map{ |e| "| #{e} |" }.join }.map{ |e| e.gsub(/\|\|/, "|") }
      .tap{ |rows| break [*0..7].map{ |i| " #{i+1} " << rows[i] } }
      .join("\n   #{"+---"*8}+\n") <<
      "\n   #{"+---"*8}+\n"
    end

    # Pushes an array of the game board onto a stack.
    # The stack size limit is 3(default).
    def push_stack
      board_push_stack(@options[:stack_limit])
    end

    # Returns a hash containing the coordinates of each color.
    #
    # @return [Hash{Symbol => Array<Symbol, Integer>}]
    def status
      ary = board_status
      {:black => ary[0], :white => ary[1], :none => ary[2]}
    end

    # Returns the openness of the coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Integer] the openness
    def openness(x, y)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      board_openness(x, y)
    end

    # Returns the color of supplied coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Symbol] the color or `:none`
    def at(x, y)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      DISK.key(board_at(x, y))
    end

    # Counts the number of the supplied color's disks.
    #
    # @param color [Symbol]
    # @return [Integer] the sum of the counted disks
    def count_disks(color)
      board_count_disks(DISK[color])
    end

    # Returns an array of the next moves.
    #
    # @param color [Symbol]
    # @return [Array<Array<Symbol, Integer>>]
    def next_moves(color)
      board_next_moves(DISK[color])
    end

    # Places a supplied color's disk on specified position.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def put_disk(x, y, color)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      board_put_disk(x, y, DISK[color])
    end

    # Flips the opponent's disks between a new disk and another disk of my color.
    # The invalid move has no effect.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def flip_disks(x, y, color)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      board_flip_disks(x, y, DISK[color])
    end
  end
end
