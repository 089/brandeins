require 'stringio'

module Kernel
  def capture_stdout
    orig_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = orig_stdout
  end
end
