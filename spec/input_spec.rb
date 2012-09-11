
require 'spec_helper'


describe Leg::Input do

  before(:each) do

    @input = Leg::Input.new("the quick blue fox\n jumped the shark\n")
  end

  it 'starts at zero' do

    @input.position.should == [ 0, 1, 1 ]
  end

  describe '#read' do

    it "reads but doesn't move" do

      @input.read(5).should == 'the q'

      @input.position.should == [ 0, 1, 1 ]
    end
  end

  describe '#skip' do

    it 'skips (same line)' do

      @input.skip(5)

      @input.read(4).should == 'uick'
      @input.position.should == [ 5, 1, 6 ]
    end

    it 'skips (new line)' do

      @input.skip(21)

      @input.read(4).should == 'umpe'
      @input.position.should == [ 21, 2, 3 ]
    end
  end

  describe '#rewind' do

    it 'rewinds' do

      @input.skip(21)
      @input.rewind

      @input.read(5).should == 'the q'
      @input.position.should == [ 0, 1, 1 ]
    end

    it 'rewinds with an offset' do

      @input.skip(21)
      @input.rewind(22)

      @input.read(4).should == 'mped'
      @input.position.should == [ 22, 2, 4 ]
    end
  end
end

