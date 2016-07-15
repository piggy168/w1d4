require_relative 'board.rb'
require_relative 'tile.rb'
require_relative 'player.rb'
require_relative 'render.rb'

require 'yaml'
require 'byebug'

class MineSweeper

  def initialize
    @board = Board.new
    @player = Player.new
    @render = Render.new(@board)
  end

  #game flow
  def run
    take_turn until game_over
    @render.draw
    won? ? (puts "You Win!") : (puts "You Suck!")
  end

  def take_turn
    @render.draw
    get_input
  end

  def get_input
    input = @player.get_input
    case input
    when "up"
      @board.change_pos("up")
    when "down"
      @board.change_pos("down")
    when "right"
      @board.change_pos("right")
    when "left"
      @board.change_pos("left")
    when "enter"
      @board.reveal
    when "flag"
      @board.flag
    when "save"
      save
    when "load"
      load
    end
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
    @render = Render.new(@board)
    run
  end

end

game = MineSweeper.new
game.run
