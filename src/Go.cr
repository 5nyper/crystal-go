require "./Go/*"

module Go
	def Go.range(ch, &block)
		while true
			begin
				yield ch.receive
			rescue ChannelClosed
				break
			end	
			
		end
	end
	
	class Ticker
		getter delay
		getter ch

		def initialize(@delay)
			@ch = Channel(Time).new

			spawn {
				while true
					before = Time.now.to_i
					nextTickTime = Time.now.to_i + @delay

					#Actually sending
					@ch.send(Time.now)

					#Sleeping
					if (Time.now.to_i <= nextTickTime)
						sleep (nextTickTime - Time.now.to_i)
					elsif (Time.now.to_i > nextTickTime)
						timeSinceLastTick = Time.now.to_i - before
						sleepTime = (@delay - (timeSinceLastTick % @delay))
						sleep sleepTime
					end
				end
			}
		end
	end
end
