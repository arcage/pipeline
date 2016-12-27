# Pipeline Command for Crystal

Line by line text processor for console command mainly using with pipes('|').

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pipeline:
    github: arcage/pipeline
```

## Usage

Inherit the `Pipeline::Command` class and implement `#proc(line : String)` method on it.

```crystal
# up_case.cr
require "pipeline"

class UpCase < Pipeline::Command

  def proc(line : String)
    line.upcase
  end

end

UpCase.new.run
```

```shell
% crystal up_case.cr
abc def  <- INPUT
ABC DEF  <- OUTPUT
% cat input.txt
input text file
% crystal up_case.cr -- input.txt
INPUT TEXT FILE
```

Default input and ouput are `ARGF` and `STDOUT` respectivery.

You can specify other input or output by calling '#run' method with `input` or `output` argument.

```crystal
File.open("input.txt") do |file|
  UpCase.new.run(input: file)
end

#output: INPUT TEXT FILE
```

Override `#initialize()` and call `super(&block)`, then you can set flags for the internal `OptionParser` object in the block.

```crystal
# up_or_camel_case.cr
require "pipeline"

class UpOrCamelCase < Pipeline::Command

  def initialize
    @camelcase = false
    super() do
      # Default receiver in this block is the internal OpttionParser object.
      on("-c", "camel case") { @camelcase = true }
    end
  end

  def proc(line : String) : String
    @camelcase ? line.camelcase : line.upcase
  end

end

UpOrCamelCase.new.run
```

```shell
% crystal up_or_camel_case.cr
abc def  <- INPUT
ABC DEF  <- OUTPUT
^D
% crystal up_or_camel_case.cr -- -c
abc def  <- INPUT
AbcDef   <- OUTPUT
^D
```


## Contributors

- [arcage](https://github.com/arcage) ʕ·ᴥ·ʔAKJ - creator, maintainer
