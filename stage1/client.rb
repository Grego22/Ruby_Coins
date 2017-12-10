require_relative 'Gregocoin'
require 'faraday'

URL = 'http://localhost/'
PORT = 7777

def create_user(name)
    Faraday.post("#{URL}:#{PORT}/users", name: name).body
end

def get_balance(user)
    Faraday.get("#{URL}:#{PORT}/balance", user: user).body
end

def transfer(from, to, amount)
    Faraday.post("#{URL}:#{PORT}/transfer", from: from,
    to: to, amount: amount).body
end