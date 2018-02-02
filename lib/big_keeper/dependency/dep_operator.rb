module BigKeeper
  # Operator for podfile
  class DepOperator
    @path

    def initialize(path)
      @path = path
    end

    def backup
      raise "You should override this method in subclass."
    end

    def recover
      raise "You should override this method in subclass."
    end

    def modules_with_branch(modules, branch_name)
      raise "You should override this method in subclass."
    end

    def modules_with_type(modules, module_type)
      raise "You should override this method in subclass."
    end

    def update_module_config(module_name, module_type, source)
      raise "You should override this method in subclass."
    end

    def install(should_update, user)
      raise "You should override this method in subclass."
    end

    def open
      raise "You should override this method in subclass."
    end
  end
end