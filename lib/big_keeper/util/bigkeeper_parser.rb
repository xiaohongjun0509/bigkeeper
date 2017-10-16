# Bigkeeper module
module BigKeeper
  def self.version(name)
    BigkeeperParser.parse_version(name)
  end

  def self.user(name)
    BigkeeperParser.parse_user(name)
    yield if block_given?
  end

  def self.home(name, params)
    BigkeeperParser.parse_home(name, params)
  end

  def self.pod(name, params)
    BigkeeperParser.parse_pod(name, params)
  end

  def self.modules
    BigkeeperParser.parse_modules
    yield if block_given?
  end

  # Bigkeeper file parser
  class BigkeeperParser
    @@config = {}
    @@current_user = ''

    def self.parse(bigkeeper)
      if @@config.empty?
        content = File.read bigkeeper

        content.gsub!(/version\s/, 'BigKeeper::version ')
        content.gsub!(/user\s/, 'BigKeeper::user ')
        content.gsub!(/home\s/, 'BigKeeper::home ')
        content.gsub!(/pod\s/, 'BigKeeper::pod ')
        content.gsub!(/modules\s/, 'BigKeeper::modules ')
        eval content
        # p @@config
      end
    end

    def self.parse_version(name)
      @@config[:version] = name
    end

    def self.parse_user(name)
      @@current_user = name
      users = @@config[:users]
      users = {} if users.nil?
      users[name] = {}
      @@config[:users] = users
    end

    def self.parse_home(name, params)
      @@config[:home] = params
      @@config[:name] = name
    end

    def self.parse_pod(name, params)
      if params[:path]
        parse_user_pod(name, params)
      elsif params[:git]
        parse_modules_pod(name, params)
      else
        raise %(There should be ':path =>' or ':git =>' for pod #{name})
      end
    end

    def self.parse_user_pod(name, params)
      users = @@config[:users]
      user = users[@@current_user]
      pods = user[:pods]
      pods = {} if pods.nil?
      pods[name] = params
      user[:pods] = pods
      @@config[:users] = users
    end

    def self.parse_modules_pod(name, params)
      modules = @@config[:modules]
      modules[name] = params
      @@config[:modules] = modules
    end

    def self.parse_modules
      modules = @@config[:modules]
      modules = {} if modules.nil?
      @@config[:modules] = modules
    end

    def self.version
      @@config[:version]
    end

    def self.home_name
      @@config[:name]
    end

    def self.home_git()
      @@config[:home][:git]
    end

    def self.home_pulls()
      @@config[:home][:pulls]
    end

    def self.module_path(user_name, module_name)
      user_name.empty? ? "../#{module_name}" : @@config[:users][user_name][:pods][module_name][:path]
    end

    def self.module_git(module_name)
      @@config[:modules][module_name][:git]
    end

    def self.module_pulls(module_name)
      @@config[:modules][module_name][:pulls]
    end

    def self.module_names
      @@config[:modules].keys
    end

    def self.config
      @@config
    end
  end

  # BigkeeperParser.parse('/Users/mmoaay/Documents/eleme/BigKeeperMain/Bigkeeper')
  # BigkeeperParser.parse('/Users/mmoaay/Documents/eleme/BigKeeperMain/Bigkeeper')
  #
  # p BigkeeperParser.home_git()
  # p BigkeeperParser.home_pulls()
  # p BigkeeperParser.module_path('perry', 'BigKeeperModular')
  # p BigkeeperParser.module_path('', 'BigKeeperModular')
  # p BigkeeperParser.module_git('BigKeeperModular')
  # pulls = BigkeeperParser.module_pulls('BigKeeperModular')
  # `open #{pulls}`
  # p BigkeeperParser.module_names
end