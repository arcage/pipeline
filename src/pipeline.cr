require "option_parser"

require "./pipeline/*"

module Pipeline
  abstract class Command
    @option_parser : OptionParser

    # Creates a new command object.
    #
    # If you want to override or overload `#initialize` method, you must call `super(&block)` to set flags for the internal option parser object in it, even when no flag will be set.
    def initialize
      initialize { }
    end

    # :nodoc:
    private def initialize(&block)
      @option_parser = OptionParser.new
      with @option_parser yield
      @option_parser.parse!
    end

    # Activates command.
    #
    # This read each line from `input` and puts to `output` after convertting it with `#proc`.
    def run(input : IO = ARGF, output : IO = STDOUT, chomp : Bool = true)
      input.each_line(chomp: chomp) do |line|
        output.puts proc(line)
      end
    end

    # Converts single line string.
    #
    # This method will be called from `#run` method for each line from input IO.
    abstract def proc(line : String)
  end
end
