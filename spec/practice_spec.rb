require "code_exercises/practice"

RSpec.describe SpaceAgency do
  describe "#initialize" do
    it "has initial coordinates of [0, 0]" do
      expect(subject.coordinates).to eq([0, 0])
    end
    it "has a destination of [0, 250]" do
      expect(subject.destination).to eq([0, 250])
    end
    it "has initial speed of 0" do
      expect(subject.speed).to eq(0)
    end
  end

  describe "#command(key)" do
    before do
      subject = SpaceAgency.new
    end

    context "w" do
      it "increases the ship's speed and then moves it forward by speed units" do
        expect{subject.command("w")}.to change{subject.speed}.by(1)
          .and change{subject.coordinates[0]}.by(0)
          .and change{subject.coordinates[1]}.by(subject.speed + 1)        
      end

      context "when the ship's speed is at 5" do      
        it "does not increase the ship's speed above 5" do
          subject.speed = 5
          expect{subject.command("w")}.to change{subject.speed}.by(0)
            .and change{subject.coordinates[0]}.by(0)
            .and change{subject.coordinates[1]}.by(subject.speed)        
        end    

        it "returns maximum speed message" do
          subject.speed = 5
          expect(subject.command("w")).to eq("maximum speed")   
        end
      end
    end

    context "a" do
      it "moves the ship left by one unit and forward by speed units" do
        expect{subject.command("a")}.to change{subject.speed}.by(0)        
          .and change{subject.coordinates[0]}.by(-1)        
          .and change{subject.coordinates[1]}.by(subject.speed)        
      end

      context "when the ship's x coordinate is < -5" do
        it "returns wrong trajectory message" do
          subject.coordinates = [-6, 10]
          expect(subject.command("a")).to eq("wrong trajectory")   
        end        
      end
    end

    context "s" do
      it "decreases the ship's speed and then moves it forward by speed units" do
        subject.speed = 2
        expect{subject.command("s")}.to change{subject.speed}.by(-1)        
          .and change{subject.coordinates[0]}.by(0)        
          .and change{subject.coordinates[1]}.by(subject.speed - 1)        
      end

      context "when the ship's speed is at 1" do
        it "does not decrease the ship's speed below 1" do
          subject.speed = 1
          expect{subject.command("s")}.to change{subject.speed}.by(0)
            .and change{subject.coordinates[0]}.by(0)
            .and change{subject.coordinates[1]}.by(subject.speed)     
        end

        it "returns minimum speed message" do
          subject.speed = 1
          expect(subject.command("s")).to eq("minimum speed")   
        end
      end
    end

    context "d" do
      it "moves the ship right by one unit and forward by speed units" do
        expect{subject.command("d")}.to change{subject.speed}.by(0)        
          .and change{subject.coordinates[0]}.by(1)        
          .and change{subject.coordinates[1]}.by(subject.speed)        
      end

      context "when the ship's x coordinate is > 5" do
        it "returns wrong trajectory message" do
          subject.coordinates = [6, 10]
          expect(subject.command("d")).to eq("wrong trajectory")   
        end        
      end
    end

    context "invalid key" do
      it "returns invalid key message" do
        subject.coordinates = [6, 10]
        expect(subject.command("z")).to eq("the key you entered was incorrect. please try again.")   
      end
    end
  end

  describe "takeoff" do
    context "when the CLI begins" do
      it "will display initial message" do
        expect{ subject.takeoff_msg }.to output("(0, 0) ready for launch\n").to_stdout
      end
    end

    context "when the ship's y coordinate > 250" do
      it "will display lost contact message" do
        subject.coordinates = [0, 251]
        expect{ subject.takeoff }.to output("(0, 0) ready for launch\ncontact lost\n").to_stdout
      end
    end

    context "when the ship's reaches the destination" do
      it "will display success message" do
        subject.coordinates = [0, 250]
        expect{ subject.takeoff }.to output("(0, 0) ready for launch\non the moon!\n").to_stdout
      end
    end
  end
end