require 'pry-byebug'

class SpaceAgency
  attr_accessor :coordinates, :destination, :speed

  def initialize
    @coordinates = [0, 0]
    @destination = [0, 250]
    @speed = 0
  end

  def takeoff
    takeoff_msg
    while (@coordinates != @destination) && @coordinates[1] <= 250
      key = gets.chomp.downcase
      alert_msg = command(key)
      puts "[#{@coordinates[0]}, #{@coordinates[1]}] #{alert_msg ? alert_msg : ''}"
    end
    if @coordinates == @destination
      puts "on the moon!"
    else
      puts "contact lost"
    end
  end

  def takeoff_msg
    puts "(0, 0) ready for launch"
  end

  def command(key)
    msg = false
    case key
    when "w"
      if @speed >= 5
        msg = "maximum speed"
      else
        @speed += 1
      end
      @coordinates[1] += @speed
    when "s"
      if @speed <= 1
        msg = "minimum speed"
      else
        @speed -= 1
      end
      @coordinates[1] += @speed
    when "a"
      @coordinates[0] -= 1
      @coordinates[1] += @speed
      if @coordinates[0] < -5
        msg = "wrong trajectory"
      end
    when "d"
      @coordinates[0] += 1
      @coordinates[1] += @speed
      if @coordinates[0] > 5
        msg = "wrong trajectory"
      end
    else
      msg = "the key you entered was incorrect. please try again."
    end
    return msg
  end
end