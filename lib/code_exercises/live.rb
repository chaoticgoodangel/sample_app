class Rover
  attr_accessor :coordinates, :heading
  @@possible_headings = {
    1 => "North",
    2 => "East",
    3 => "South",
    4 => "West"
  }

  def initialize
    @coordinates = [0, 0]
    @heading = 1
  end

  def turn_left
    if @heading == 1
    #if @heading % @@possible_headings.keys.length == 0
      #then do special case
      @heading = 4
    else
      @heading -= 1
    end
  end

  def turn_right
    if @heading == 4
      @heading = 1
    else
      @heading += 1
    end
  end

  def move_forward
    case @heading
    when 1
      @coordinates[1] += 1
    when 2
      @coordinates[0] += 1
    when 3
      @coordinates[1] -= 1
    when 4
      @coordinates[0] -= 1
    end
  end

  def get_heading
    @@possible_headings[@heading]
  end
end

class Game
MENU = 
"Command the robot with:
  L - turn left
  R - turn right
  M - move forward
  ? - this message
  Q - quit"

INIT_MSG = 
"Hello! Robot coming online.\n#{MENU}"

  def initialize
    @rover = nil
  end

  def begin_game
    puts begin_game_msg
    @rover = Rover.new
    continue = true
    while continue
      input = gets.chomp
      input.downcase!
      
      display_msg = case input
      when "l"
        @rover.turn_left
        rover_update
      when "r"
        @rover.turn_right
        rover_update
      when "m"
        @rover.move_forward
        rover_update
      when "?"
        MENU
      when "q"
        continue = false
        "Robot shutting down."
      else
        "Invalid key. Please try again.\n#{MENU}"
      end
      puts display_msg
    end
  end

  def begin_game_msg
    return INIT_MSG
  end

  def rover_update
    "Robot at (#{@rover.coordinates[0]}, #{@rover.coordinates[1]}) facing #{@rover.get_heading}"
  end
end

# game = Game.new
# game.begin_game