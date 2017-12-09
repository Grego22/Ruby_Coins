require 'sinatra'
require 'colorize'

BALANCES = {
    'Grego' => 1_000_000,
}

 # @param user

 get "/balance" do
    user = params['user']
    puts BALANCES.to_s.yellow
     "#{user} has#{BALANCES[user]}"
 end


 post "/users" do 
    name = params['name']
    BALANCE[name] ||= 0
    puts BALANCES.to_s.yellow
    
    "OK"
 end

 post "/transfers" do
    from, to = params.values_at('from', to).map(&:downcase)
    amount = params['amount'].to_i
    raise unless BALANCES[from] >= amount
    BALANCES[from] -= amount
    BALANCES[to] += amount
    puts BALANCES.to_s.yellow
    
    "OK"
end