require './lib/game.rb'
require './lib/player.rb'

player1 = Player.new('X')
player2 = Player.new('O')

game = Game.new(player1, player2)
game.start_game