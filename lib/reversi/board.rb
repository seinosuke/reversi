module Reversi
  class Board
    attr_reader :options, :columns, :stack

    COORDINATES = (:a..:h).map{ |x| (1..8).map{ |y| [x, y] } }.flatten(1).freeze

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
      @stack = []
      [:disk_color_b, :disk_color_w].each do |color|
        if options[color].is_a?(Symbol) || options[color].is_a?(String)
          options[color] = DISK_COLOR[options[color].to_sym].to_i
        end
      end
      @columns = (0..9).map{ (0..9).map{ |_| DISK[:none] } }
      put_disk(4, 4, :white); put_disk(5, 5, :white)
      put_disk(4, 5, :black); put_disk(5, 4, :black)
      @columns.each do |col|
        col[0] = 2; col[-1] = 2
      end.tap do |cols|
        cols[0].fill(2); cols[-1].fill(2)
      end
    end

    # Returns a string of the game board in human-readable form.
    #
    # @return [String]
    def to_s
      "     #{(:a..:h).to_a.map(&:to_s).join("   ")}\n" <<
      "   #{"+---"*8}+\n" <<
      @columns[1][1..-2].zip(*@columns[2..8].map{ |col| col[1..-2] })
      .map{ |row| row.map do |e|
        case e
        when  0 then " "
        when -1 then "\e[#{@options[:disk_color_b]}m#{@options[:disk_b]}\e[0m"
        when  1 then "\e[#{@options[:disk_color_w]}m#{@options[:disk_w]}\e[0m"
        end
      end
      .map{ |e| "| #{e} |" }.join }.map{ |e| e.gsub(/\|\|/, "|") }
      .tap{ |rows| break (0..7).to_a.map{ |i| " #{i+1} " << rows[i] } }
      .join("\n   #{"+---"*8}+\n") <<
      "\n   #{"+---"*8}+\n"
    end

    # Pushes an array of the game board onto a stack.
    # The stack size limit is 3(default).
    def push_stack
      @stack.push(Marshal.load(Marshal.dump(@columns)))
      @stack.shift if @stack.size > @options[:stack_limit]
    end

    # Pops an array of the game board off of the stack,
    # and that is stored in the instance variable.(`@columns`)
    #
    # @param num [Integer] Be popped from the stack by the supplied number of times.
    def undo!(num = 1)
      num.times{ @columns = @stack.pop }
    end

    # Returns a hash containing the number of each color.
    #
    # @return [Hash{Symbol => Integer}]
    def status
      Hash[*[:none, :black, :white].map{ |key| [key, count_disks(key)] }.flatten]
    end

    # Returns a hash containing the coordinates of each color.
    #
    # @return [Hash{Symbol => Array<Symbol, Integer>}]
    def detailed_status
      Hash[*[:none, :black, :white].map do |key|
        [key, COORDINATES.map{ |x, y| [x, y] if key == at(x, y) }.compact]
      end.flatten(1)]
    end

    # Returns the openness of the coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Integer] the openness
    def openness(x, y)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      ([-1,0,1].product([-1,0,1]) - [[0, 0]]).inject(0) do |sum, (dx, dy)|
        sum + (@columns[x + dx][y + dy] == 0 ? 1 : 0)
      end
    end

    # Returns the color of supplied coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Symbol] the color or `:none`
    def at(x, y)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      DISK.key(@columns[x][y])
    end

    # Counts the number of the supplied color's disks.
    #
    # @param color [Symbol]
    # @return [Integer] the sum of the counted disks
    def count_disks(color)
      @columns.flatten.inject(0) do |sum, e|
        sum + (e == DISK[color] ? 1 : 0)
      end
    end

    # Returns an array of the next moves.
    #
    # @param color [Symbol]
    # @return [Array<Array<Symbol, Integer>>]
    def next_moves(color)
      @columns[1..8].map{ |col| col[1..-2] }
      .flatten.each_with_index.inject([]) do |list, (_, i)|
        list << (puttable?(*COORDINATES[i], color) ? COORDINATES[i] : nil)
      end.compact
    end

    # Places a supplied color's disk on specified position.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def put_disk(x, y, color)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @columns[x][y] = DISK[color.to_sym]
    end

    # Flips the opponent's disks between a new disk and another disk of my color.
    # the invalid move has no effect.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def flip_disks(x, y, color)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      [-1,0,1].product([-1,0,1]).each do |dx, dy|
        next if dx == 0 && dy == 0
        # 隣接石が異色であったらflippable?でひっくり返せるか（挟まれているか）確認
        if @columns[x + dx][y + dy] == DISK[color]*(-1)
          flip_disk(x, y, dx, dy, color) if flippable?(x, y, dx, dy, color)
        end
      end
    end

    private

    # Flips the opponent's disks on one of these straight lines
    # between a new disk and another disk of my color.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param dx [Integer] a horizontal difference
    # @param dy [Integer] a verticaldistance
    # @param color [Symbol]
    def flip_disk(x, y, dx, dy, color)
      return if [DISK[:wall], DISK[:none], DISK[color]].include?(@columns[x+dx][y+dy])
      @columns[x+dx][y+dy] = DISK[color]
      flip_disk(x+dx, y+dy, dx, dy, color)
    end

    # Whether or not a player can place a new disk on specified position.
    # Returns true if the move is valid.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    # @return [Boolean]
    def puttable?(x, y, color)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      return false if @columns[x][y] != 0
      [-1,0,1].product([-1,0,1]).each do |dx, dy|
        next if dx == 0 && dy == 0
        if @columns[x + dx][y + dy] == DISK[color]*(-1)
          return true if flippable?(x, y, dx, dy, color)
        end
      end
      false
    end

    # Whether or not a player can flip the opponent's disks.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param dx [Integer] a horizontal difference
    # @param dy [Integer] a verticaldistance
    # @param color [Symbol]
    # @return [Boolean]
    def flippable?(x, y, dx, dy, color)
      loop do
        x += dx; y += dy
        return true if @columns[x][y] == DISK[color]
        break if [DISK[:wall] ,DISK[:none]].include?(@columns[x][y])
      end
      false
    end
  end
end
