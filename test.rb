# Inclusione del framework
require "chromosome.rb"
require "genetic_pool.rb"

# Ridefiniamo i due metodi decode e fitness
class Chromosome
  # Decode prende il dna di un cromosoma e restituisce una
  # espressione matematica. Composta dalle cifre 0-9 e i
  # simboli + - * e /
  # Sono quindici simboli, quindi 4 bit bastano per rappresentarli
  def decode
    # Inutile ripetere la decodifica se siamo già decodificati
    if @decoded.nil?
      
      # Convertiamo il dna in una stringa di numeri e operatori
      # Non sappiamo ancora se è un'espressione valida
      decoded_string = ""
      @dna.scan(/.{4}/).each do |gene|
        decoded_string << get_decoded_value(gene)
      end
      
      # Trasformiamo l'espressione nella più vicina espressione
      # Che sia matematicamente valida
      @decoded = verify_expression(decoded_string)
    end
    @decoded
  end
  
  # Chromosome#fitness serve a calcolare quanto il cromosoma
  # risponda al nostro problema. In questo caso stiamo cercando
  # un'espressione che restituisca un valore predefinito
  # quindi per calcolare fitness valuteremo solamente la differen-
  # za dal nostro target.
  def fitness(target)
    # Inutile ricalcolare fitness
    if @fitness.nil?
      begin
        # Piccolo pericolo con eval, ma siamo sicuri di passare
        # una stringa che contenga un'espressione matematica
        chromosome_evaluation = eval(decode)
      
      # Assicuriamoci di non bloccarci solo per una divisione
      # per zero. Se dividiamo per zero diamo semplicemente 
      # un valore arbitrario (0 nel nostro caso)  a
      # chromosome_evaluation
      rescue ZeroDivisionError
        chromosome_evaluation = 0
      end
      # Per calcolare fitness usiamo la seguente formula
      # 1/(t - e) ^ 2
      # otteniamo un valore che mediamente è sempre molto piccolo
      # nel caso l'evaluation sia uguale al target non dobbiamo
      # preoccuparci. Siamo in float in questo momento e la divi-
      # sione per 0 dà un valore ben preciso, Infinito.
      @fitness = (1.0 / (target - chromosome_evaluation).to_f) ** 2
    end
    @fitness
  end
  
  private
  
  # Un noioso metodo per decodificare un gene
  def get_decoded_value(gene)
    return case
      when gene == "0000" : "0"
      when gene == "0001" : "1"
      when gene == "0010" : "2"
      when gene == "0011" : "3"
      when gene == "0100" : "4"
      when gene == "0101" : "5"
      when gene == "0110" : "6"
      when gene == "0111" : "7"
      when gene == "1000" : "8"
      when gene == "1001" : "9"
      when gene == "1010" : "+"
      when gene == "1011" : "-"
      when gene == "1100" : "*"
      when gene == "1101" : "/"
      else ""
    end
  end
  
  # Qualche regola che eviti di decodificare un cromosoma in una
  # espressione aritmetica senza senso
  def verify_expression(decoded_string)
    purged_decoded_string = ""
    # Depuriamo la stringa di caratteri iniziali non cifra e la
    # scansioniamo 
    decoded_string.gsub(/^\D/, "").scan(/./) do |char|
      # Se la stringa è vuota inseriamo char solo se è cifra
      if purged_decoded_string[-1,1].nil?
        purged_decoded_string << char if char.match(/\d/)
      else
      # Altrimenti se l'ultima cifra è un simbolo e char è una
      # cifra viene inserito, in caso contrario saltiamo il char
        if purged_decoded_string[-1,1].match(/\D/) && 
        char.match(/\d/)
          purged_decoded_string << char
      # Se l'ultima cifra è cifra e char è simbolo lo aggiungiamo
        elsif purged_decoded_string[-1, 1].match(/\d/) && 
        char.match(/\D/)
          purged_decoded_string << char
        end
      end
    end
    #  Assicuriamoci che l'ultimo carattere non sia un simbolo
    purged_decoded_string.gsub(/\D$/, "")
  end 
end 
    
### Il programma principale

# Creiamo una GeneticPool popolata da 100 individui, che cerche-
# ranno di trovare un'espressione che dia 42 come risultato.
# 40 bit significa che abbiamo a disposizione 10 caratteri.    
g = GeneticPool.new(100, 42, 40)

# Pronti...partenza...via!
g.run_experiment