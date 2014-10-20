module BaiduPush
  class Client
    API_HOST = 'channel.api.duapp.com'
    DEFAULT_RESOURCE = 'channel'

    DEFAULT_OPTIONS = {
      use_ssl: false,
      api_version: '2.0'
    }

    def self.config
      yield self
    end

    mattr_accessor :api_key, :secret_key, :deploy_status,:ios_cert_name, 
                   :ios_cert_desc, :ios_dev_cert, :ios_rel_cert
    attr_reader :api_url, :request, :options
    attr_accessor :resource

    def initialize(key=api_key, secret=secret_key, options = {})
      @@api_key, @@secret_key = (key || '').strip, (secret || '').strip
      @options = DEFAULT_OPTIONS.merge options

      set_api_url
      @resource ||= DEFAULT_RESOURCE
      @request = Request.new(self)
    end

    ###################################################
    # Basic API
    #
    def query_bindlist(params = {})
      @request.fetch(:query_bindlist, params)
    end

    def push_msg(push_type, messages, msg_keys, params = {})
      set_to_default_resource
      params.merge!({
        push_type: push_type,
        messages: messages.to_json,
        msg_keys: msg_keys,
        deploy_status: deploy_status
      })
      @request.fetch(:push_msg, params)
    end

    def init_app_ioscert(params = {})
      params.merge!({
        name: ios_cert_name,
        description: ios_cert_desc,
        release_cert: ios_rel_cert,
        dev_cert: ios_dev_cert
      })
      @request.fetch(:init_app_ioscert, params)
    end

    def update_app_ioscert(params = {})
      @request.fetch(:update_app_ioscert, params)
    end

    def delete_app_ioscert(params = {})
      @request.fetch(:delete_app_ioscert, params)
    end

    def query_app_ioscert(params = {})
      @request.fetch(:query_app_ioscert, params)
    end
    #
    # Basic API
    ###################################################

    ###################################################
    # Advanced API
    #
    def verify_bind(user_id, params = {})
      params.merge!({
        user_id: user_id
      })
      @request.fetch(:verify_bind, params)
    end

    def fetch_msg(user_id, params = {})
      params.merge!({
        user_id: user_id
      })
      @request.fetch(:fetch_msg, params)
    end

    def fetch_msgcount(user_id, params = {})
      params.merge!({
        user_id: user_id
      })
      @request.fetch(:fetch_msgcount, params)
    end

    def delete_msg(user_id, msg_ids, params = {})
      params.merge!({
        user_id: user_id,
        msg_ids: msg_ids.to_json
      })
      @request.fetch(:delete_msg, params)
    end

    def set_tag(tag, params = {})
      set_to_default_resource
      params.merge!({
        tag: tag
      })
      @request.fetch(:set_tag, params)
    end

    def fetch_tag(params = {})
      set_to_default_resource
      @request.fetch(:fetch_tag, params)
    end

    def delete_tag(tag, params = {})
      set_to_default_resource
      params.merge!({
        tag: tag
      })
      @request.fetch(:delete_tag, params)
    end

    def query_user_tags(user_id, params = {})
      set_to_default_resource
      params.merge!({
        user_id: user_id
      })
      @request.fetch(:query_user_tags, params)
    end

    def query_device_type(params = {})
      @request.fetch(:query_device_type, params)
    end
    #
    # Advanced API
    ###################################################

    private
    def set_api_url
      scheme = @options[:use_ssl] ? 'https' : 'http'
      @api_url = "#{scheme}://#{API_HOST}/rest/#{@options[:api_version]}/channel"
    end

    def set_to_default_resource
      @resource = DEFAULT_RESOURCE
    end
  end
end
