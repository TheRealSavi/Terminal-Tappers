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

$gameState = {stage: 1, monstersDefeated: 0, displayStats: 1, displayControls, 1, player: nil, enemySlots: 1, enemies: []}

def startGame()
  system "clear"

  puts "To start your adventure, please enter your name."
  print "Champion: "
  name = gets().chomp
  $gameState.player = Player.new(name)
  
  game()
end

def menu
  puts "#{$gameState.player.name} - Level: #{$gameState.player.level} - Stage: #{$gameState.stage}"      
  if $gameState.displayStats == 1
    stats()
  end
  if $gameState.displayControls == 1
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
end

def stats()
  puts "Xp: #{$gameState.player.xp} / #{$gameState.player.nextLevelXp}"
  puts "Attack Power: #{$gameState.player.attackPower}"
  puts "Enemies Felled: #{$gameState.monstersDefeated}"
  puts "Skill Points: #{$gameState.player.skillPoints}"
end

def game()

  i = 0
  loop do
    system "clear"
    menu()
    puts
    
    if $gameState.enemies.length < $gameState.enemySlots
      openSlots = $gameState.enemySlots - $gameState.enemies.length
      openSlots.times do 
        $gameState.enemies.push(Enemy.new())
      end
    end

    
    $gameState.enemies.each do |enemy|
      enemy.display()
      enemy.checkDeath()
    end

    char = readRaw()

    if char == " "
      $gameState.enemies.each do |enemy|
        enemy.reduceHp($player.attackPower)
      end
    end

    if char == "d"
      if $displayStats == 0
        $displayStats = 1 
      else
        $displayStats = 0
      end
    end
    if char == "c"
      if $displayControls == 0
        $displayControls = 1 
      else
        $displayControls = 0
      end
    end

    if char == "s"
      shop()
    end

    if char == "x"
      system "clear"
      puts "-- GAME OVER --"
      $displayStats = 1
      $displayControls = 0
      menu()
      puts
      abort("Hope you had fun!")
    end

  end
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
  puts "YOU HAVE #{$gameState.player.skillPoints} SKILL POINTS"
  puts
  
  puts "1: +1 Attack Damage - 1 skill point"
  puts "2: +2 Attack Damage - 2 skill points"
  
  if $player.skillPoints < 1
    return
  end
  
  print "What to buy: "
  choice = readRaw()
  
  if choice == "1"
    if $player.skillPoints < 1
      print "You cant afford that silly \n"
      readRaw()
    else
      $player.attackUp(1)
      $player.shopBuy(1)
    end
  elsif choice == "2"
    if $player.skillPoints < 2
      print "You cant afford that silly \n"
      readRaw()
    else
      $player.attackUp(2)
      $player.shopBuy(2)
    end
  elsif choice.upcase == "E"
    return
  end
  shop()
end

startGame()
