#!/usr/bin/env ruby
file = ARGV[0]
if File.exist?(file)
	IO.foreach(file) {|line| 
	token = line.scan(/(\[from:.*?\])|(\[to:.*?\])|(\[flags:.*?\])/).join
	token_array = token.split(/:/)
	puts "#{token_array[1].delete("][to")},#{token_array[2].delete("][flags")},#{token_array[3]}:#{token_array[4]}:#{token_array[5]}:#{token_array[6]}:#{token_array[7].delete("]")}"
	}
else
	token = file.scan(/(\[from:.*?\])|(\[to:.*?\])|(\[flags:.*?\])/).join
	token_array = token.split(/:/)
	puts "#{token_array[1].delete("][to")},#{token_array[2].delete("][flags")},#{token_array[3]}:#{token_array[4]}:#{token_array[5]}:#{token_array[6]}:#{token_array[7].delete("]")}"
end
