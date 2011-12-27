class Chromosome
	
	
	@@mutation_rate = 0.01
	@@crossover_rate = 0.7
	
	
	attr_accessor :dna
	attr_reader :fitness
	
	def self.mutation_rate=(rate)
		@@mutation_rate = rate.to_f
	end
	
	def self.crossover_rate=(rate)
		@@crossover_rate = rate.to_f
	end
	
	def self.mutation_rate
		@@mutation_rate
	end
	
	def self.crossover_rate
		@@crossover_rate
	end

  # Assistiamo alla nascita di due cromosomi partendo da due
  # genitori, che speriamo essere forti e in grado di contri-
  # buire alla soluzione del nostro problema.
  def self.mated_pair(first, second)
    # Ci sarà un crossover?
    if rand <= @@crossover_rate
      # SI! Scambiamo un pò di patrimonio genetico
      idx = rand first.dna.size
      first_bred = self.new(first.dna[0, idx + 1] + 
                  second.dna[idx + 1, second.dna.size - idx - 1])
      second_bred = self.new(second.dna[0, idx + 1] +
                  first.dna[idx + 1, first.dna.size - idx - 1])
    else
      first_bred = first
      second_bred = second
    end
    # Proviamo a vedere se uno dei nostri bimbi sarà un mutante
    mutate(first_bred)
    mutate(second_bred)
    [first_bred, second_bred]
  end

	def self.random(dna_size)
		dna = ""
		dna_size.times { dna << rand(2).to_s }
		self.new(dna)
	end
		
		
	def initialize(dna)
		@dna = fix_dna(dna.to_s)
		@fitness = nil
	end
	
	def to_s
		"#{@dna.size} genes chromosome: #{@dna}"
	end
	
	def decode
		raise "You have to redefine Chromosome#decode"
	end
	
	def fitness
		raise "You have to redefine Chromosome#fitness"
	end
		
	private
	def fix_dna(dna)
		unless dna.match(/[01]{#{dna.size}}/)
			raise "Incorrect DNA : #{dna}"
		end
		dna
	end
	def self.mutate(chromosome)
		if rand <= @@mutation_rate
			idx = rand chromosome.dna.size
			chromosome.dna[idx] = chromosome.dna[idx] == 0 ? '1' : '0'
		end
	end

end
