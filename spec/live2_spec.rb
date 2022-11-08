# We can create a cache
## Expires least recently used items (queue)
## Can have a max size

# API
## Can be instantiated in memory.
## Takes in the max number of records 
## Can write to the cache key
## Can retrieve object with key, or return nil
## Can delete by key
## Can delete all items
## Can return the number of records in cache

require 'code_exercises/live2'

RSpec.describe Cache do
  before do
    subject = Cache.new(50)
  end

  it "can create an empty cache when given a max size" do
    expect(Cache.new(50)).to be_truthy
  end

  it "will error if we don't give a max size" do
    #expect(subject.new()).to be(false)
  end

  it "can write to a key" do
    expect(subject.write("key1", "val1")).to be("val1")
    expect(subject.cache["key1"]).to be("val1")
  end

  describe '#read' do
    before do
      c = Cache.new(50)
    end

    context "if key exists" do
      it "can read from a key" do
        c = Cache.new(50)
        c.cache["key1"] = "val1"
        expect(c.read("key1")).to eq("val1")
      end
    end

    context "if key does not exist" do
      it "will return nil" do
        c = Cache.new(50)
        c.cache["key1"] = nil
        expect(c.read("key1")).to eq(nil)
      end
    end
  end

  it "can delete a key" do
    
  end
end