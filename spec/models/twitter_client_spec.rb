require 'rails_helper'

describe TwitterClient do
  describe '#remove_duplication' do
    subject { client.remove_processed(my_id, ids) }
    let(:client){ TwitterClient.new }
    let!(:processed){ create(:processed_id, client_id: my_id, target_id: target_id) }
    let(:my_id){ 1 }
    let(:target_id){ 100 }
    let(:ids){ [100, 101, 102] }

    it '既に登録済みのidは除外されること' do
      expect(subject).to eq [101, 102]
    end
  end
end
