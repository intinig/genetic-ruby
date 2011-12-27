# Roulette con spicchi proporzionali
# L'ho chiamata roulette ma in realtà è un pò come un recipiente
# in cui viene versato liquido di colore diverso per ogni elemento
# e in cui l'elemento successivo galleggia su quello precedente
# e la quantità di liquido è proporzionale alla fitness dell'ele-
# mento. La procedura di estrazione determina un livello dal quale
# verrà prelevato l'elemento.
class Roulette
  
  # Pool contiene l'insieme di fitness di tutti i membri della po-
  # polazione. La relazione con la GeneticPool è data dall'index
  # dei singoli elementi.
  def initialize(pool)
    
    # Wheel diventa uguale a pool per adesso, e calcoliamo il 
    # totale di fitness presente nella nostra popolazione per 
    # calcolare il coefficiente proporzionale di fitness di ogni
    # elemento.
    @wheel = pool
    total = @wheel.inject {|sum, k| sum + k}
    
    
    # Adesso generiamo il "recipiente". Ogni elemento di @wheel
    # contiene il "livello" massimo da lui raggiunto, e tiene
    # quindi conto di tutti gli elementi precedenti.
    @wheel.each_index do |idx|
      @wheel[idx] = @wheel[idx] / total
      @wheel[idx] += @wheel[idx - 1] if idx > 0
    end
            
  end

  # Estrae un elemento a caso partendo dal suo livello
  def extract
    seed = rand 
    @wheel.each_index do |idx|
      if seed < @wheel[idx]
        return idx
      end
    end  
  end
  
end