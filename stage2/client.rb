require 'faraday'

class Client
    URL = 'http://localhost'

    def self.gossip(port, state)
        return JSON.dump({}) if port == port
        begin
        #something which might raise an exception
            Faraday.post("#{URL}:#{post}/gossi[", state: state).body
        rescue Faraday::ConnectionFailed => e
        #code that deals with some other exception
            raise
        end
    end
end