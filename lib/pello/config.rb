module Pello
  class Config
    CONFIG_FILE_PATH = "#{ENV['HOME']}/.config/pello/pello.yaml".freeze
    attr_accessor :board_url, :developer_public_key, :list_name, :log_file, :member_token, :username

    def initialize
      config = YAML.safe_load File.open(CONFIG_FILE_PATH).read

      auth_config           = config['auth']
      @developer_public_key = auth_config['developer_public_key']
      @member_token         = auth_config['member_token']

      pello_config          = config['config']
      @username             = pello_config['username']
      @board_url            = pello_config['board_url']
      @list_name            = pello_config['list_name']
      @log_file             = pello_config['log_file']
    end
  end
end
