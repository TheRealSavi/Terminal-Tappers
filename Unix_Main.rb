require_relative "Enemies.rb"
require_relative "Player.rb"

def logo
  puts <<~LOGO
     ________________  __  ________   _____    __       _________    ____  ____  __________ _____
    /_  __/ ____/ __ \\/  |/  /  _/ | / /   |  / /      /_  __/   |  / __ \\/ __ \\/ ____/ __ / ___/
     / / / __/ / /_/ / /|_/ // //  |/ / /| | / /        / / / /| | / /_/ / /_/ / __/ / /_/ \\__ \\
    / / / /___/ _, _/ /  / _/ // /|  / ___ |/ /___     / / / ___ |/ ____/ ____/ /___/ _, ____/ /
   /_/ /_____/_/ |_/_/  /_/___/_/ |_/_/  |_/_____/    /_/ /_/  |_/_/   /_/   /_____/_/ |_/____/
  LOGO
end

def startGame()
  system "clear"
  logo()

  $gameState = {stage: 1, monstersDefeated: 0, displayStats: 1, displayControls: 1, player: nil, enemySlots: 3, enemies: []}

  puts "To start your adventure, please enter your name."
  print "Champion: "
  name = gets().chomp
  $gameState[:player] = Player.new(name)
  
  game()
end

def menu
  player = $gameState[:player]

  puts "#{player.name} - Level: #{player.level} - Stage: #{$gameState[:stage]}"     

  if $gameState[:displayStats] == 1
    stats()
  end

  if $gameState[:displayControls] == 1
    controls()
  end
  puts
end

def controls()
  puts
  puts "Push the space bar to attack"
  puts
  puts "Push 'x' to close"
  puts
  puts "Push 's' to enter the store"
  puts
  puts "Push 'd' to toggle stats"
  puts "Push 'c' to toggle controls"
end

def stats()
  player = $gameState[:player]

  puts "Xp: #{player.xp} / #{player.nextLevelXp}"
  puts "Attack Power: #{player.attackPower}"
  puts "Enemies Felled: #{$gameState[:monstersDefeated]}"
  puts "Skill Points: #{player.skillPoints}"
end

def game()
  loop do
    system "clear"
    menu()

    #stage rule
    if $gameState[:monstersDefeated] % 20 == 0
      $gameState[:stage] += 1
    end
    
    #enemy slot filler
    if $gameState[:enemies].length < $gameState[:enemySlots]
      openSlots = $gameState[:enemySlots] - $gameState[:enemies].length
      openSlots.times do 
        $gameState[:enemies].push(Enemy.new())
      end
    end
    
    #enemy displayer and updater
    $gameState[:enemies].reverse_each do |enemy|
      enemy.display()
      puts
    end

    #read for frames user input
    char = readRaw()

    #if input was " " deal damage to all enemies
    if char == " "
      $gameState[:enemies].each do |enemy|
        enemy.reduceHp($gameState[:player].attackPower)
      end
    end
    
    if char == "d"
      if $gameState[:displayStats] == 0
        $gameState[:displayStats]  = 1 
      else
        $gameState[:displayStats] = 0
      end
    end
    
    if char == "c"
      if $gameState[:displayControls] == 0
        $gameState[:displayControls] = 1 
      else
        $gameState[:displayControls] = 0
      end
    end

    if char == "s"
      shop()
    end

    if char == "x"
    endGame("Finger slipped")
    end

  end
end

def endGame(causeOfDeath)
  system "clear"
  puts "-- GAME OVER --"
  puts
  puts "Cause of death: #{causeOfDeath}"
  puts
  $gameState[:displayStats] = 1
  $gameState[:displayControls] = 0
  menu()
  puts
  abort("Hope you had fun!")
end

def readRaw()
  system("stty raw -echo") #=> Raw mode, no echo

  char = " "
  result = IO.select([STDIN], nil, nil, 1)

  if result && result[0].include?(STDIN)
    char = STDIN.getc
  end

  system("stty -raw echo") #=> Reset terminal mode
  return char
end

def shop()
  system "clear"

  puts "Welcome to the shop!"
  puts
  puts "Push 'e' to exit"
  puts
  puts "YOU HAVE #{$gameState[:player].skillPoints} SKILL POINTS"
  puts
  
  puts "1: +1 Attack Damage - Cost: 1 skill point "
  puts "2: +2 Attack Damage - Cost: 2 skill points"
  
  if $gameState[:player].skillPoints < 1
    return
  end
  
  print "What to buy: "
  choice = readRaw()
  
  if choice == "1"
    if $gameState[:player].skillPoints < 1
      print "You can't afford that, silly! \n"
      readRaw()
    else
      $gameState[:player].attackUp(1)
      $gameState[:player].shopBuy(1)
    end
  elsif choice == "2"
    if $gameState[:player].skillPoints < 2
      print "You can't afford that, silly! \n"
      readRaw()
    else
      $gameState[:player].attackUp(2)
      $gameState[:player].shopBuy(2)
    end
  elsif choice.upcase == "E"
    return
  end
  shop()
end

startGame()
