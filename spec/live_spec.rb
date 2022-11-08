require 'code_exercises/live'

RSpec.describe Rover do
  describe "initial state" do
    it "has an initial coordinates of 0, 0" do
      expect(subject.coordinates).to eq([0,0])
    end
  end

  describe "movements" do
    describe "turn_left" do
      describe "when heading is North/1" do
        it "will change the heading to West" do
          subject.heading = 1
          expect{subject.turn_left}.to change{subject.heading}.by(3)   
        end
      end

      describe "when heading is not North" do
        it "will change the heading to the left" do
          subject.heading = 2
          expect{subject.turn_left}.to change{subject.heading}.by(-1)   
        end
      end
    end    
    
    describe "turn_right" do
      describe "when heading is East/4" do
        it "will change the heading to North" do
          subject.heading = 4
          expect{subject.turn_right}.to change{subject.heading}.by(-3)   
        end
      end

      describe "when heading is not East" do
        it "will change the heading to the left" do
          subject.heading = 2
          expect{subject.turn_right}.to change{subject.heading}.by(1)   
        end
      end

    end

    describe "move_forward" do
      # case @heading
      # when 1
      #   @coordinates[1] += 1
      # when 2
      #   @coordinates[0] += 1
      # when 3
      #   @coordinates[1] -= 1
      # when 4
      #   @coordinates[0] -= 1
      # end
      context "when"
    end
  end
end

RSpec.describe Game do
  it "will display the initial message" do
  end
end