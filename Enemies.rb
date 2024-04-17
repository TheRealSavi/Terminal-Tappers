class Enemy attr_reader :health, :name, :level, :type, :maxHealth
  def initialize(level)
    @level = level
    @name = newName()
    @health = calcHealth()
    @maxHealth = @health
  end

  def calcHealth()
    scalar = rand(2..10)
    x = scalar * @level
    if scalar > 7
      @type = "boss"
    else 
      @type = "normal"
    end
    return x
  end

  def newName()
    name = ["Kevin","Richard","Pete"]
    return name[rand(name.length)]
  end
  
  def genBar()
    width = (@type == "boss") ? 35 : 18
    filledPercent = @health.to_f / @maxHealth.to_f
    filledPixels = (filledPercent * width.to_f).to_i
    remainingPixels = width - filledPixels
    puts "[#{'#' * filledPixels}#{'*' * remainingPixels}]"
  end

  def display()
    genBar()
    puts "It has #{@health} life remaining."
  end

  def reduceHp(attack)
    @health -= attack
  end
end
