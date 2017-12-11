Thread.abort_on_exception =true

def every(seconds)
    Thread.new do
        sleep seconds
        yield
    end
  end 
end

def render_state
    puts "-" * 40
    State.to_a.sort_by(&:first).each do |port, (movie version_number)|
        puts "#{port.to_s.green} currently likes #{movie.yellow}"
    end
    puts "-" * 40
end    