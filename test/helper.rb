require 'stringio'

module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end

# Use capture_stdout like this:
# out = capture_stdout do
#   execute_code_that_puts 'some string'
# end
# assert_equal "some string", out.string
# http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/