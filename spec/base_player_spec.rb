require 'spec_helper'

describe Reversi::Player::BasePlayer do
  let(:game) { Reversi::Game.new }
  let(:player) { game.player_b }
  let(:board) { game.board }

  describe "#put_disk" do
    context "when a player make a valid move" do
      it "flips the opponent's disks between a new disk and my disk" do
        expect{ player.put_disk(:d, 3) }.to change{ board.status[:black].size }.by(2)
      end
    end

    context "when a player make an invalid move" do
      it "Reversi::MoveError raised" do
        expect{ player.put_disk(:a, 1) }.to raise_error Reversi::MoveError
      end
    end

    context "when the third argument is `false`" do
      it "makes a opponent's move" do
        expect{ player.put_disk(:e, 3, false) }.to change{ board.status[:white].size }.by(2)
      end
    end
  end

  describe "#next_moves" do
    context "when the first argument is omitted" do
      it do
        ans = [[:c, 4], [:d, 3], [:e, 6], [:f, 5]]
        expect(player.next_moves.map{ |move| move[:move] }).to eq ans
      end

      it do
        player.put_disk(:d, 3)
        player.put_disk(:e, 3, false)
        expect(player.next_moves[1][:openness]).to eq 8
        expect(player.next_moves[1][:result]).to eq [[:e, 3], [:e, 4]]
      end
    end

    context "when the first argument is `false`" do
      it do
        ans = [[:c, 5], [:d, 6], [:e, 3], [:f, 4]]
        expect(player.next_moves(false).map{ |move| move[:move] }).to eq ans
      end

      it do
        player.put_disk(:d, 3)
        player.put_disk(:e, 3, false)
        expect(player.next_moves(false)[0][:openness]).to eq 5
        expect(player.next_moves(false)[0][:result]).to eq [[:d, 3]]
      end
    end
  end

  describe "#count_disks" do
    context "when the first argument is omitted" do
      it do
        board.put_disk(:a, 1, :black)
        expect(player.count_disks).to eq 3
      end
    end

    context "when the first argument is `false`" do
      it do
        board.put_disk(:a, 1, :black)
        expect(player.count_disks(false)).to eq 2
      end
    end
  end

  describe "#status" do
    it { expect(player.status[:mine]).to eq [[:d, 5], [:e, 4]] }
    it { expect(player.status[:opponent]).to eq [[:d, 4], [:e, 5]] }
  end
end
