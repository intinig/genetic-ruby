require "chromosome.rb"
require "roulette.rb"

class GeneticPool
  
  attr_reader :population, :best_match, :concluded_experiment
  attr_reader :current_generation, :target, :fitness_pool

  # Inizializziamo una popolazione
  # pop_size è il numero di elementi che faranno parte di ogni
  #          generazione.
  #
  # target è il "bersaglio" del nostro esperimento, al quale
  #        tenderanno tutti i cromosomi. Può essere stringa o 
  #        numero o altro. E' la funzione decode del cromosoma
  #        che ci permetterà di confrontare ogni cromosoma con
  #        il nostro bersaglio.
  #
  # dna_size è la lunghezza in bit del dna di ogni cromosoma
  def initialize(pop_size = 100, target = "", dna_size = 32)
    
    # Popoliamo a caso la nostra prima generazione
    @population = []
    pop_size.times { @population << Chromosome.random(dna_size) }
    
    # All'inizio non abbiamo ancora valutato chi è il miglior
    # elemento, quindi resettiamo tutte le variabili interessate
    @best_match = nil
    @concluded_experiment = false
    
    
    @current_generation = 0
    
    
    @target = target
  end

	
	def to_s
		output = "Genetic Pool composed of #{@population.size} chromosomes:\n\n"
		@population.each do |chromosome|
			output << chromosome.decode
			output << "\n"
		end
		output
	end
	
	def experiment_status
#		puts "\nGeneration:\t#{@current_generation}"
#		print "Experiment:\t"
#	  print "Not " unless concluded?
#	  puts "Successfully Concluded"
#		puts "\t=== Best Match ==="
#		puts "DNA:\t#{@best_match.dna}"
#		puts "Decoded Genetic Data:\t#{@best_match.decode}"
#		print "Fitness:\t"
#		if concluded?
#			puts "To the Infinity and Beyond!"
#		else
#			printf("%.2f\n", @best_match.fitness(@target))
#		end
		puts "Gen. #{current_generation} fittest: #{@best_match.decode}"
	end
	
	def concluded?
		@concluded_experiment == true
	end
	

  # Crea una nuova generazione di cromosomi
  def new_generation
    # Incrementiamo il contatore di generazioni, per motivi di
    # studio e statistica, e poi generiamo una roulette propor-
    # zionale al fitness. 
    # NOTA: non si può chiamare new_generation se non è stato
    # prima eseguito un test sul fitness.
    @current_generation += 1
    roulette = Roulette.new(@fitness_pool)
    
    # Ottenuta la roulette possiamo farla girare in modo da
    # estrarre coppie di cromosomi da riprodurre
    # Il loop viene eseguito popolazione / 2 volte perché ogni
    # accoppiamento produce due figli.
    # Esistono versioni alternative che da ogni accoppiamento
    # fanno nascere un solo figlio. 
    new_population = []
    (@population.size / 2).times do
      mother = @population[roulette.extract]
      father = @population[roulette.extract]
      
      # Inseriamo i figli nella nuova popolazione
      Chromosome.mated_pair(mother, father).each do |chromosome|
        new_population << chromosome
      end
    end
    
    # Il vecchio lascia il posto al nuovo - è la legge della vita
    @population = new_population
  end

  # Loop che esegue l'esperimento - Abbastanza autoesplicativo
  def run_experiment
    test_fitness
    experiment_status
    while !concluded?
      new_generation
      test_fitness
      experiment_status
    end
  end 

  # Popola @fitness_pool con i valori di fitness di tutti 
  # i cromosomi. 
  # La parte relativa a @best_match serve solo per avere sempre
  # presente chi è il figlio migliore di questa generazione
  # o per scoprire se si è risolto il problema.
  def test_fitness
    @fitness_pool = []
    
    # Iteriamo tra la popolazione e calcoliamo il fitness di
    # ogni cromosoma.
    @population.each do |chromosome|
      @fitness_pool << chromosome.fitness(@target)
      
      # Controlliamo chi sia il miglior elemento della generazio-
      # ne.
      if @best_match.nil? || 
      @best_match.fitness(@target) < chromosome.fitness(@target)
        @best_match = chromosome
      end
      # Controlliamo se questa generazione risolve il 
      # problema.
      if !@best_match.nil? && 
      @best_match.fitness(@target).infinite?
        @concluded_experiment = true
        break;
      end
    end
  end
end