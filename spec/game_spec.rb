require './lib/game.rb'
require './lib/player.rb'
require 'colorize'

player1 = Player.new("X")
player2 = Player.new("O")

describe Game do
  it "creates a grid of dimensions 8x6" do   
    game = Game.new(player1, player2)
    expect(game.board).to eql([[0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]])
  end

  it "accepts two players" do
    game = Game.new(player1, player2)
  end

  describe '#player_turn' do
    it "lets the player play a turn" do 
      game = Game.new(player1, player2)
      game.player_turn(0, player1)
      expect(game.board).to eql([["X", 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]])
    end

    it "stacks players turns on top of another" do
      game = Game.new(player1, player2)
      2.times do
        game.player_turn(1, player1)
      end
      3.times do
        game.player_turn(0, player1)
      end
      expect(game.board).to eql([['X', 'X', 'X', 3, 4, 5], ['X', 'X', 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]])
    end
  end

  describe 'check if player has won' do
    describe '#has_won_vertically?' do
      it "returns false when nobody has won" do 
        game = Game.new(player1, player2)
        game.board = [["O", "O", "X", "X", "X", "O"], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
        expect(game.has_won_vertically?(player1)).to eq(false)
      end

      it "checks if the player has won vertically" do     
        game = Game.new(player1, player2)
        game.board = [["O", "O", "X", "X", "X", "X"], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
        expect(game.has_won_vertically?(player1)).to eql(true)
      end

      it "doesn't try to check over the limits (another column)" do      
        game = Game.new(player1, player2)
        game.board = [["O", "O", "O", "X", "X", "X"], ["X", 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
        expect(game.has_won_vertically?(player1)).to eql(false)
      end
    end

    describe '#has_won_horizontally?' do
      it "doesn't always return true" do
        game = Game.new(player1, player2)
        game.board = [['X', 'X', 2, 3, 4, 5], [0, 'X', 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 2, 3, 4, 5], [0, 1, "O", 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
        expect(game.has_won_horizontally?(player2)).to eql(false)
      end

      it "checks if the player has won horizontally" do
        game = Game.new(player1, player2)
        game.board = [['X', 'X', 2, 3, 4, 5], [0, 'X', 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], [0, 1, "O", 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
        expect(game.has_won_horizontally?(player2)).to eql(true)
      end

      it "doesn't try to check over the limits" do
        game = Game.new(player1, player2)
        game.board = [["O", 'X', 2, 3, 4, 5], [0, 'X', 2, 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ["X", "O", "O", 3, 4, 'X'], [0, 1, 2, 3, 4, 'X'], [0, 1, 2, 3, 4, 'X']]
        expect(game.has_won_horizontally?(player1)).to eql(false)
      end
    end
  end

  describe '#has_won_diagonally?' do
    it "doesn't always return true" do
      game = Game.new(player1, player2)
      game.board = [['X', 1, 2, 3, 4, 5], [0, 'X', 'O', 3, 4, 5], ['X', 'X', 'X', "O", 4, 5], ['X', 'O', 'X', "O", 4, 5], ["O", 'X', "O", 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
      expect(game.has_won_diagonally?(player1)).to eql(false)
    end

    it "check if the player has won diagonally" do
      game = Game.new(player1, player2)
      game.board = [['X', 1, 2, 3, 4, 5], [0, 'X', 'O', 3, 4, 5], ['X', 'X', 'X', "O", 4, 5], ['X', 'O', 'X', "X", 4, 5], ["O", 'X', "O", 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
      expect(game.has_won_diagonally?(player1)).to eql(true)
    end

    it "doesn't try to check over the limits" do
      game = Game.new(player1, player2)
      game.board = [["O", 'X', 2, 3, 4, 5], [0, 'X', 2, 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ["X", "O", "O", "X", 4, 5], [0, 1, 2, 3, 'X', 'X'], [0, 1, 2, 3, 4, 'X']]
      expect(game.has_won_horizontally?(player1)).to eql(false)
    end
  end

  describe '#print_board' do
    it 'prints the board' do
      game = Game.new(player1, player2)
      game.print_board
    end

    it 'prints the board with the game on' do
      game = Game.new(player1, player2)
      game.board = [["O", 'X', 2, 3, 4, 5], [0, 'X', 2, 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ["X", "O", "O", "X", 4, 5], [0, 1, 2, 3, 'X', 'X'], [0, 1, 2, 3, 4, 'X']]
      game.print_board
    end
  end

  describe '#has_won' do
    it 'checks if the player has won' do
      game = Game.new(player1, player2)
      game.board = [['X', 1, 2, 3, 4, 5], [0, 'X', 'O', 3, 4, 5], ['X', 'X', 'X', "O", 4, 5], ['X', 'O', 'X', "X", 4, 5], ["O", 'X', "O", 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
      expect(game.has_won?(player1)).to eql(true)
    end

    it "doesn't always return true" do
      game = Game.new(player1, player2)
      game.board = [["O", 'X', 2, 3, 4, 5], [0, 'X', 2, 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ['X', 1, 'O', 3, 4, 5], ["X", "O", "O", "X", 4, 5], [0, 1, 2, 3, 'X', 'X'], [0, 1, 2, 3, 4, 'X']]
      expect(game.has_won?(player1)).to eql(false)
    end


  end


  describe '#tie?' do
    it 'checks if its a tie' do
      game = Game.new(player1, player2)
      game.available_moves = Array.new(7) { Array.new(6, false) }
      expect(game.tie?).to eql(true)
    end
    it "doesn't always return true" do
      game = Game.new(player1, player2)
      expect(game.tie?).to eql(false)
    end
  end
end 