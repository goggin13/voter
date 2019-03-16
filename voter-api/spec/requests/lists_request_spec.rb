require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /lists" do
    context "completed by the current user" do
      before do
        @session_id = "abc"
        @user = FactoryBot.create(:user, :session_id => @session_id, :name => "abc")
        @list = FactoryBot.create(:list)
        @option_1 = FactoryBot.create(:option, :list => @list, :label => "Pizza")
        @option_2 = FactoryBot.create(:option, :list => @list, :label => "Tacos")
        @option_3 = FactoryBot.create(:option, :list => @list, :label => "Thai")
        FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_2)
        FactoryBot.create(:face_off, :user => @user, :winner => @option_1, :loser => @option_3)
        FactoryBot.create(:face_off, :user => @user, :winner => @option_2, :loser => @option_3)
      end

      it "returns rankings when a user has completed all the face offs" do
        get list_path(id: @list.id, :format => :json), :params => {:session_id => @session_id}
        expect(response).to have_http_status(200)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["face_offs"].length).to eq(0)

        expect(parsed_response["rankings"]).to eq({
          "1" => ["Pizza"],
          "2" => ["Tacos"],
          "3" => ["Thai"],
        })
      end

      it "returns descriptions for everyone votes when a user has completed all the face offs" do
        other_user = FactoryBot.create(:user, :name => "User 2")
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_3)
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

        get list_path(id: @list.id, :format => :json), :params => {:session_id => @session_id}
        expect(response).to have_http_status(200)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["narrative"]).to eq([
          "#{@session_id} chose Pizza over Tacos",
          "#{@session_id} chose Pizza over Thai",
          "#{@session_id} chose Tacos over Thai",
          "User 2 chose Pizza over Tacos",
          "User 2 chose Pizza over Thai",
          "User 2 chose Tacos over Thai",
        ])
      end

      it "returns the number of people who have completed voting" do
        other_user = FactoryBot.create(:user, :name => "User 2")
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)

        get list_path(id: @list.id, :format => :json), :params => {:session_id => @session_id}
        expect(response).to have_http_status(200)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["completed_voting_count"]).to eq(1)
      end

      it "returns each users individual rankings" do
        other_user = FactoryBot.create(:user, :name => "User 2")
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_2)
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_1, :loser => @option_3)
        FactoryBot.create(:face_off, :user => other_user, :winner => @option_2, :loser => @option_3)

        get list_path(id: @list.id, :format => :json), :params => {:session_id => @session_id}
        expect(response).to have_http_status(200)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["individual_rankings"]).to eq({
          @session_id => {"1" => ["Pizza"], "2" => ["Tacos"], "3" => ["Thai"]},
          "User 2" => {"1" => ["Pizza"], "2" => ["Tacos"], "3" => ["Thai"]},
        })
      end
    end
  end

  describe "POST /lists" do
    it "creates a list with options" do
      post lists_path(:format => :json), :params => {
        :list => {
          :name => "my list",
          :options => {
            "1" => {:label => "option 1"},
            "2" => {:label => "option 2"},
          }
        }
      }

      expect(response).to have_http_status(201)

      # verify that the DB matches
      list = List.where(:name => "my list").first!
      expect(list.options.length).to eq(2)
      expect(list.options.map(&:label)).to eq(["option 1", "option 2"])

      # verify that the response we are returning has the data the client will need
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["name"]).to eq("my list")
      expect(parsed_response["options"].length).to eq(2)
      expect(parsed_response["options"][0]["label"]).to eq("option 1")
      expect(parsed_response["options"][1]["label"]).to eq("option 2")
    end

    describe "faceoffs" do
      it "returns the faceoffs required for the user" do
        post lists_path(:format => :json), :params => {
          :list => {
            :name => "my list",
            :options => {
              "1" => {:label => "option 1"},
              "2" => {:label => "option 2"},
              "3" => {:label => "option 3"},
            },
          }
        }

        expect(response).to have_http_status(201)

        option_1 = Option.where(:label => "option 1").first!
        option_2 = Option.where(:label => "option 2").first!
        option_3 = Option.where(:label => "option 3").first!

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["face_offs"].length).to eq(3)
        expected = [
          [
            {"label" => "option 1", "id" => option_1.id},
            {"label" => "option 2", "id" => option_2.id},
          ],
          [
            {"label" => "option 1", "id" => option_1.id},
            {"label" => "option 3", "id" => option_3.id},
          ],
          [
            {"label" => "option 2", "id" => option_2.id},
            {"label" => "option 3", "id" => option_3.id},
          ],
        ]
        expect(parsed_response["face_offs"]).to eq(expected)
      end

      it "doesn't return already completed faceoffs" do
        session_id = "abc"
        post lists_path(:format => :json), :params => {
          :list => {
            :name => "my list",
            :options => {
              "1" => {:label => "option 1"},
              "2" => {:label => "option 2"},
              "3" => {:label => "option 3"},
            },
          },
          :session_id => session_id
        }

        expect(response).to have_http_status(201)
        parsed_response = JSON.parse(response.body)
        list_id = parsed_response["id"]
        winner_id = parsed_response["options"][0]["id"]
        loser_id = parsed_response["options"][1]["id"]

        post face_offs_path(:format => :json), :params => {
          :face_off => {
            :winner_id => winner_id,
            :loser_id => loser_id,
          },
          :session_id => session_id
        }

        expect(response).to have_http_status(201)

        get list_path(id: list_id, :format => :json), :params => {:session_id => session_id}
        expect(response).to have_http_status(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["face_offs"].length).to eq(2)
      end
    end
  end
end
