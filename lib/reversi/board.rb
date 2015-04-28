module Reversi
  class Board
    attr_reader :options, :stack

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
      @bit_board = {
        :black => 0x0000_0000_0000_0000,
        :white => 0x0000_0000_0000_0000
      }

      [:disk_color_b, :disk_color_w].each do |color|
        if @options[color].is_a?(Symbol) || @options[color].is_a?(String)
          @options[color] = DISK_COLOR[@options[color].to_sym].to_i
        end
      end

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
      (0..63).map do |i|
        case 1
        when @bit_board[:black][63 - i] then "\e[#{@options[:disk_color_b]}m#{@options[:disk_b]}\e[0m"
        when @bit_board[:white][63 - i] then "\e[#{@options[:disk_color_w]}m#{@options[:disk_w]}\e[0m"
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
      @stack.push(Marshal.load(Marshal.dump(@bit_board)))
      @stack.shift if @stack.size > @options[:stack_limit]
    end

    def undo!
      @bit_board = @stack.pop
    end

    # Returns a hash containing the coordinates of each color.
    #
    # @return [Hash{Symbol => Array<Symbol, Integer>}]
    def status
      ary = [[], [], []]
      black = @bit_board[:black]
      white = @bit_board[:white]
      blank = ~(@bit_board[:black] | @bit_board[:white]) & 0xFFFF_FFFF_FFFF_FFFF
      while black != 0 do
        p = black & (~black + 1) & 0xFFFF_FFFF_FFFF_FFFF
        ary[0] << bb_to_xy(p)
        black ^= p
      end
      while white != 0 do
        p = white & (~white + 1) & 0xFFFF_FFFF_FFFF_FFFF
        ary[1] << bb_to_xy(p)
        white ^= p
      end
      while blank != 0 do
        p = blank & (~blank + 1) & 0xFFFF_FFFF_FFFF_FFFF
        ary[2] << bb_to_xy(p)
        blank ^= p
      end
      {:black => ary[0], :white => ary[1], :none => ary[2]}
    end

    # Returns the openness of the coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Integer] the openness
    def openness(x, y)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      p = xy_to_bb(x, y)
      blank = ~(@bit_board[:black] | @bit_board[:white]) & 0xFFFF_FFFF_FFFF_FFFF
      bb = ((p << 1) & (blank & 0xFEFE_FEFE_FEFE_FEFE)) |
           ((p >> 1) & (blank & 0x7F7F_7F7F_7F7F_7F7F)) |
           ((p << 8) & (blank & 0xFFFF_FFFF_FFFF_FFFF)) |
           ((p >> 8) & (blank & 0xFFFF_FFFF_FFFF_FFFF)) |
           ((p << 7) & (blank & 0x7F7F_7F7F_7F7F_7F7F)) |
           ((p >> 7) & (blank & 0xFEFE_FEFE_FEFE_FEFE)) |
           ((p << 9) & (blank & 0xFEFE_FEFE_FEFE_FEFE)) |
           ((p >> 9) & (blank & 0x7F7F_7F7F_7F7F_7F7F))
      bb = (bb & 0x5555_5555_5555_5555) + (bb >> 1  & 0x5555_5555_5555_5555)
      bb = (bb & 0x3333_3333_3333_3333) + (bb >> 2  & 0x3333_3333_3333_3333)
      bb = (bb & 0x0F0F_0F0F_0F0F_0F0F) + (bb >> 4  & 0x0F0F_0F0F_0F0F_0F0F)
      bb = (bb & 0x00FF_00FF_00FF_00FF) + (bb >> 8  & 0x00FF_00FF_00FF_00FF)
      bb = (bb & 0x0000_FFFF_0000_FFFF) + (bb >> 16 & 0x0000_FFFF_0000_FFFF)
           (bb & 0x0000_0000_FFFF_FFFF) + (bb >> 32 & 0x0000_0000_FFFF_FFFF)
    end

    # Returns the color of supplied coordinates.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @return [Symbol] the color or `:none`
    def at(x, y)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      p = xy_to_bb(x, y)
      if    (p & @bit_board[:black]) != 0 then return :black
      elsif (p & @bit_board[:white]) != 0 then return :white
      else return :none
      end
    end

    # Counts the number of the supplied color's disks.
    #
    # @param color [Symbol]
    # @return [Integer] the sum of the counted disks
    def count_disks(color)
      bb = case color
        when :black then @bit_board[:black]
        when :white then @bit_board[:white]
        else ~(@bit_board[:black] | @bit_board[:white]) & 0xFFFF_FFFF_FFFF_FFFF
      end
      bb = (bb & 0x5555_5555_5555_5555) + (bb >> 1  & 0x5555_5555_5555_5555)
      bb = (bb & 0x3333_3333_3333_3333) + (bb >> 2  & 0x3333_3333_3333_3333)
      bb = (bb & 0x0F0F_0F0F_0F0F_0F0F) + (bb >> 4  & 0x0F0F_0F0F_0F0F_0F0F)
      bb = (bb & 0x00FF_00FF_00FF_00FF) + (bb >> 8  & 0x00FF_00FF_00FF_00FF)
      bb = (bb & 0x0000_FFFF_0000_FFFF) + (bb >> 16 & 0x0000_FFFF_0000_FFFF)
           (bb & 0x0000_0000_FFFF_FFFF) + (bb >> 32 & 0x0000_0000_FFFF_FFFF)
    end

    # Returns an array of the next moves.
    #
    # @param color [Symbol]
    # @return [Array<Array<Symbol, Integer>>]
    def next_moves(color)
      my, op = case color
        when :black then [@bit_board[:black], @bit_board[:white]]
        when :white then [@bit_board[:white], @bit_board[:black]]
      end
      blank = ~(my | op) & 0xFFFF_FFFF_FFFF_FFFF
      pos = horizontal_pos(my, op, blank) | vertical_pos(my, op, blank) | diagonal_pos(my, op, blank)
      moves = []
      while pos != 0 do
        p = pos & (~pos + 1) & 0xFFFF_FFFF_FFFF_FFFF
        moves << bb_to_xy(p)
        pos ^= p
      end
      moves
    end

    # Places a supplied color's disk on specified position.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def put_disk(x, y, color)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      p = xy_to_bb(x, y)
      case color
      when :black then @bit_board[:black] ^= p
      when :white then @bit_board[:white] ^= p
      end
    end

    # Flips the opponent's disks between a new disk and another disk of my color.
    # The invalid move has no effect.
    #
    # @param x [Symbol, Integer] the column number
    # @param y [Integer] the row number
    # @param color [Symbol]
    def flip_disks(x, y, color)
      x = [*:a..:h].index(x) + 1 if x.is_a? Symbol
      p = xy_to_bb(x, y)
      rev = get_rev(x, y, color)
      case color
      when :black
        @bit_board[:black] ^= p | rev
        @bit_board[:white] ^= rev
      when :white
        @bit_board[:white] ^= p | rev
        @bit_board[:black] ^= rev
      end
    end

    private

    def xy_to_bb(x = 1, y = 1)
      1 << ((8 - x) + (8 - y) * 8)
    end

    def bb_to_xy(bb)
      x = 8 - (Math.log(bb, 2).to_i % 8)
      y = 8 - (Math.log(bb, 2).to_i / 8)
      [x, y]
    end

    def rotate_r90(bb)
      bb = ((bb <<  8) & 0xAA00_AA00_AA00_AA00) |
           ((bb >>  8) & 0x0055_0055_0055_0055) |
           ((bb <<  1) & 0x00AA_00AA_00AA_00AA) |
           ((bb >>  1) & 0x5500_5500_5500_5500)
      bb = ((bb << 16) & 0xCCCC_0000_CCCC_0000) |
           ((bb >> 16) & 0x0000_3333_0000_3333) |
           ((bb <<  2) & 0x0000_CCCC_0000_CCCC) |
           ((bb >>  2) & 0x3333_0000_3333_0000)
      bb = ((bb << 32) & 0xF0F0_F0F0_0000_0000) |
           ((bb >> 32) & 0x0000_0000_0F0F_0F0F) |
           ((bb <<  4) & 0x0000_0000_F0F0_F0F0) |
           ((bb >>  4) & 0x0F0F_0F0F_0000_0000)
      bb
    end

    def rotate_l90(bb)
      bb = ((bb <<  1) & 0xAA00_AA00_AA00_AA00) |
           ((bb >>  1) & 0x0055_0055_0055_0055) |
           ((bb >>  8) & 0x00AA_00AA_00AA_00AA) |
           ((bb <<  8) & 0x5500_5500_5500_5500)
      bb = ((bb <<  2) & 0xCCCC_0000_CCCC_0000) |
           ((bb >>  2) & 0x0000_3333_0000_3333) |
           ((bb >> 16) & 0x0000_CCCC_0000_CCCC) |
           ((bb << 16) & 0x3333_0000_3333_0000)
      bb = ((bb <<  4) & 0xF0F0_F0F0_0000_0000) |
           ((bb >>  4) & 0x0000_0000_0F0F_0F0F) |
           ((bb >> 32) & 0x0000_0000_F0F0_F0F0) |
           ((bb << 32) & 0x0F0F_0F0F_0000_0000)
      bb
    end

    def rotate_r45(bb)
      (bb & 0x0101_0101_0101_0101) |
      (((bb <<  8) | (bb >> 56) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0202_0202_0202_0202) |
      (((bb << 16) | (bb >> 48) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0404_0404_0404_0404) |
      (((bb << 24) | (bb >> 40) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0808_0808_0808_0808) |
      (((bb << 32) | (bb >> 32) & 0xFFFF_FFFF_FFFF_FFFF) & 0x1010_1010_1010_1010) |
      (((bb << 40) | (bb >> 24) & 0xFFFF_FFFF_FFFF_FFFF) & 0x2020_2020_2020_2020) |
      (((bb << 48) | (bb >> 16) & 0xFFFF_FFFF_FFFF_FFFF) & 0x4040_4040_4040_4040) |
      (((bb << 56) | (bb >>  8) & 0xFFFF_FFFF_FFFF_FFFF) & 0x8080_8080_8080_8080)
    end

    def rotate_l45(bb)
      (bb & 0x0101_0101_0101_0101) |
      (((bb >>  8) | (bb << 56) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0202_0202_0202_0202) |
      (((bb >> 16) | (bb << 48) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0404_0404_0404_0404) |
      (((bb >> 24) | (bb << 40) & 0xFFFF_FFFF_FFFF_FFFF) & 0x0808_0808_0808_0808) |
      (((bb >> 32) | (bb << 32) & 0xFFFF_FFFF_FFFF_FFFF) & 0x1010_1010_1010_1010) |
      (((bb >> 40) | (bb << 24) & 0xFFFF_FFFF_FFFF_FFFF) & 0x2020_2020_2020_2020) |
      (((bb >> 48) | (bb << 16) & 0xFFFF_FFFF_FFFF_FFFF) & 0x4040_4040_4040_4040) |
      (((bb >> 56) | (bb <<  8) & 0xFFFF_FFFF_FFFF_FFFF) & 0x8080_8080_8080_8080)
    end

    def get_rev(x, y, color)
      p = xy_to_bb(x, y)
      return 0 if ((@bit_board[:black] | @bit_board[:white]) & p) != 0

      my, op = case color
        when :black then [@bit_board[:black], @bit_board[:white]]
        when :white then [@bit_board[:white], @bit_board[:black]]
      end

      horizontal_pat(my, op, p) |
      vertical_pat(my, op, p) |
      diagonal_pat(my, op, p)
    end

    def horizontal_pat(my, op, p)
      op &= 0x7E7E_7E7E_7E7E_7E7E
      right_pat(my, op, p) | left_pat(my, op, p)
    end

    def vertical_pat(my, op, p)
      my = rotate_r90(my)
      op = rotate_r90(op & 0x00FF_FFFF_FFFF_FF00)
      p  = rotate_r90(p)
      rotate_l90(right_pat(my, op, p) | left_pat(my, op, p))
    end

    def diagonal_pat(my, op, p)
      my_r45 = rotate_r45(my)
      op_r45 = rotate_r45(op & 0x007E_7E7E_7E7E_7E00)
      p_r45  = rotate_r45(p)
      my_l45 = rotate_l45(my)
      op_l45 = rotate_l45(op & 0x00FF_7E7E_7E7E_7E00)
      p_l45  = rotate_l45(p)
      rotate_l45(right_pat(my_r45, op_r45, p_r45) | left_pat(my_r45, op_r45, p_r45)) |
      rotate_r45(right_pat(my_l45, op_l45, p_l45) | left_pat(my_l45, op_l45, p_l45))
    end

    def left_pat(my, op, p)
      rev =  (p   << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      ((rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & my) == 0 ? 0 : rev
    end

    def right_pat(my, op, p)
      rev =  (p   >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      ((rev >> 1) & my) == 0 ? 0 : rev
    end

    def horizontal_pos(my, op, blank)
      op &= 0x7E7E_7E7E_7E7E_7E7E
      right_pos(my, op, blank) | left_pos(my, op, blank)
    end

    def vertical_pos(my, op, blank)
      my    = rotate_r90(my)
      op    = rotate_r90(op & 0x00FF_FFFF_FFFF_FF00)
      blank = rotate_r90(blank)
      rotate_l90(right_pos(my, op, blank) | left_pos(my, op, blank))
    end

    def diagonal_pos(my, op, blank)
      my_r45    = rotate_r45(my)
      op_r45    = rotate_r45(op & 0x007E_7E7E_7E7E_7E00)
      blank_r45 = rotate_r45(blank)
      my_l45    = rotate_l45(my)
      op_l45    = rotate_l45(op & 0x007E_7E7E_7E7E_7E00)
      blank_l45 = rotate_l45(blank)
      rotate_l45(right_pos(my_r45, op_r45, blank_r45) | left_pos(my_r45, op_r45, blank_r45)) |
      rotate_r45(right_pos(my_l45, op_l45, blank_l45) | left_pos(my_l45, op_l45, blank_l45))
    end

    def right_pos(my, op, blank)
      rev =  (my  << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      rev |= (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & op
      (rev << 1) & 0xFFFF_FFFF_FFFF_FFFF & blank
    end

    def left_pos(my, op, blank)
      rev =  (my  >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      rev |= (rev >> 1) & op
      (rev >> 1) & blank
    end
  end
end
