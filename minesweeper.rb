require_relative 'board.rb'
require_relative 'tile.rb'
require_relative 'player.rb'

require 'yaml'
require 'byebug'

class MineSweeper

  def initialize
    @board = Board.new
    @player = Player.new
  end

  #game flow
  def run
    take_turn until game_over
    @board.render
    won? ? (puts "You Win!") : (puts "You Suck!")
  end

  def take_turn
    @board.render
    pos = get_guess
    action = get_action
    @board.take(action, pos)
  end

  def get_guess
    guess = @player.get_guess
  end

  def get_action
    action = @player.get_action
    check(action)
  end
  #victory conditions
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

  #load save
  def save
    File.open('save.yml','w') do |h|
      h.write @board.to_yaml
    end
    puts "Game Saved"
    sleep 1
    load
  end

  def load
    @board = YAML.load(File.read('save.yml'))
    run
  end

  def check(input)
    case input
    when "save"
      save
    when "load"
      load
    else
      return input
    end
  end


end

game = MineSweeper.new
game.run
