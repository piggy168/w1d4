require 'io/console'

class Player
  def initialize
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def get_input
    input = read_char
    case input
    when "\e[A"
      return "up"
    when "\e[B"
      return "down"
    when "\e[C"
      return "right"
    when "\e[D"
      return "left"
    when "\r"
      return "enter"
    when "f"
      return "flag"
    when "s"
      return "save"
    when "l"
      return "load"
    else
      get_input
    end

  end

end
