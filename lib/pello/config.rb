module Pello
  class Config
    CONFIG_FILE_PATH = "#{ENV['HOME']}/.config/pello/pello.yaml".freeze
    attr_accessor :board_url, :developer_public_key, :list_name, :member_token, :username, :error

    def initialize
      if File.exist?(CONFIG_FILE_PATH)
        config = YAML.safe_load File.open(CONFIG_FILE_PATH).read

        auth_config           = config['auth']
        @developer_public_key = auth_config['developer_public_key']
        @member_token         = auth_config['member_token']

        pello_config          = config['config']
        @username             = pello_config['username']
        @board_url            = pello_config['board_url']
        @list_name            = pello_config['list_name']
        @error                = false
      else
        @error = true
      end
    rescue => e
      @error = true
      puts "Error loading config: #{e.message}"
    end

    def valid?
      !error
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
      end
    end
  end
end
