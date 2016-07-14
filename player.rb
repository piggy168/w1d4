class Player
  def initialize
  end

  def get_guess
    puts "enter coordinate eg. y,x"
    format_pos(gets.chomp)
  end

  def format_pos(pos)
    [pos[0].to_i, pos[2].to_i]
  end

  def get_action
    puts "enter action; (r)eveal or (f)lag"
    gets.chomp
  end
end
