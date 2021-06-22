shared_examples_for 'an action requiring logged in user' do |action|
  let(:example_user) { FactoryBot.create(:user) }
  before :each do
    logout
  end

  context 'user is logged in' do
    before do
      login(example_user)
      call_action(action, parameters)
    end
    it 'does not display not logged in warning message' do
      expect(flash[:danger]).not_to eq('You have to be logged in to perform this action')
    end
  end

  context 'no user is logged in' do
    before do
      call_action(action, parameters)
    end
    it 'displays not logged in warning message' do
      expect(flash[:danger]).to eq('You have to be logged in to perform this action')
    end
  end
end

shared_examples_for 'an action requiring no logged in user' do |action|
  let(:example_user) { FactoryBot.create(:user) }

  context 'no user is logged in' do
    before do
      call_action(action, parameters)
    end
    it 'does not display logged in warning message' do
      expect(flash[:danger]).not_to eq('You can not perform this action while logged in')
    end
  end

  context 'user is logged in' do
    before do
      login(example_user)
      call_action(action, parameters)
    end
    it 'displays logged in warning message' do
      expect(flash[:danger]).to eq('You can not perform this action while logged in')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end
end

shared_examples_for 'an action requiring owner logged in' do |action|
  let(:another_user) { FactoryBot.create(:user) }

  context 'no user is logged in' do
    before do
      logout
      call_action(action, parameters)
    end
    it 'displays not logged in warning message' do
      expect(flash[:danger]).to eq('You have to be logged in to perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'another user is logged in' do
    before do
      login(another_user)
      call_action(action, parameters)
    end
    it 'displays not an owner logged in warning message' do
      expect(flash[:danger]).to eq('Only owner of the account can perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'account owner is logged in' do
    before do
      login(owner)
      call_action(action, parameters)
    end
    it 'does not display not an owner logged in warning message' do
      expect(flash[:danger]).not_to eq('Only owner of the account can perform this action')
    end
  end
end

shared_examples_for 'an action requiring admin logged in' do |action|
  let(:example_user) { FactoryBot.create(:user) }

  context 'no user is logged in' do
    before do
      logout
      call_action(action, parameters)
    end
    it 'displays not logged in warning message' do
      expect(flash[:danger]).to eq('You have to be logged in to perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'no admin user is logged in' do
    before do
      login(example_user)
      call_action(action, parameters)
    end
    it 'displays warning message' do
      expect(flash[:danger]).to eq('You can not perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'admin user is logged in' do
    before do
      example_user.update(admin: true)
      login(example_user)
      call_action(action, parameters)
    end
    it 'does not display warning message' do
      expect(flash[:danger]).not_to eq('You can not perform this action')
    end
  end
end

shared_examples_for 'an action requiring owner or admin logged in' do |action|
  let(:example_user) { FactoryBot.create(:user) }

  context 'no user is logged in' do
    before do
      logout
      call_action(action, parameters)
    end
    it 'displays not logged in warning message' do
      expect(flash[:danger]).to eq('You have to be logged in to perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'no owner or admin user is logged in' do
    before do
      login(example_user)
      call_action(action, parameters)
    end
    it 'displays warning message' do
      expect(flash[:danger]).to eq('Only owner of the account can perform this action')
    end
    it 'redirects to home page' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'account owner is logged in' do
    before do
      login(owner)
      call_action(action, owner_parameters)
    end
    it 'does not display warning message' do
      expect(flash[:danger]).not_to eq('Only owner of the account can perform this action')
    end
  end

  context 'admin user is logged in' do
    before do
      example_user.update(admin: true)
      login(example_user)
      call_action(action, parameters)
    end
    it 'does not display warning message' do
      expect(flash[:danger]).not_to eq('You can not perform this action')
    end
  end
end
