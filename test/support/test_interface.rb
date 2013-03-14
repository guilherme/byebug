class TestInterface < Byebug::Interface
  attr_reader :input_queue, :output_queue, :error_queue, :confirm_queue

  attr_accessor :command_queue, :histfile, :history_length, :history_save
  attr_accessor :print_queue, :readline_support, :restart_file, :test_block

  def initialize
    @input_queue = []
    @output_queue = []
    @error_queue = []
    @confirm_queue = []
    @command_queue = []
    @print_queue = []
    @readline_support = false
  end

  def errmsg(*args)
    @error_queue << format(args)
  end

  def read_command(*args)
    if @input_queue.empty? && test_block
      test_block.call
      self.test_block = nil
    end
    result = @input_queue.shift
    result.is_a?(Proc) ? result.call : result
  end

  def print(*args)
    @output_queue << format(args)
  end

  def confirm(message)
    @confirm_queue << message
    read_command message
  end

  def readline_support?
    @readline_support
  end

  def finalize
  end

  def close
  end

  def inspect
    [
      "input_queue: #{input_queue.inspect}",
      "output_queue: #{output_queue.inspect}",
      "error_queue: #{error_queue.inspect}",
      "confirm_queue: #{confirm_queue.inspect}",
      "print_queue: #{print_queue.inspect}"
    ].join("\n")
  end

  private

    def format(args)
      if args.size > 1
        args.first % args[1..-1]
      else
        args.first
      end
    end
end