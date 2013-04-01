Invity
---
#### Send messages to Facebook Inbox with your rails app.

[ demo ](http://invity.herokuapp.com) --
[demo source](https://github.com/pavittar/invity_demo)

Installation
---
Add this line to your application's Gemfile:

    gem 'invity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invity

## Usage

### Requirements:
1. xmpp_login ( facebook permissions )
2. ENV['FACEBOOK\_APP\_ID']
3. ENV['FACEBOOK\_APP\_SECRET']

### eg:
using [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook)

In `config/initializer/omniauth.rb`

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :facebook, ENV['FACEBOOK_APP_ID'],  ENV['FACEBOOK_APP_SECRET'], scope: "email, xmpp_login"
    end

Controller
---
 
    @invitation = Invity::Facebook::API.new( access_token )
    
    @friends = @invitation.friends
    or
    @friends = @invitation.friends_with_pics
    or
    @friends = @invitation.friend_ids

Send Message
---
- access_token == facebook access\_token  from [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook) 
- sender  == user uid from [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook)
- recievers == Array of friends ids
- invitation == should be string 
- body  == should be string eg: `"#{Time.now}"`


---
    Invity::Facebook::Message.new(
      access_token: access_token,
      sender: uid,
      recievers: friends,
      subject: 'Invitation',
      body: "You have been invited to join http://www.example.com"
    ).deliver

### Available methods:

    deliver                  == deliver to each passed recievers
    deliver(:delayed)        == support delayed_job gem - send as background task
    deliver(:all)            == deliver to all friends regardless of passed recievers
    deliver(:all_delayed)    == deliver to all with delayed_job gem

#### [delayed_job](https://github.com/tobi/delayed_job) gem needed for these methods:

    deliver(:delayed)
    deliver(:all_delayed) 

[ demo ](http://invity.herokuapp.com) --
[demo source](https://github.com/pavittar/invity_demo)