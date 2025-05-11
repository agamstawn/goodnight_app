require 'rails_helper'

RSpec.describe Api::V1::FollowsController, type: :controller do
  let(:follower) { User.create(name: "Goku") }
  let(:followed) { User.create(name: "Gohan") }

  describe "POST #create" do
    context "when following a user" do
      before do
        post :create, params: { follower_id: follower.id, followed_id: followed.id }
        follower.reload
      end

      it "returns a success message" do
        expect(JSON.parse(response.body)["message"]).to eq("Now following #{followed.name}")
      end

      it "returns a 200 status" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #destroy" do
  context "when unfollowing a user" do
    before do
      Follow.create!(follower: follower, followed: followed)
      delete :destroy, params: { follower_id: follower.id, followed_id: followed.id }, as: :json
      follower.reload
    end

    it "returns a success message" do
      expect(JSON.parse(response.body)["message"]).to eq("Unfollowed #{followed.name}")
    end

    it "returns a 200 status" do
      expect(response).to have_http_status(:ok)
    end
  end
  
end


end
