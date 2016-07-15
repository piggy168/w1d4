class Render

  def initialize(board)
    @board = board
    @grid = @board.grid
  end

  def draw
    system("clear")
    top_row_nums
    @grid.each_with_index do |row, idx|
      horizontal_line
      print "#{idx} "
      row.each do |space|
        if @board.get_tile_pos(space) == @current_pos
          print "|" + "   ".colorize(:background => :blue)
        elsif space.flagged == true
          flag(space)
        elsif space.visible == false
          empty(space)
        elsif space.value == 0
          visible_blank(space)
        elsif space.value == "B"
          bomb(space)
        else
          revealed_num(space)
        end
      end
      puts '|'
    end
    horizontal_line
  end

  def top_row_nums
    print "  "
    (0...@grid.length).each {|i| print "  #{i} "}
    puts ""
  end

  def horizontal_line
    print "  "
    puts "----" * @grid.length
  end

  def flag(tile)
    if @board.current_pos == @board.get_tile_pos(tile)
      print "|" + " F ".colorize(:color => :red, :background => :blue)
    else
      print "|" + " F ".colorize(:color => :red, :background => :white)
    end
  end

  def empty(tile)
    if @board.current_pos == @board.get_tile_pos(tile)
      print "|" + "   ".colorize(:background => :blue)
    else
      print "|" + "   ".colorize(:background => :white)
    end
  end

  def visible_blank(tile)
    if @board.current_pos == @board.get_tile_pos(tile)
      print "|" + "   ".colorize(:background => :blue)
    else
      print "|   "
    end
  end

  def bomb(tile)
    print "|" + " #{tile.value} ".colorize(:color => :black, :background => :red)
  end

  def revealed_num(tile)
    if @board.current_pos == @board.get_tile_pos(tile)
      print "|" + " #{tile.value} ".colorize(:color => :green, :background => :blue)
    else
      print "|" + " #{tile.value} ".colorize(:green)
    end
  end


end
