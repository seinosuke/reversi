require 'spec_helper'

describe Reversi::Player::BasePlayer do
  let(:game) { Reversi::Game.new }
  let(:player) { game.player_b }
  let(:board) { game.board }

  describe "#put_disk" do
    context "when a player make a valid move" do
      it "flips the opponent's disks between a new disk and my disk" do
        expect{ player.put_disk(4, 3) }.to change{ board.status[:black].size }.by(2)
      end
    end

    context "when the third argument is `false`" do
      it "makes a opponent's move" do
        expect{ player.put_disk(5, 3, false) }.to change{ board.status[:white].size }.by(2)
      end
    end
  end

  describe "#next_moves" do
    context "when the first argument is omitted" do
      it do
        ans = [[5, 6], [6, 5], [3, 4], [4, 3]]
        expect(player.next_moves).to eq ans
      end
    end

    context "when the first argument is `false`" do
      it do
        ans = [[4, 6], [3, 5], [6, 4], [5, 3]]
        expect(player.next_moves(false)).to eq ans
      end
    end
  end

  describe "#count_disks" do
    context "when the first argument is omitted" do
      it do
        board.put_disk(1, 1, Reversi::Board::DISK[:black])
        expect(player.count_disks).to eq 3
      end
    end

    context "when the first argument is `false`" do
      it do
        board.put_disk(1, 1, Reversi::Board::DISK[:black])
        expect(player.count_disks(false)).to eq 2
      end
    end
  end

  describe "#status" do
    it { expect(player.status[:mine]).to eq [[4, 5], [5, 4]] }
    it { expect(player.status[:opponent]).to eq [[5, 5], [4, 4]] }
  end
end
