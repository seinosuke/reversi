require 'spec_helper'

describe Reversi::Board do
  let(:options) do
    {:player_b => Reversi::Player::RandomAI,
     :player_w => Reversi::Player::RandomAI,
     :disk_b => "b",
     :disk_w => "w",
     :disk_color_b => 0,
     :disk_color_w => 0,
     :initial_position => {:black => [[4, 5], [5, 4]],
                           :white => [[4, 4], [5, 5]]},
     :progress => false,
     :stack_limit => 3}
  end
  let(:board) { Reversi::Board.new(options) }

  describe "the options, disk_b, disk_w" do
    after { Reversi.reset }

    context "when disk_b is invalid" do
      it "should raise Reversi::MoveError" do
        Reversi.configure do |config|
          config.disk_b = "hoge"
          config.disk_w = "w"
        end
        message = "The length of the disk string must be one."
        expect{ Reversi::Game.new.start }.to raise_error(Reversi::OptionError, message)
      end
    end

    context "when both of the disks are invalid" do
      it "should raise Reversi::MoveError" do
        Reversi.configure do |config|
          config.disk_b = "poyo"
          config.disk_w = ""
        end
        message = "The length of the disk string must be one."
        expect{ Reversi::Game.new.start }.to raise_error(Reversi::OptionError, message)
      end
    end

    context "when both of the disks are valid" do
      it "should not raise Reversi::MoveError" do
        Reversi.configure do |config|
          config.disk_b = "a"
          config.disk_w = "b"
        end
        expect{ Reversi::Game.new.start }.not_to raise_error
      end
    end
  end

  describe "sets each disk color" do
    after { Reversi.reset }

    context "when a color name is valid" do
      it "sets the valid color value" do
        Reversi.configure do |config|
          config.disk_color_b = "cyan"
          config.disk_color_w = :red
        end
        game = Reversi::Game.new
        expect(game.board.options[:disk_color_b]).to eq 36
        expect(game.board.options[:disk_color_w]).to eq 31
      end
    end

    context "when a color name is invalid" do
      it "sets 0" do
        Reversi.configure do |config|
          config.disk_color_b = "hoge"
          config.disk_color_w = :hoge
        end
        game = Reversi::Game.new
        expect(game.board.options[:disk_color_b]).to eq 0
        expect(game.board.options[:disk_color_w]).to eq 0
      end
    end
  end

  describe "#to_s" do
    after { Reversi.reset }

    it do
      Reversi.configure do |config|
        config.disk_color_b = :black
        config.disk_color_w = 'white'
      end
      str = <<-END.gsub(/ {6}/,"")
           a   b   c   d   e   f   g   h
         +---+---+---+---+---+---+---+---+
       1 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
       2 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
       3 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
       4 |   |   |   | \e[37mw\e[0m | \e[30mb\e[0m |   |   |   |
         +---+---+---+---+---+---+---+---+
       5 |   |   |   | \e[30mb\e[0m | \e[37mw\e[0m |   |   |   |
         +---+---+---+---+---+---+---+---+
       6 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
       7 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
       8 |   |   |   |   |   |   |   |   |
         +---+---+---+---+---+---+---+---+
      END
      game = Reversi::Game.new
      expect(game.board.to_s).to eq str
    end
  end

  describe "#push_stack" do
    it "the stack size limit is 3(default)" do
      4.times { board.push_stack }
      expect(board.stack.size).to eq 3
    end

    it "the deep copy operation is used" do
      board.push_stack
      board.put_disk(1, 1, Reversi::Board::DISK[:black])
      board.push_stack
      expect(board.stack[0]).not_to eq board.stack[1]
    end
  end

  describe "#undo!" do
    context "when the first argument is omitted" do
      it "the default value is 1" do
        3.times { board.push_stack }
        expect{ board.undo! }.to change{ board.stack.size }.by(-1)
      end
    end
  end

  describe "#status" do
    it "returns a hash containing the coordinates of each color" do
      expect{ board.put_disk(1, 1, Reversi::Board::DISK[:black]) }
        .to change{ board.status[:black].size }.by(1)
      expect{ board.put_disk(2, 1, Reversi::Board::DISK[:black]) }
        .to change{ board.status[:none].size }.by(-1)
    end
  end

  describe "#openness" do
    it "returns the openness of the coordinates" do
      expect(board.openness(1, 1)).to eq 3
      expect(board.openness(2, 2)).to eq 8
      expect(board.openness(4, 4)).to eq 5
    end
  end

  describe "#at" do
    it do
      board.put_disk(3, 3, Reversi::Board::DISK[:white])
      expect(board.at(3, 3)).to eq :white
      expect(board.at(1, 1)).to eq :none
      expect(board.at(4, 5)).to eq :black
    end
  end

  describe "#count_disks" do
    it { expect(board.count_disks(Reversi::Board::DISK[:black])).to eq 2 }
    it { expect(board.count_disks(Reversi::Board::DISK[:white])).to eq 2 }
    it { expect(board.count_disks(Reversi::Board::DISK[:none])).to eq 60 }
  end

  describe "#next_moves" do
    it { expect(board.next_moves(Reversi::Board::DISK[:black]))
      .to eq [[5, 6], [6, 5], [3, 4], [4, 3]] }
    it { expect(board.next_moves(Reversi::Board::DISK[:white]))
      .to eq [[4, 6], [3, 5], [6, 4], [5, 3]] }
  end

  describe "#put_disk, #flip_disks" do
    it "flips the opponent's disks between a new disk and another disk of my color" do
      board.put_disk(4, 6, Reversi::Board::DISK[:white])
      board.put_disk(5, 3, Reversi::Board::DISK[:white])
      board.put_disk(6, 3, Reversi::Board::DISK[:black])
      expect{ board.flip_disks(4, 3, Reversi::Board::DISK[:black]) }
        .to change{ board.status[:black].size }.by(3)
    end
  end
end
