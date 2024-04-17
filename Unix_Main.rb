require_relative "Enemies.rb"
require_relative "Player.rb"

def startGame
  system "clear"
  $stage = 1
  $monstersDefeated = 0
  $displayStats = 1
  $displayControls = 1
  

  puts "To start your adventure, please enter your name."
  print "Champion: "
  name = gets().chomp

  $player = Player.new(name)
  
  game()

end

def menu
  puts "#{$player.name} - Level: #{$player.level} - Stage: #{$stage}"      
  if $displayStats == 1
    stats()
  end
  if $displayControls == 1
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

def game()
  enemy = Enemy.new($stage)
  i = 0

  loop do
    system "clear"
    menu()
    i = i + 1
    puts
    
    if i == 1
      puts "A wild Lv.#{enemy.level} #{enemy.name} has appeared!"
    elsif enemy.health > 0
    puts "Fighting Lv.#{enemy.level} #{enemy.name}"
    end

    if enemy.health <= 0
      $monstersDefeated += 1
      puts "#{enemy.name} has been defeated!"
      xp = (enemy.maxHealth * 0.5) + (rand(5..10) * $stage)
      puts "You got #{xp} xp!"
      $player.addXp(xp)
      if enemy.type == "boss"
        $player.rewardSp(0.10)
      end
      
      if $monstersDefeated % 20 == 0
        $stage += 1
        $player.rewardSp(0.80)
      end
      readRaw()
      break
    end
    enemy.display()
    
    char = readRaw()
    
    if char == " "
      enemy.reduceHp($player.attackPower)
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
    
    if char == "x"
      system "clear"
      puts "-- GAME OVER --"
      $displayStats = 1
      $displayControls = 0
      menu()
      puts
      abort("Hope you had fun!")
    end
    
    if char == "s"
      shop()
    end
  end
game()
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

def stats()
  puts "Xp: #{$player.xp} / #{$player.nextLevelXp}"
  puts "Attack Power: #{$player.attackPower}"
  puts "Enemies Felled: #{$monstersDefeated}"
  puts "Skill Points: #{$player.skillPoints}"
end


def shop()
  system "clear"

  puts "Welcome to the shop!"
  puts
  puts "Push 'e' to exit"
  puts
  puts "YOU HAVE #{$player.skillPoints} SKILL POINTS"
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
