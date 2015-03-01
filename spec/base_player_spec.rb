require 'spec_helper'

describe Reversi::Player::BasePlayer do
  let(:game) { Reversi::Game.new }
  let(:player) { game.player_b }
  let(:board) { game.board }

  describe "#put_disk" do
    context "when a player make a valid move" do
      it "flips the opponent's disks between a new disk and my disk" do
        expect{ player.put_disk(:d, 3) }.to change{ board.status[:black] }.by(2)
      end

      it "returns the openness of the move" do
        expect(player.put_disk(:d, 3)).to eq 5
        board.put_disk(:d, 4, :white)
        board.put_disk(:c, 3, :black)
        expect(player.put_disk(:f, 6)).to eq 8
      end
    end

    context "when a player make an invalid move" do
      it "Reversi::MoveError raised" do
        expect{ player.put_disk(:a, 1) }.to raise_error Reversi::MoveError
      end
    end

    context "when the third argument is `false`" do
      it "makes a opponent's move" do
        expect{ player.put_disk(:e, 3, false) }.to change{ board.status[:white] }.by(2)
      end
    end
  end

  describe "#next_moves" do
    context "when the first argument is omitted" do
      it { expect(player.next_moves).to eq [[:c, 4], [:d, 3], [:e, 6], [:f, 5]] }
    end

    context "when the first argument is `false`" do
      it { expect(player.next_moves(false)).to eq [[:c, 5], [:d, 6], [:e, 3], [:f, 4]] }
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
end
