require "chromosome.rb"
require "genetic_pool.rb"

class Chromosome
	def decode
		if @decoded.nil?
			decoded_string = ""
			@dna.scan(/.{4}/).each do |gene|
				decoded_string << (gene.to_i(2) + 97).chr if gene.to_i(2) <= 25
			end
			@decoded = decoded_string
		end
		@decoded
	end
	def fitness(target)
		if @fitness.nil?
			correct = 0
			decode.size.times do |i|
				correct +=1 if decode[i] == target[i]
			end
			@fitness = 1.0 / (target.size - correct).to_f
		end
		@fitness
	end
end	
							
g = GeneticPool.new(200, "rubidio", "rubidio".size * 4)
g.run_experiment