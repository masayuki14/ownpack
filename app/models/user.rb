class User < ActiveRecord::Base
  attr_accessible :mail, :name, :twitter_uid, :twitter_name, :twitter_screen_name
  has_many :recipes

  # OAuth 認証のデータを使ってアカウントデータを作成する
  def self.create_with_omniauth(auth)
    create! do |user|
      if auth['provider'] == 'twitter'
        user.twitter_uid = auth['uid']
        user.twitter_name = auth['info']['name']
        user.twitter_screen_name = auth['info']['nickname']
      end
    end
  end
end
