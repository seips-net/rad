require 'ruby_to_ansi_c'

C_VAR_TYPES = "unsigned|int|long|double|str|char|byte|bool"

# incredibly primitive tests 
# rake test:compile or rake test:upload
# runs through all sketches in the example directory

def run_tests(sketch, type)
  sh %{rake make:#{type} sketch=examples/#{sketch}}
end

#yoinked from Rails
def constantize(camel_cased_word)
  unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
    raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
  end

  Object.module_eval("::#{$1}", __FILE__, __LINE__)
end