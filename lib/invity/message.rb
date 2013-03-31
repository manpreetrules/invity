module Invity
  module Facebook
    class Message
      attr_accessor :sender, :reciever, :recievers, :subject, :body, :access_token

      def initialize(options = {})
        [:sender, :recievers, :subject, :body, :access_token].each { |w|
          send("#{w}=", options[w])
        }
      end

      def perform # SPECIAL METHOD USED BY DELAYED-JOBS
        chat
      end

      def deliver(opt = nil)
        case opt
          when :all         then deliver_all
          when :all_delayed then deliver_all_as_delayed
          when :delayed     then deliver_as_delayed
          else; deliver_each
        end
      end

      def deliver_all
        friends.each { |f|
          self.reciever = f; chat
        }
      end

      def deliver_all_as_delayed
        friends.each { |f|
          self.reciever = f
          Delayed::Job.enqueue self
        }
      end

      def deliver_as_delayed
        recievers.each { |f|
          self.reciever = f
          Delayed::Job.enqueue self
        }
      end

      def deliver_each
        recievers.each { |f|
          self.reciever = f; chat
        }
      end

      private #--------------------------------------------

      def friends
        @friends ||= Invity::Facebook::API.new( access_token ).friend_ids
      end

      def chat
        id = "-#{sender}@chat.facebook.com"
        to = "-#{reciever}@chat.facebook.com"

        message = Jabber::Message.new to, body
        message.subject = subject
      
        client = Jabber::Client.new Jabber::JID.new(id)
        client.connect
        client.auth_sasl( authenticate(client), nil)
        client.send message
        client.close
      end

      def authenticate(client)
        Jabber::SASL::XFacebookPlatform.new(client,
          ENV.fetch('FACEBOOK_APP_ID'), access_token, ENV.fetch('FACEBOOK_APP_SECRET')
        )
      end
    end
  end
end