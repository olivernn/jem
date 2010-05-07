module Jem
  class Push
    PATH = '/api/projects'

    attr_reader :auth, :project

    def initialize(auth, project)
      @auth = auth
      @project = project
    end

    def push
      RestClient.put "#{Jem::HOST}#{PATH}?#{signature_querystring}",
        request_body.merge(:multipart => true)
    rescue RestClient::Unauthorized => e
      raise Jem::WrongCredentials, e.response.body
    end

    private
      def request_body
        {
          :manifest => project.manifest,
          :file => project.file
        }
      end

      def signature_querystring
        token = Signature::Token.new(auth.key, auth.secret)
        request = Signature::Request.new('PUT', PATH, {})
        auth_hash = request.sign(token)

        auth_hash.keys.inject([]) do |array, key|
          array << "#{URI.encode(key.to_s)}=#{URI.encode(auth_hash[key].to_s)}"
        end.join('&')
      end
  end
end
