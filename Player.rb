class Player
  attr_reader :attackPower, :xp, :nextLevelXp, :skillPoints, :name, :level
  def initialize(name)
    @name = name
    @nextLevelXp = 1
    @xp = 0
    @level = 1
    @attackPower = 1
    @skillPoints = 0
  end

  def addXp(gained)
    @xp += gained
    if @xp >= @nextLevelXp
      @level += 1
      @skillPoints +=1
      puts
      puts "Level Up! Level: #{@level}"
      puts
      @nextLevelXp *= rand(2..5)
    end
  end
  
  def rewardSp(reward)
    @skillPoints += reward
    @skillPoints = @skillPoints.round(2)
  end

  def attackUp(amount)
    @attackPower += amount
  end

  def shopBuy(amount)
    @skillPoints -= amount
    @skillPoints = @skillPoints.round(2)
  end

end
