# coding: utf-8

module Reversi
  class Board
    attr_accessor :options, :columns, :stack

    COORDINATES = (:a..:h).map{|x| (1..8).map{|y| [x, y]}}.flatten(1).freeze

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

    def initialize(options = {})
      @options = options
      @stack = []
      options[:disk_color_b] = DISK_COLOR[options[:disk_color_b]] if options[:disk_color_b].is_a? Symbol
      options[:disk_color_w] = DISK_COLOR[options[:disk_color_w]] if options[:disk_color_w].is_a? Symbol
      @columns = (0..9).map{ (0..9).map{|_| DISK[:none]} }.tap{|rows| break rows[0].zip(*rows[1..-1])}
      put_disk(4, 4, :white); put_disk(5, 5, :white)
      put_disk(4, 5, :black); put_disk(5, 4, :black)
      @columns.each{|col| col[0] = 2; col[-1] = 2 }.tap{|cols| cols[0].fill(2); cols[-1].fill(2)}
    end

    def to_s
      "     #{(:a..:h).to_a.map(&:to_s).join("   ")}\n" <<
      "   #{"+---"*8}+\n" <<
      @columns[1][1..-2].zip(*@columns[2..8].map{|col| col[1..-2]})
      .map{|row| row.map do |e|
        case e
        when  0 then " "
        when -1 then "\e[#{@options[:disk_color_b]}m#{@options[:disk_b]}\e[0m"
        when  1 then "\e[#{@options[:disk_color_w]}m#{@options[:disk_w]}\e[0m"
        end
      end
      .map{|e| "| #{e} |"}.join}.map{|e| e.gsub(/\|\|/, "|") }
      .tap{|rows| break (0..7).to_a.map{|i| " #{i+1} " << rows[i]}}
      .join("\n   #{"+---"*8}+\n") <<
      "\n   #{"+---"*8}+\n"
    end

    def push_stack
      @stack.push(Marshal.load(Marshal.dump(@columns)))
      @stack.shift if @stack.size > @options[:stack_limit]
    end

    # 元に戻す
    def undo!(num = 1)
      num.times{ @columns = @stack.pop }
    end

    # 見かけ座標を渡してその地点の色を返す
    # board.at(:a, 1) #=> :white
    def at(x, y)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      DISK.key(@columns[x][y])
    end

    def count_disks(color)
      count = 0
      @columns.flatten.each{|e| count += 1 if e == DISK[color]}
      count
    end

    # 現時点で石が置ける座標のリスト
    def next_moves(color)
      list = []
      @columns[1..8].map{|col| col[1..-2]}.flatten.each_with_index do |val, i|
        if put_disk?(*COORDINATES[i], color)
          list << COORDINATES[i]
        end
      end
      list
    end

    # 見かけ地点の座標を渡して更新
    def put_disk(x, y, color)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      @columns[x][y] = DISK[color.to_sym]
    end

    # その地点にその色の石を置けるか
    # もし置けてさらに隣に異色があったらひっくり返せるか
    def put_disk?(x, y, color)
      x = (:a..:h).to_a.index(x) + 1 if x.is_a? Symbol
      # 既に石があったら置けない
      return false if @columns[x][y] != 0
      [-1,0,1].product([-1,0,1]).each do |dx, dy|
        next if dx == 0 && dy == 0
        if @columns[x + dx][y + dy] == DISK[color]*(-1)
          return true if flip_disks?(x, y, dx, dy, color)
        end
      end
      false
    end

    # 自色で挟まれた石を複数列ひっくり返す
    def flip_disks(x, y, color)
      [-1,0,1].product([-1,0,1]).each do |dx, dy|
        next if dx == 0 && dy == 0
        # 隣接石が異色であったらflip_disks?でひっくり返せるか（挟まれているか）確認
        if @columns[x + dx][y + dy] == DISK[color]*(-1)
          flip_disk(x, y, dx, dy, color) if flip_disks?(x, y, dx, dy, color)
        end
      end
    end

    # 自色で挟まれた石を1列ひっくり返す
    # flip_disks?で挟まれていることが確認されてから使え
    # 次のマスが壁、何もないマス、自色があるマスであれば終了
    def flip_disk(x, y, dx, dy, color)
      return if [DISK[:wall], DISK[:none], DISK[color]].include?(@columns[x+dx][y+dy])
      @columns[x+dx][y+dy] = DISK[color]
      flip_disk(x+dx, y+dy, dx, dy, color)
    end

    # その先に自分と同色が出現したらtrue
    def flip_disks?(x, y, dx, dy, color)
      loop do
        x += dx; y += dy
        return true if @columns[x][y] == DISK[color]
        break if [DISK[:wall] ,DISK[:none]].include?(@columns[x][y])
      end
      false
    end
  end
end
