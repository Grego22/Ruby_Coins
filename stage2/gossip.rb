require 'sinatra'
require 'colorize'
require 'active_support/time'
require_relative 'client'
require_relative 'helpers'

PORT, PEER_PORT = ARGV.first(2)
set :port, PORT

STATE = ThreadSafe::Hash.new
update_state(PORT => nil)
update_state(PEER_PORT => nil)

MOVIES = File.readlines("movies.txt").map(&:chomp)
@favorite_movie = MOVIES.sample
@version_number = 0
puts "My favorite movie, forever and ever is #{favorite_movie.green}!"

update_state(PORT => [@favorite_movie, @version_number])

every(7.seconds) do
    puts "I changed my mind. 
    I no longer like #{favorite_movie.yellow} it wasn't as good on multiple watches."
    @favorite_movie = MOVIES.sample
    @version_number += 1
    update_state(PORT => [@favorite_movie, @version_number])
    puts "My new favroite movie is #{favorite_movie.red}"
end

every(3.seconds) do
    render_state
    
end

post '/gossip' do
end
