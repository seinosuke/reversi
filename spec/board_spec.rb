require 'spec_helper'

describe Reversi::Board do
  let(:options) do
    {:player_b => Reversi::Player::RandomAI,
     :player_w => Reversi::Player::RandomAI,
     :disk_b => "b",
     :disk_w => "w",
     :disk_color_b => disk_color_b,
     :disk_color_w => disk_color_w,
     :progress => false,
     :stack_limit => 3}
  end
  let(:board) { Reversi::Board.new(options) }

  describe "sets each disk color" do
    context "when a color name is valid" do
      let(:disk_color_b) { "cyan" }
      let(:disk_color_w) { :red }
      it "sets the valid color value" do
        expect(board.options[:disk_color_b]).to eq 36
        expect(board.options[:disk_color_w]).to eq 31
      end
    end

    context "when a color name is invalid" do
      let(:disk_color_b) { "hoge" }
      let(:disk_color_w) { :hoge }
      it "sets 0" do
        expect(board.options[:disk_color_b]).to eq 0
        expect(board.options[:disk_color_w]).to eq 0
      end
    end
  end

  describe "#push_stack" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }

    it "the stack size limit is 3(default)" do
      4.times { board.push_stack }
      expect(board.stack.size).to eq 3
    end

    it "the deep copy operation is used" do
      board.push_stack
      board.put_disk(:a, 1, :black)
      board.push_stack
      expect(board.stack[0]).not_to eq board.stack[1]
    end
  end

  describe "#undo!" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }

    context "when the first argument is omitted" do
      it "the default value is 1" do
        3.times { board.push_stack }
        expect{ board.undo! }.to change{ board.stack.size }.by(-1)
      end
    end

    context "when the first argument is supplied" do
      it "the number is used" do
        3.times { board.push_stack }
        expect{ board.undo! 2 }.to change{ board.stack.size }.by(-2)
      end
    end
  end

  describe "#status" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it "returns a hash containing the number of each color" do
      expect{ board.put_disk(:a, 1, :black) }.to change{ board.status[:black] }.by(1)
      expect{ board.put_disk(:b, 1, :black) }.to change{ board.status[:none] }.by(-1)
    end
  end

  describe "#detailed_status" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it "returns a hash containing the coordinates of each color" do
      expect{ board.put_disk(:a, 1, :black) }.to change{ board.detailed_status[:black].size }.by(1)
      expect{ board.put_disk(:b, 1, :black) }.to change{ board.detailed_status[:none].size }.by(-1)
    end
  end

  describe "#openness" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it "returns the openness of the coordinates" do
      expect(board.openness(:a, 1)).to eq 3
      expect(board.openness(:b, 2)).to eq 8
      expect(board.openness(:d, 4)).to eq 5
    end
  end

  describe "#at" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }

    context "when the first argument is a number" do
      it do
        board.put_disk(:c, 3, :white)
        expect(board.at(3, 3)).to eq :white
      end
    end

    context "when the first argument is a symbol" do
      it do
        board.put_disk(7, 8, :black)
        expect(board.at(:g, 8)).to eq :black
      end
    end
  end

  describe "#count_disks" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it { expect(board.count_disks(:black)).to eq 2 }
    it { expect(board.count_disks(:white)).to eq 2 }
    it { expect(board.count_disks(:none)).to eq 60 }
  end

  describe "#next_moves" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it { expect(board.next_moves(:black)).to eq [[:c, 4], [:d, 3], [:e, 6], [:f, 5]] }
    it { expect(board.next_moves(:white)).to eq [[:c, 5], [:d, 6], [:e, 3], [:f, 4]] }
  end

  describe "#put_disk, #flip_disks" do
    let(:disk_color_b) { 0 }
    let(:disk_color_w) { 0 }
    it "flips the opponent's disks between a new disk and my disk" do
      board.put_disk(:d, 6, :white)
      board.put_disk(:e, 3, :white)
      board.put_disk(:f, 3, :black)
      board.put_disk(:d, 3, :black)
      expect{ board.flip_disks(:d, 3, :black) }.to change{ board.status[:black] }.by(2)
    end
  end
end
