require "excon"
require "json"

module Vsware
  class Client
    def initialize(school_name, api_key, password, user, vendor)
      @url = "https://api.vsware.ie/api/200/#{school_name}/"
      @api_key = api_key
      @password = password
      @user = user
      @vendor = vendor
    end

    %w(
    student 
    classgroup
    registrationattendance 
    studentclasses 
    teachers 
    teachinggroup
    ).each do |resource|
      define_method resource do |options ={}|
        resource = resource.delete("_")
        response = http_get_request(resource, params: options)

        case response.status
        when 200
          response = JSON.parse(response.body)
          raise "#{response["errorMessage"]}" if response["errorMessage"]
          
          response["payload"]
        when 404
          raise "not found"
        end
      end
    end

    private
    def http_get_request path, options = {}
      auth_params = {
        apikey: @api_key,
        password: @password,
        username: @user,
        vendor: @vendor
      }
      Excon.get("#{@url}#{path}/fetch?#{URI.encode_www_form(auth_params.merge(options[:params]))}")
    end

  end
end
