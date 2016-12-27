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
    # This reads each line from `input` and converts it with `#proc`.
    # When converted line is not `nil`, it will be put to `output`.
    def run(input : IO = ARGF, output : IO = STDOUT, chomp : Bool = true)
      input.each_line(chomp: chomp) do |line|
        unless (converted_line = proc(line)).nil?
          output.puts converted_line
        end
      end
    end

    # Converts single line string.
    #
    # This method will be called from `#run` method for each line from input IO.
    #
    abstract def proc(line : String)
  end
end
