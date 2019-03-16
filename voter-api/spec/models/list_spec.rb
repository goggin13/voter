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

      expect(@list.rankings).to eq({
        1 => [@option_1.label],
        2 => [@option_2.label],
        3 => [@option_3.label],
      })
    end

    it "returns rankings for a user" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)

      expect(@list.rankings).to eq({
        1 => [@option_1.label, @option_2.label, @option_3.label],
      })
    end

    it "returns the correct rankings for a user if the first faceoff doesn't contain the winner" do
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_1)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_3, :loser => @option_2)

      expect(@list.rankings).to eq({
        1 => [@option_3.label],
        2 => [@option_1.label],
        3 => [@option_2.label],
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

      expect(@list.rankings).to eq({
        1 => [@option_3.label],
        2 => [@option_1.label, @option_2.label],
      })
    end
  end

  describe "individual_rankings" do
    before do
      @user = FactoryBot.create(:user, :name => "User 1")
      @list = FactoryBot.create(:list)
      @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
      @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
      @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
    end

    it "returns individual rankings" do
      other_user = FactoryBot.create(:user, :name => "User 2")
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

      expect(@list.individual_rankings).to eq({
        "User 1" => {1 => ["Pizza"], 2 => ["Tacos"], 3 => ["Thai"]},
        "User 2" => {1 => ["Pizza"], 2 => ["Tacos"], 3 => ["Thai"]},
      })
    end
  end

  describe "narrative_for_user" do
    before do
      @list = FactoryBot.create(:list)
      @user = FactoryBot.create(:user, :name => "User 1")
      @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
      @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
      @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
    end

    it "returns rankings when a user has completed all the face offs" do
      other_user = FactoryBot.create(:user, :name => "User 2")
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_3)
      FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)
      FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

      expect(@list.narrative_for_user).to eq([
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

      expect(@list.completed_voting_count).to eq(1)
    end
  end
end
