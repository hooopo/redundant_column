# RedundantColumn

Auto maintain the consistency of redundant column.

1. Auto update redundant column.
2. Auto fill redundant column value from redundant target object.

## Installation

Add this line to your application's Gemfile:

    gem 'redundant_column'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redundant_column

## Usage

    class User < ActiveRecord::Base
      has_many :topics, :redundant_column => {:status => :user_status}
    end

    class Topic < ActiveRecord::Base
      belongs_to :user, :redundant_column => {:user_status => :status}
    end

    user = User.create(:name => "Hooopo", :status => "active")

    topic = Topic.create(:user => user, :title => "this is title")

    assert_equal topic.status_name, user.status

    user.status = "disable"
    user.save

    topic.reload

    assert_equal topic.user_status, user.status

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
