class Tile
  attr_accessor :value
  attr_reader :visible, :flagged

  def initialize
    @value = nil
    @flagged = false
    @visible = false
  end

  def reveal
    @visible = true
  end

  def flag
    @flagged = true
  end

end
