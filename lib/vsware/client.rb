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
      define_method resource do |options = {}|
        resource = resource.tr("_", "/")
        response = http_get_request(resource, params: options, path_append: "/fetch")

        handle_response(response)
      end
    end

    def student_images(options = {})
      response = http_get_request(
        "students/images",
        params: options
      )
      handle_response(response)
    end

    def teacher_images(options = {})
      response = http_get_request(
        "teachers/images",
        params: options
      )
      handle_response(response)
    end

    def student_image(options = {})
      response = http_get_request(
        "studentimages",
        params: options,
        path_append: "/fetch/#{options.delete(:student_id)}"
      )

      handle_response(response)
    end

    private
    def http_get_request path, options = {}
      options[:path_append] ||= ""

      auth_params = {
        apikey: @api_key,
        password: @password,
        username: @user,
        vendor: @vendor
      }

      Excon.get("#{@url}#{path}#{options[:path_append]}?#{URI.encode_www_form(auth_params.merge(options[:params]))}")
    end

    def handle_response(response)
      case response.status
      when 200
        # puts resource
        response = JSON.parse(response.body)
        raise "#{response["errorMessage"]}" if response["errorMessage"]

        response["payload"]
      when 404
        raise "not found"
      end
    end
  end
end
