require 'rails_helper'

RSpec.describe Team, type: :model do

  describe 'create new team' do
    before(:each) { @team = build(:team, owner: create(:user)) }
    context 'when params are invalid' do
      after :each do
        expect(@team).to be_invalid
      end
      it 'is invalid when wihthout slug' do
        @team.slug = ''
      end
      it 'is invalid when without owner' do
        @team.owner = nil
      end
      it 'is invalid when the slug is already in use' do
        create(:team, slug: 'someniceslug')
        @team.slug = 'someniceslug'
      end
      it 'is invalid when slug has invalid chars' do
        @team.slug = 'some_invali_Ç98123'
      end
    end
    context 'when params ar ok' do
      before :each do
        expect(@team).to be_valid
        @team.save
      end
      it 'is expected to save team' do
        expect(@team.reload).to match Team.last
      end
      it 'is expected to generate a group named general' do
        expect(@team.reload.groups.size).to match 1
        expect(@team.reload.groups.last.slug).to match 'general'
      end
      it 'is expected that the owner of the group generated is the same of the team' do
        expect(@team.reload.groups.last.owner).to match @team.owner
      end
    end
  end

end
