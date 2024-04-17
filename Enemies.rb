class Enemy attr_reader :health, :name, :level, :type, :maxHealth
  def initialize()
    @level = $gameState[:stage]
    @name = newName()
    @health = calcHealth()
    @maxHealth = @health
  end

  def calcHealth()
    scalar = rand(2..10)
    x = scalar * @level
    if scalar >= 10
      x = x * 2
      @type = "boss"
    else 
      @type = "normal"
    end
    return x
  end

  def newName()
  names = [
  "Sir Galahad of Camelot",
  "Guinevere de Montfort",
  "Sir Percival the Valiant",
  "Dame Elowyn of the Greenwood",
  "Lord Tristan the Braveheart",
  "Mistress Isolde of Avalon",
  "Sir Lance, The Unknown",
  "Duchess Rowena of Ravenswood",
  "Sir Gawain the Giant",
  "Lady Morgana le Fay",
  "Baron Cedric of Blackwood",
  "Countess Brienna",
  "Sir Roland the Righteous",
  "Lady Midas of Edoras",
  "Lord Godfroy the Noble",
  "Countess Vivienne the Beast Tamer",
  "Sir Baldwin the Bold",
  "Adeline the Healer",
  "Viscount Reginald the Redoubtable!",
  "Tianna Iyafor, Wicked of the Church",
  "Kevin",
  "Richard",
  "Pete",
  "Mistress Celestia, the Sun, Moon, and Stars"
  ]
    return names[rand(names.length)]
  end
  
  def genBar()
    width = (@type == "boss") ? 35 : 18
    filledPercent = [@health.to_f / @maxHealth.to_f, 0.0].max  # Ensure filledPercent is at least 0
    filledPercent = [filledPercent, 1.0].min  # Ensure filledPercent is at most 1
    filledPixels = (filledPercent * width.to_f).to_i
    remainingPixels = width - filledPixels
    
    puts "[#{'#' * filledPixels}#{'*' * remainingPixels}]"
  end

  def display()
    if @health ==@maxHealth
      puts "A wild Lv.#{@level} #{@name} has appeared!"
    else
      puts "Fighting Lv.#{@evel} #{@name}"
    end
    genBar()
    puts "It has #{@health} life remaining."
  end

  def checkDeath()
    if @health <= 0
      $gameState[:monstersDefeated] += 1
      puts "#{@name} has been defeated!"
      xp = (@maxHealth * 0.5) + (rand(5..10) * $gameState[:stage])
      xp = xp.round
      puts "You got #{xp} xp!"
      $gameState[:player].addXp(xp)
      if @type == "boss"
        $gameState[:player].rewardSp(0.10)
      end
      $gameState[:enemies].delete(self)
      return 1
    end
    return 0
  end

  def reduceHp(attack)
    @health -= attack
  end
end
