# FPGA Game Studio presents: RPG Escape
Our project involved creating a role-playing game where the first player needs to defeat the second player in five battles.  The first player controls their character on the map screen and the battle screen, while the second player only controls an enemy character during a battle.  Our inspiration for this game is Nintendo's Pokémon franchise.  The zip file should contain every file needed.  Here is a link to the video we made about it: https://www.youtube.com/watch?v=nCmrHsxbnh4

## Required Materials
The user(s) needs to have a computer program like Vivado or ISE, a computer keyboard with a USB plug, a Nexys 3 Spartan-6 FPGA (or similar device), and a VGA cord.

## Gameplay
When the game starts, flick a switch (SW0) on the FPGA to start the game.  Player one controls their character on the map screen using the keyboard's arrow keys.  When player one's character collides with an enemy, a battle starts.  During the battle, player one and player two can attack the other's character.  The four moves the two players can use are punch, kick, baseball bat, and sword, which take away 10, 20, 30, and 40 hit points (HP), respectively, from the other if the chosen move hits. The more powerful the move is, the more likely it will miss.  The buttons for these attacks are:

Player One: A - Punch, S - Kick, D - Baseball Bat, and W - Sword

Player Two: J - Punch, K - Kick, L - Baseball Bat, and I - Sword

Both players have power points (PP) for the bat (3) and the sword (2), which limits the number of times they can attack each other using them.  Punch and kick can be used an infinite number of times.  If player two defeats player one, the game is over, but if player one defeats player one in battles one, two, three, or four, player one is taken back to the map, and the enemy sprite that was approached is gone.  During the first battle, both characters have 100 HP.  Each subsequent battle has player 1 facing an enemy with more HP each time, but in the fifth battle, both characters have 190 HP.

## General Project Breakdown
Our Verilog code is, generally, broken down into four parts:

1) VGA Controller: This controls what the computer screen will display, like sprites on the map screen.  It sends RGB in one byte, where the three MSB represent the color red, the next three bits represent green, and the last two bits represent blue.  Each pixel is sent to the screen from the top left corner to the bottom right corner.  The image shown depends on the combination of inputs and outputs.  For example, if the HP value for the enemy character from the game engine starts at 110 HP, the battle screen displays that the enemy's HP is 110, when the enemy is being attacked, HP is deducted, and this deduction is shown (i.e. 110 HP becomes 90 HP if a kick hits).  A game over screen is shown if the second player wins a battle, and a victory screen is shown if player one wins all five battles.  The maze was hard-coded in this part.  Collision detection of a wall or enemy was also done here.

2) Block RAM: The BRAM is where sprites are saved and sent to the VGA controller.  If we created all the sprites ourselves, we would have spent hours making them.  The sprites used for the game are from Pokémon Red and Blue.  Most of them were edited because we wanted to customize the game.  For example, a Rocket Grunt wore black in the games, but we recolored their clothes red.  For convenience, the same grass sprite was used for the ground of the game that the player can walk on, and the same brick sprite was used for the spots where there is supposed to be a wall.  In order to make the main character look like he is moving, we used multiple sprites of him, which include him standing still and moving in a direction.

3) Game Engine: The game engine controls what happens when a battle occurs.  At the beginning of the battle, the HP of the player and enemy are set based on how many enemies have been defeated.  The enemy's HP increases by 10 for each subsequent battle except for the last one (both HP are 190).  Accuracy is determined in this module by adding one to a register (named accuracy) until it reaches seven everytime a posedge of the clock occurs.  Once the register reaches seven, it resets to zero.  Since the clock of the FPGA is 100MHz, a person will not be able to tell if their attack will hit or miss.  The game engine is designed to allow a punch, kick, bat, and sword to hit 87.5%, 75%, 62.5%, and 50% of the time, respectively.

4) Top Module: This module contains all parts previously mentioned and connects them all together.

## Setbacks and Original Ideas
Originally, we were going to convert a random maze generation from C code to Verilog, but this was too difficult for us to handle, so we hard-coded only one maze.  We were going to use $random% to set the accuracy of moves and cause attacks to vary by as much as 20%, but this function is not supported by the FPGA.  We were also planning on having larger sprites during the battles, but the limited BRAM space and other problems caused us to scrap them from the game.  We were also going to display more words in the game describing events, such as the introduction and events in a battle, but BRAM space limitaions and/or more hard-coding would have been required for this to happen. The battle system was also originally intended on being completely turn-based, where the players would alternate their attacks, but we instead made it so that any player can press one of their keys at any time unless another key is pressed.

## Alternative Battle Mode
An alternate version of battle mode was created for this game in case we could not use the original battle mode.  This alternate battle system had only one playable character.  The player needs to dodge the enemy character, who is moving around the battle arena, and defeat the enemy by firing a fireball at him.  The player also needs to dodge both his own and the enemy's fireball, which is fired as soon as the player fires his own.  The fireballs bounce around the arena until the player is defeated or the enemy is defeated, which only occurs if the enemy collides with the player's fireball.  The speed of battle mode increases for each subsequent enemy fought.  Once again, if all enemies are defeated, the player wins.  Because of the challenge of this gameplay, the player may attempt to defeat the current enemy as many times as they would like without resetting the game.  This alternate version of the game is also in this repository.

## Reference
*Pokémon Red Version and Blue Version*. Kyoto, Japan: Nintendo, 27 Feb. 1996.
