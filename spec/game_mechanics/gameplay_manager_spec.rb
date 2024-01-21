require 'rails_helper'

RSpec.describe GameplayManager, type: :service do
    describe 'GameplayManager' do
        let(:game) { Game.create }
    
        context 'when advancing frames' do
        it 'correctly advances frames after a regular roll' do
            game.roll(3)
            game.roll(4)
            expect(game.current_frame).to eq(1) 
        end
    
        it 'correctly advances frames after a spare' do
            game.roll(7)
            game.roll(3) 
            expect(game.current_frame).to eq(1) 
        end
    
        it 'correctly advances frames after a strike' do
            game.roll(10) 
            expect(game.current_frame).to eq(1) 
        end
        end
    end
end