# Kushojin [![Build Status](https://travis-ci.org/nowlinuxing/kushojin.svg?branch=master)](https://travis-ci.org/nowlinuxing/kushojin.svg?branch=master)

Kushojin aims to record changed attributes of ActiveRecord model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kushojin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kushojin

## Usage

```ruby
Kushojin::Config.logger = Fluent::Logger::FluentLogger.new(nil, host: "localhost", port: 24224)

class User < ApplicationRecord
  record_changes
end

class UsersController < ApplicationController
  send_changes

  def create
    User.create(params[:user])
  end
end
```

    $ curl -X POST -d "user[name]=bill&user[age]=20" http://localhost:3000/users
    # output: users.create {"event":"create","request_id":"4afd0731-dd25-4668-b769-2017dbdd3642","table_name":"users","id":1,"changes":{"name":[null,"bill"],"age":[null,20]}}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nowlinuxing/kushojin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

