module Invity
  module Facebook
    class API
      GraphUrl = 'https://graph.facebook.com'
      attr_reader :access_token
      attr_accessor :fields

      def initialize(access_token = nil)
        @access_token = access_token
      end

      def friends
        self.fields = 'fields=id,name'
        @friends ||= response
      end

      def friends_with_pics
        self.fields = 'fields=id,name,picture.type(small)'
        @friends_with_pics ||= response
      end

      def friend_ids
        @friend_ids ||= friends.map { |f| f['id'] }
      end
      
      private #-----------------------------------------------------
      
      def api
        @api ||=
        Faraday.new(:url => GraphUrl) do |f|
          f.request  :url_encoded
          f.response :logger
          f.adapter  Faraday.default_adapter
        end
      end

      def prepare_url
        "/me/friends?#{fields}&access_token=#{access_token}"
      end

      def response
        raise request.headers['www-authenticate'] if request.status != 200
        JSON.parse( (request).body )['data']
      end

      def request
        @request ||= api.get prepare_url
      end
    end
  end
end