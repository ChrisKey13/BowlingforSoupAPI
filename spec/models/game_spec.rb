require 'rails_helper'

RSpec.describe Game, type: :model do

  describe 'Frame Advancement After a Spare' do
    let(:game) { Game.create }
  
    it 'advances frame correctly after a spare' do
      game.roll(7) 
      game.roll(3)
      game.roll(5)
  
      expect(game.current_frame).to eq(1)
    end


    it 'correctly scores a spare followed by a regular hit' do
      game.roll(7)
      game.roll(3)
      game.roll(5)
    
      expect(game.total_score).to eq(7 + 3 + 5 + 5)
    end
    
    it 'calculates the correct score for Frame 3 in a specific scenario' do
      game.roll(10) 
      game.roll(3)
      game.roll(6)
      game.roll(7)
      game.roll(3)
      game.roll(5)
    
      expected_score = 10 + 3 + 6 + 3 + 6 + 7 + 3 + 5 + 5
      expect(game.total_score).to eq(expected_score)
    end    
  end
  

  describe 'Frame Scoring' do
    let(:game) { Game.new }
  
    it 'scores early strike frames correctly' do
      game.roll(10)
      game.roll(10)
      game.roll(10)
  
      first_frame_object = FrameFactory.create(game.frames.first, game.frames.flatten[1..2])
      first_frame_score = first_frame_object.score
  
      second_frame_object = FrameFactory.create(game.frames[1], [game.frames.flatten[2], 0])
      second_frame_score = second_frame_object.score
  
      expect(first_frame_score).to eq(30) 
      expect(second_frame_score).to eq(20) 
    end

    it 'handles a strike in the first roll of the 10th frame correctly' do
      18.times { game.roll(0) }
  
      game.roll(10) 
      game.roll(10) 
      game.roll(10) 
  
      expect(game.state).to be_an_instance_of(GameOverState)
      expect(game.total_score).to eq(30)
    end

    it 'handles a spare in the 10th frame correctly' do
      18.times { game.roll(0) }
  
      game.roll(5) 
      game.roll(5) 
      game.roll(10)
  
      expect(game.state).to be_an_instance_of(GameOverState)
      expect(game.total_score).to eq(20)
    end

    it 'handles a regular 10th frame without strike or spare correctly' do
      18.times { game.roll(0) }
  
      game.roll(3)
      game.roll(4)
  
      expect(game.state).to be_an_instance_of(GameOverState)
      expect(game.total_score).to eq(7)
    end

  
    it 'scores later strike frames correctly' do
      16.times { game.roll(0) }
  
      game.roll(10)
      game.roll(10)
      game.roll(10) 
      game.roll(10) 
  
      tenth_frame_object = FrameFactory.create(game.frames[9], game.frames.flatten[18..20])
      tenth_frame_score = tenth_frame_object.score
  
      expect(tenth_frame_score).to eq(30) 
    end
  
    it 'scores a spare frame correctly' do
      game.roll(5) 
      game.roll(5)
      game.roll(3)
  
      frame_object = FrameFactory.create(game.frames.first, game.frames.flatten[2..2])
      frame_score = frame_object.score
  
      expect(frame_score).to eq(13) 
    end

    it 'scores a perfect game correctly' do
      12.times { game.roll(10) }
  
      expect(game.state).to be_an_instance_of(GameOverState)
      expect(game.total_score).to eq(300)
    end
  end
  

  context "when playing with all strikes" do
    let(:game) { Game.create }

    it "should score a perfect game with all strikes" do
      12.times { game.roll(10) } 
      expect(game.total_score).to eq(300)
    end
  end

  context "when playing with all spares" do
    let(:game) { Game.create }

    it "should score a perfect game with all spares" do
      21.times { game.roll(5) }
      expect(game.total_score).to eq(150)
    end
  end

  context "when playing with a mix of strikes, spares, and regular frames" do
    let(:game) { Game.create }

    it "should calculate the score correctly" do
      game.roll(10)
      game.roll(3)
      game.roll(6)
      game.roll(7)
      game.roll(3)
      game.roll(5)
      game.roll(4)
      game.roll(10)
      game.roll(2)
      game.roll(7)
      game.roll(10)
      game.roll(1)
      game.roll(8)
      game.roll(10)
      game.roll(10)
      game.roll(10)
      game.roll(7)
    
      expect(game.total_score).to eq(165)
    end
    
  end
end
