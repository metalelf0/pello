module Pello
  class Config
    CONFIG_FILE_PATH = "#{ENV['HOME']}/.config/pello/pello.yaml".freeze
    attr_accessor :user, :board_url, :list_name, :log_file

    def initialize
      config         = YAML.safe_load File.open(CONFIG_FILE_PATH).read
      authentication = config['auth']
      pello_config   = config['config']

      Trello.configure do |trello_config|
        trello_config.developer_public_key = authentication['developer_public_key']
        trello_config.member_token = authentication['member_token']
      end

      @user = Trello::Member.find pello_config['username']
      @board_url = pello_config['board_url']
      @list_name = pello_config['list_name']
      @log_file  = pello_config['log_file']
    end
  end
end
