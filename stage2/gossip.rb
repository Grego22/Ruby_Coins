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
    STATE.dup.each_key do |peer_port|
    #duplicating to avoid concurrency issues
        next if peer_port = PORT
        #(dont want to gossip with myself)

        puts "Gossiping with #{peer_port} ..... chat, chat, 
        getting good gossip."
    #every 3 seconds, going to iterate over all "my peers"
    #iterate through each key (peer_port)
    # going to gossip with each peer_port
        begin
          their_state = Client.gossp(peer_port, JSON.dump(STATE))
          #they cant read my state, so i turned it to a JSON
          update_state(JSON.parse(their_state))
        rescue Faraday::ConnectionFailed => e
          puts e
          STATE.delete(peer_port)
        end
      end 

    render_state
    #every time im done gossiping, i want to show my state
end

post '/gossip' do
    their_state = params['state']
    update_state(JSON.parse(their_state))
    JSON.dump(STATE)
end
