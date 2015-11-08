module ReactOnRails
  module TaskHelpers
    # Returns the root folder of the react_on_rails gem
    def gem_root
      File.expand_path("../../.", __FILE__)
    end

    # Returns the folder where examples are located
    def examples_dir
      File.join(gem_root, "examples")
    end

    # Executes a string of shell commands, one on each line, one at a time
    # after first "cd"ing into the specified directory.
    def sh_in_dir(dir, shell_commands)
      shell_commands.each_line { |shell_command| sh %(cd #{dir} && #{shell_command.strip}) }
    end
  end
end
