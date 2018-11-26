require 'rails_helper'

RSpec.describe List, type: :model do
  describe "remaining_face_offs" do
    before do
      @list = FactoryBot.create(:list)
      @user = FactoryBot.create(:user)
      @option_1 = FactoryBot.create(:option, :list => @list)
      @option_2 = FactoryBot.create(:option, :list => @list)
      @option_3 = FactoryBot.create(:option, :list => @list)
    end

    it "returns all potential face_offs if none have been completed" do
      face_offs = @list.remaining_face_offs(@user)

      expect(face_offs.length).to eq(3)
      expect(face_offs).to include([@option_1, @option_2])
      expect(face_offs).to include([@option_1, @option_3])
      expect(face_offs).to include([@option_2, @option_3])
    end

    it "does not return potential face_offs that been completed" do
      FactoryBot.create(
        :face_off,
        :user => @user,
        :winner => @option_1,
        :loser => @option_2,
      )

      face_offs = @list.remaining_face_offs(@user)

      expect(face_offs.length).to eq(2)
      expect(face_offs).to_not include([@option_1, @option_2])
    end
  end

  describe "rankings" do
    before do
      @user = FactoryBot.create(:user)
      @list = FactoryBot.create(:list)
      @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
      @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
      @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
    end

    it "returns rankings for a user" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)

      expect(@list.rankings(@user)).to eq({
        1 => [@option_1],
        2 => [@option_2],
        3 => [@option_3],
      })
    end

    it "returns rankings for a user" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)

      expect(@list.rankings(@user)).to eq({
        1 => [@option_1, @option_2, @option_3],
      })
    end
  end
end
