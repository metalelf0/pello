module Pello
  class Config
    CONFIG_FILE_PATH = "#{ENV['HOME']}/.config/pello/pello.yaml".freeze
    attr_accessor :board_url, :developer_public_key, :list_name, :log_file, :member_token, :username

    def initialize
      return nil unless File.exist?(CONFIG_FILE_PATH)

      config = YAML.safe_load File.open(CONFIG_FILE_PATH).read

      auth_config           = config['auth']
      @developer_public_key = auth_config['developer_public_key']
      @member_token         = auth_config['member_token']

      pello_config          = config['config']
      @username             = pello_config['username']
      @board_url            = pello_config['board_url']
      @list_name            = pello_config['list_name']
      @log_file             = pello_config['log_file']
    rescue => e
      puts "Error loading config: #{e.message}"
      nil
    end

    def self.write_empty_config
      system "mkdir -p #{File.dirname(CONFIG_FILE_PATH)}"
      File.open(CONFIG_FILE_PATH, 'w') do |file|
        file.puts 'auth:'
        file.puts '  developer_public_key: ""'
        file.puts '  member_token: ""'
        file.puts 'config:'
        file.puts '  board_url: ""'
        file.puts '  username: ""'
        file.puts '  list_name: "In progress"'
        file.puts '  log_file: "/Users/your_name/.pello_log"'
      end
    end
  end
end
