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

    it "returns the correct rankings for a user if the first faceoff doesn't contain the winner" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_2)

      expect(@list.rankings(@user)).to eq({
        1 => [@option_3],
        2 => [@option_1],
        3 => [@option_2],
      })
    end

    it "returns the correct rankings if there is a tie not for first" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_2)

      user_2 = FactoryBot.create(:user)
      FactoryBot.create(:face_off, :user => user_2, :winner => @option_2, :loser => @option_1)
      FactoryBot.create(:face_off, :user => user_2, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => user_2, :winner => @option_3, :loser => @option_2)

      expect(@list.rankings(@user)).to eq({
        1 => [@option_3],
        2 => [@option_1, @option_2],
      })
    end
  end

  describe "narrative" do
    before do
      @list = FactoryBot.create(:list)
      @user = FactoryBot.create(:user, :name => "User 1")
      @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
      @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
      @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
    end

    it "returns an empty array when the user has not completed voting" do
      expect(@list.narrative(@user)).to eq([])
    end

    it "returns rankings when a user has completed all the face offs" do
      other_user = FactoryBot.create(:user, :name => "User 2")
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

      expect(@list.narrative(@user)).to eq([
        "User 1 chose Pizza over Tacos",
        "User 1 chose Pizza over Thai",
        "User 1 chose Tacos over Thai",
        "User 2 chose Pizza over Tacos",
        "User 2 chose Pizza over Thai",
        "User 2 chose Tacos over Thai",
      ])
    end
  end

  describe "completed_voting_count" do
    before do
      @list = FactoryBot.create(:list)
      @user = FactoryBot.create(:user, :name => "User 1")
      @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
      @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
      @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
    end

    it "returns the number of users who have completed voting" do
      other_user = FactoryBot.create(:user, :name => "User 2")
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

      expect(@list.completed_voting_count(@user)).to eq(1)
    end
  end
end
