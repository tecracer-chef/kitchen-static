notification :terminal_title, display_message: true

guard :shell do
  watch(/\.rb$/) { `rake install:local` }
end
