class PowerUps {

  class PowerUp {

    int type; // power up type
    PVector pos; // position of powerup
    PVector vel; // velocity of powerup

    // Color of powerup:
    int red = 0;
    int green = 0;
    int blue = 0;

    String puText = ""; // text on powerup

    boolean redeemed = false; // powerup redeemed?

    int lifespan = 0; // lifespan of powerup when redeemed

    PowerUp(PVector pos, PVector vel, int type) { // constructor for powerup object
      // Store parameters in object
      this.pos = pos.get();
      this.type = type;
      this.vel = vel.get();
      
      // Sets color and text based on type
      if (type == 1) {
        puText = "!";
        red = 255;
      }
      if (type == 2) {
        puText = "G";
        green = 255;
      }
      if (type == 3) { 
        puText = "♥";
        blue = 255;
      }
    }

    void move() { // moves powerup
      pos.add(vel); // add velocity to position
    }

    void redeem() { // redeems powerup
      if (!redeemed) { // if not redeemed
        switch (type) { // switch for powerup redeem
        case 1: // if type 1
          debris.blowUpAll(); // trigger blowing up all debris
          break;

        case 2: // if type 2
          twoGuns = true; // enable two guns on ship
          break;

        case 3: // if type 3
          lives++; // add live
          break;
        }
        redeemed = true;
      }
    }

    void draw() {
      if (redeemed) { // if redeemed, draw animation until lifespan expired
        noFill();
        stroke(red, green, blue, 255-lifespan);
        strokeWeight(4+lifespan);
        ellipse(pos.x, pos.y, 20+lifespan, 20+lifespan);
        fill(255, 255, 255, 255-lifespan);
        strokeWeight(4);
        textSize(10+lifespan);
        textAlign(CENTER, CENTER);
        text(puText, pos.x, pos.y);
        lifespan += 10;
      } else { // if not redeemed, draw regular powerup
        noFill();
        stroke(red, green, blue);
        strokeWeight(4);
        ellipse(pos.x, pos.y, 20, 20);
        fill(255, 255, 255);
        textSize(10);
        textAlign(CENTER, CENTER);
        text(puText, pos.x, pos.y);
      }
    }

    boolean isDead() { // returns whether powerup is dead
      if (lifespan > 254) { // if lifespan expired
        return true; // return true
      } else { // if not
        return false; // return false
      }
    }
  } 

  ArrayList<PowerUp> powerups; // arraylist for powerups

  PowerUps() { // constructor
    powerups = new ArrayList<PowerUp>(); // init arraylist
  }

  void draw() { // draws powerups
    Iterator<PowerUp> it = powerups.iterator(); // create iterator from powerups arraylist
    while (it.hasNext ()) { // loop through arraylist
      PowerUp pu = it.next(); // load next powerup from arraylist
      pu.move(); // move powerup
      pu.draw(); // draw powerup
      if (pu.isDead()) it.remove(); // if powerup dead, remove from arraylist
    }
  }

  void addPowerup(PVector pos, PVector vel, int type) { // adds powerup of specific type at given pos and vel
    powerups.add(new PowerUp(pos, vel, type));
  }

  void addRandom(PVector pos, PVector vel) { // adds random powerup at given pos and vel
    float random = random(0, 1000); // calculates random number
    if (random < 50) { // if lower than 50, add type 1
      addPowerup(pos, vel, 1);
    } else if (random > 50 && random < 250 && !twoGuns) { // if lower than 250 but higher than 50 and no two guns, add type 2
      addPowerup(pos, vel, 2);
    } else { // else, add type 3
      addPowerup(pos, vel, 3);
    }
  }

  void collide(PVector point, int threshold) { // collision detection
    Iterator<PowerUp> it = powerups.iterator(); // create iterator from arraylist

    while (it.hasNext ()) { // loop through arraylist
      PowerUp pu = it.next(); // load next powerup
      if (pu.pos.x < point.x + threshold && pu.pos.x > point.x - threshold && pu.pos.y < point.y + threshold && pu.pos.y > point.y - threshold) { // collision detection
        pu.redeem(); // redeem powerup
      }
    }
  }
}
