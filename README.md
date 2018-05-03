## FPGA-Game-Studio presents: RPG Escape
Our project involved creating an role-playing game where the first player needs to defeat the second player in five battles.  The first player controls their character on the map screen and the battle screen, while the second player only controls an enemy character during a battle.

# Required Materials
The user(s) needs to have a computer program like Vivado or ISE, a computer keyboard with a USB plug, a Nexys 3 Spartan-6 FPGA (or similar device), and a VGA cord.

# Gameplay
When the game starts, flick a switch (SW0) on the FPGA to start the game.  Player one controls their character on the map screen using the keyboard's arrow keys.  When player one's character collides with an enemy, a battle starts.  During the battle, player one and player two can attack the other's character.  The four moves the two players can use are punch, kick, baseball bat, and sword, which take away 10, 20, 30, and 40 hit points (HP), respectively, from the other if the chosen move hits. The more powerful the move is, the more likely it will miss.  The buttons for these attacks are:

Player One: A - Punch, S - Kick, D - Baseball Bat, and W - Sword
Player Two: J - Punch, K - Kick, L - Baseball Bat, and I - Sword

Both players have power points (PP) for the bat (3) and the sword (2), which limits the number of times they can attack each other using them.  Punch and kick can be used an infinite number of times.  If player two defeats player one, the game is over, but if player one defeats player one in battles one, two, three, or four, player one is taken back to the map, and the enemy sprite that was approached is gone.  During the first battle, both characters have 100 HP.  Each subsequent battle has player 1 facing an enemy with more HP each time, but in the fifth battle, both characters have 190 HP.

#
