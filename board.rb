require_relative 'tile.rb'
require 'colorize'
require 'byebug'

class Board

  attr_reader :grid, :current_pos

  def initialize(num_bombs = 10)
    @current_pos = [0,0]
    @num_bombs = num_bombs
    @grid = Array.new(10) {Array.new(10){Tile.new}}
    bomb_populate
    set_values
  end

  #bomb placement
  def bomb_populate
    @num_bombs.times do
      place_bomb
    end
  end

  def place_bomb
    valid = false
    pos = []
     until valid
       pos = get_pos
       valid = valid?(pos)
     end
     self[*pos].value = "B"
  end

  def valid?(pos)
    tile = self[*pos]
    tile.value == nil
  end

  def get_pos
    size = @grid.length
    x = rand(size)
    y = rand(size)
    [y,x]
  end

  #value placement
  def set_values
    @grid.each_with_index do |row, y|
      row.each_with_index do |space, x|
        space.value = adjacent_bombs([y, x]) if space.value == nil
      end
    end
  end

  def adjacent_bombs(pos)
    adj = adjacent_tiles(pos)
    count = 0
    adj.each do |tile|
      if tile.value == "B"
        count += 1
      end
    end
    count
  end

  def adjacent_tiles(pos)
    adj = []
    pos = get_starting_and_ending(pos)
    (pos[0][0]..pos[1][0]).each do |y|
      (pos[0][1]..pos[1][1]).each do |x|
        adj << self[y, x]
      end
    end
    adj
  end

  def get_starting_and_ending(pos)
    [starting(pos), ending(pos)]
  end

  def starting(pos)
    y = pos[0]
    x = pos[1]
    [[y-1, 0].max,[x-1, 0].max]
  end

  def ending(pos)
    y = pos[0]
    x = pos[1]
    max = @grid.length - 1
    [[y+1, max].min,[x+1, max].min]
  end

  #render Board


  #game play
  def take(action)
    tile = self[pos]
    action == "r" ? reveal(tile, pos) : tile.flag
  end

  def reveal
    tile = self[*@current_pos]
    tile.value == 0 ? reveal_empty(@current_pos) : tile.reveal
  end

  def flag
    tile = self[*@current_pos]
    tile.flag
  end

  def change_pos(direction)
    case direction
    when "up"
      new_y = [@current_pos[0] - 1, 0].max
      new_x = @current_pos[1]
    when "down"
      new_y = [@current_pos[0] + 1, @grid.length - 1].min
      new_x = @current_pos[1]
    when "right"
      new_y = @current_pos[0]
      new_x = [@current_pos[1] + 1, @grid.length - 1].min
    when "left"
      new_y = @current_pos[0]
      new_x = [@current_pos[1] - 1, 0].max
    end
    @current_pos = [new_y, new_x]
  end

  #reaveal empty spaces at once
  def reveal_empty(pos)
    adjacent_tiles(pos).each do |tile|
      pos = get_tile_pos(tile)
      if tile.value == 0 && tile.visible == false
        tile.reveal
        reveal_empty(pos)
      else
        tile.reveal
      end
    end
  end

  def get_tile_pos(tile)
    pos = []
    @grid.each_index{|i| j = @grid[i].index(tile); pos = [i, j] if j}
    pos
  end

  #helper
  def [] (y, x)
    @grid[y][x]
  end

end
