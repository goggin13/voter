require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /lists" do
    it "works! (now write some real specs)" do
      get lists_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /lists" do
    it "creates a list with options" do
      post lists_path(:format => :json), :params => {
        :list => {
          :name => "my list",
          :options => [
            {:label => "option 1"},
            {:label => "option 2"},
          ]
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
            :options => [
              {:label => "option 1"},
              {:label => "option 2"},
              {:label => "option 3"},
            ],
          }
        }

        expect(response).to have_http_status(201)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["face_offs"].length).to eq(3)
        expect(parsed_response["face_offs"].to eq([

        ])
      end

      it "doesn't return already completed faceoffs" do
        session_id = "abc"
        post lists_path(:format => :json), :params => {
          :list => {
            :name => "my list",
            :options => [
              {:label => "option 1"},
              {:label => "option 2"},
              {:label => "option 3"},
            ],
          },
          :session_id => session_id
        }

        expect(response).to have_http_status(201)
        parsed_response = JSON.parse(response.body)
        winner_id = parsed_response["options"][0]["id"]
        loser_id = parsed_response["options"][0]["id"]

        post list_face_off_path(List.last!, :format => :json), :params => {
          :face_off => {
            :winner_id => winner_id,
            :loser_id => loser_id,
          },
          :session_id => session_id
        }

        expect(response).to have_http_status(201)

        get lists_path(:format => :json), :params => {:session_id => session_id}
        expect(response).to have_http_status(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["face_offs"]).to eq(2)
      end
    end
  end
end
