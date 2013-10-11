require "faraday"
require "json"

module Searchupc
  class Client
    API_BASE = "http://www.searchupc.com"

    def initialize(api_token)
      @api_token = api_token
    end

    def search(upc)
      JSON.parse(request(request_type: 3, upc: upc))
    end

    def valid_code?(upc)
      request(request_type: 2, upc: upc) == "True"
    end

    private

    def request(params={})
      params[:access_token] = @api_token
      response = Faraday.get("#{API_BASE}/handlers/upcsearch.ashx", params)

      if response.body =~ /Invalid Access Token/i
        raise Searchupc::Error, "Invalid access token"
      end

      response.body
    end
  end
end