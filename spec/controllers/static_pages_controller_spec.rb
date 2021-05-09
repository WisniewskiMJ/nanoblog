require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    before :each do
      get :home
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders home template" do
      expect(response).to render_template(:home)
    end
  end

  describe "GET #about" do
    before :each do
      get :about
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end 

    it "renders contact template" do
      expect(response).to render_template(:about)
    end
  end

  describe "GET #contact" do
    before :each do
      get :contact
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders contact template" do
      expect(response).to render_template(:contact)
    end
  end

end
