require_relative 'board.rb'
require_relative 'tile.rb'
require_relative 'player.rb'

class MineSweeper

  def initialize
    @board = Board.new
    @player = Player.new
  end

  def run
    take_turn until game_over
    @board.render
    won? ? (puts "You Win!") : (puts "You Suck!")
  end

  def take_turn
    @board.render
    pos = @player.get_guess
    action = @player.get_action
    @board.take(action, pos)
  end

  def game_over
    return true if won? || lost?
    false
  end

  def won?
    @board.grid.flatten.each do |tile|
      return false if tile.visible == false && tile.value != 'B'
    end
    true
  end

  def lost?
    @board.grid.flatten.each do |tile|
      return true if tile.visible == true && tile.value == 'B'
    end
    false
  end

end

game = MineSweeper.new
game.run
