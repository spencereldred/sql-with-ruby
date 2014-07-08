require "yaml"
require "active_record"

class DatabaseConnection

  attr_reader :config, :connection
  private :config, :connection

  def initialize(environment = "development", config_file = "config/database.yml")
    @config = load_config(environment, config_file)
    @connection = establish_connection
  end

  def sql(sql_string)
    connection.execute(sql_string).to_a
  end

  class ConfigNotFoundError < RuntimeError ; end
  class EmptyConfigurationFileError < RuntimeError ; end
  class InvalidConfigurationFileError < RuntimeError ; end

  private

  def establish_connection
    ActiveRecord::Base.establish_connection(
      :adapter => config['adapter'],
      :database => config['database'],
      :username => config['username'],
      :password => config['password']
    ).connection
  end

  def load_config(environment, config_file)
    begin
      config = YAML.load(File.read(config_file))
      validate_config(config, environment)
    rescue Errno::ENOENT => e
      raise ConfigNotFoundError, "Please include your database config in #{config_file}"
    end
  end

  def validate_config(config, environment)
    if empty_config?(config)
      raise EmptyConfigurationFileError, "Your database.yml config is empty. Please " +
        "look at config/database.yml.example for what the config file should look like."
    elsif invalid_config?(config[environment])
      raise InvalidConfigurationFileError, "Your database.yml config does not have all " +
        "required values. Please look at config/database.yml.example for what the config file should look like."
    end

    config[environment]
  end

  def empty_config?(config)
    config == false
  end

  def invalid_config?(config)
    config == nil ||
      config.has_key?("adapter") == false ||
      config.has_key?("database") == false ||
      config.has_key?("username") == false ||
      config.has_key?("password") == false
  end
end
