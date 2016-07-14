require_relative 'tile.rb'
require 'colorize'
require 'byebug'

class Board

  attr_reader :grid

  def initialize(num_bombs = 5)
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
     @grid[pos[0]][pos[1]].value = "B"
  end

  def valid?(pos)
    tile = @grid[pos[0]][pos[1]]
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
        adj << @grid[y][x]
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
  def render
    system("clear")
    print "  "
    (0...@grid.length).each {|i| print "  #{i} "}
    puts ""
    @grid.each_with_index do |row, idx|
      print "  "
      puts "----" * @grid.length
      print "#{idx} "
      row.each do |space|
        if space.flagged == true
          print "|" + " F ".colorize(:red)
        elsif space.visible == false
          print "|" + "   ".colorize(:background => :white)
        elsif space.value == 0
          print "|   "
        elsif space.value == "B"
          print "|" + " #{space.value} ".colorize(:color => :black, :background => :red)
        else
          print "|" + " #{space.value} ".colorize(:green)
        end
      end
      puts '|'
    end
    print "  "
    puts "----" * @grid.length
  end

  #game play
  def take(action, pos)
    tile = @grid[pos[0]][pos[1]]
    action == "r" ? reveal(tile, pos) : tile.flag
  end

  def reveal(tile, pos)
    tile.value == 0 ? reveal_empty(pos) : tile.reveal
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

end
