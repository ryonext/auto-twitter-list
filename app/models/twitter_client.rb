class TwitterClient
  include ActiveModel::Model
  attr_accessor :consumer_key, :consumer_secret, :access_token, :access_token_secret

  def update_list!
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = self.consumer_key
      config.consumer_secret     = self.consumer_secret
      config.access_token        = self.access_token
      config.access_token_secret = self.access_token_secret
    end
    my_id = client.user.id
    friend_ids = client.friends.take(20).map(&:id)
    # ここに、既に登録済みのユーザを外す処理を書く
    new_ids = remove_processed(my_id, friend_ids)
    client.add_list_members('Recent', new_ids)
    register_new_ids(my_id, new_ids)
  end

  def remove_processed(my_id, ids)
    processed_ids = ProcessedId.where(client_id: my_id, target_id: ids).pluck(:target_id)
    ids.map {|id|
      (id.in? processed_ids) ? nil : id
    }.compact
  end

  def register_new_ids(my_id, ids)
    records = ids.map do |id|
      ProcessedId.new(client_id: my_id, target_id: id)
    end
    ProcessedId.import records
  end
end
