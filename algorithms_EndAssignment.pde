/*

 End Assignment
 
 Algorithms in Creative Technology
 UTwente
 
 (c) 2014 Thijs Dortmann
 
 Created in Processing 2.2.1 with PDE X extension
 
 */

import java.util.*;
import ddf.minim.*;


// Define Objects
Stars stars;
Spaceship ship;
Debris debris;
PowerUps powerups;
Interface uix;
Boss boss;
ParticleSystem totalAnnihilation;

int shootTimer = 0; // Used to see whether player is allowed to shoot again

int score = 0; // score is kept here
int lives = 5; // lives are kept here

boolean twoGuns = false; // defines whether ship has two guns
boolean won = false; // true if won

int level = 0; // current level
int bossLevel = 5; // what level is the boss level / final level
int gameStart = 0; // set to time of start of game
int bossTimer = 0; // set to time of begin boss level

void setup() {
  size(600, 600); // init size of window
  stars = new Stars(); // init background stars
  ship = new Spaceship(); // init spaceship
  debris = new Debris(); // init debris
  powerups = new PowerUps(); // init powerups
  uix = new Interface(); // init interface (scoring, levels, etc)
  totalAnnihilation = new ParticleSystem(new PVector(width/2, height/2), new PVector(-2, 2), new PVector(-2, 2), new PVector(-2, 2), new PVector(-2, 2), 255, 255, 0, 0, 0, 0); // init game over
  boss = new Boss(); // init boss
  gameStart = millis(); // set gameStart to time of game start

  powerups.addRandom(new PVector(255, 0), new PVector(0, 1)); // start player off with one random powerup
}

void draw() {
  if (lives > 0) {
    background(0); // draw background

    stars.draw(); // draw stars

    if (level == bossLevel) { // if level high enough for boss level
      if (debris.generateNew) {
        debris.generateNew = false; // stop generating new debris
        bossTimer = millis(); // set bossTimer to start of boss / final level
      }
      if (bossTimer + 1000 < millis()) { // if final level has been active for 1 second, begin drawing it
        boss.draw(); // draw boss level
      }
    } else { // if no boss level
      level = floor((millis() - gameStart) / 10000); // calculate current level
    }

    if (won) { // if player has won game
      ship.moveOff(); // move ship from screen
      textAlign(CENTER); // align text
      textSize(50); // set size
      fill(255); // set fill
      text("YOU WON!", width/2, height/2); // show winning text
    } else { // if not won
      ship.move(new PVector(mouseX, mouseY)); // move ship to mouse position
    }

    ship.draw(); // draw ship
    debris.draw(); // draw debris
    powerups.draw(); // draw powerups

    uix.draw(); // draw ui / score / level

    if (mousePressed == true && shootTimer + 100 < millis()) { // if mouse is pressed and player hasn't shot in 100ms
      shootTimer = millis(); // reset shoottimer
      ship.spawnBullet(); // spawn bullet
    }

    if (boss.totalVehicles >= boss.maxVehicles && boss.vehicles.size() == 0 && debris.debris.size() == 0) won = true; // check to see if player has completed everything. if so, set won to true
  } else { // if game over

    totalAnnihilation.changeOrigin(ship.pos); // start game over particle system

    for (int i = 0; i<25; i++) {
      totalAnnihilation.addParticle(); // add particles for gameover
    }

    totalAnnihilation.run(); // run gameover animation
    textAlign(CENTER); // align text
    textSize(50); // set size
    fill(255); // set fill
    text("GAME OVER", width/2, height/2); // shown game over text
  }
}