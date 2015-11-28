require 'nokogiri'

module Lita
  module Handlers
    class Toutiao < Handler

      route(/toutiao/, :fetch_toutiao, command: true, help: {
        "toutiao" => "Display develop posts from toutiao.io"
      })

      def fetch_toutiao response
        posts = redis.get(key_of_today)
        posts = access_api unless posts
        response.reply posts
      end

      def key_of_today
        'toutiao_' + Time.now.strftime('%Y-%m-%d')
      end

      def access_api
        url = 'http://toutiao.io/'
        res = http.get url
        content = parse_data(res.body)
        redis.set(key_of_today, content) 
        content
      end

      def parse_data(html)
        posts = []
        doc = ::Nokogiri::HTML(html)
        doc.css('.daily .title > a').each_with_index do |post, index|
          posts << "#{index + 1}.#{post.text.strip}: (#{post[:href]})"
        end
        posts.join("\n")
      end

      Lita.register_handler(self)
    end
  end
end
