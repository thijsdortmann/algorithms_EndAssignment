class Debris {

  class DebrisUnit {
    // PVectors used for DebrisUnit
    PVector pos; // position
    PVector vel; // velocity
    PVector acc; // acceleration

    PImage debris; // PImage that will contain image used for DebrisUnit

    boolean large; // Determines whether DebrisUnit is large or not
    boolean triggerDead = false; // If true, DebrisUnit dead will be triggered

    DebrisUnit(PVector pos) {
      this.pos = pos.get(); // store position parameter in class
      vel = new PVector(random(-.5, .5), int(random(1, 2))); // generate random velocity
      acc = new PVector(0, 0); // no acceleration

      if (random(0, 200) < 25) { // generate random number to determine whether particle will be large
        // If large, set boolean large to true and load large image.
        large = true;
        debris = loadImage("largeDebris.png");
      } else {
        // Else, set boolean large to false and load small image.
        large = false;
        debris = loadImage("debris.png");
      }
    }

    DebrisUnit(PVector pos, PVector vel, boolean large) { // Same as above, but with extra parameters for velocity and size
      this.pos = pos.get();
      this.vel = vel.get();
      acc = new PVector(0, 0);

      if (large == true) {
        this.large = true;
        debris = loadImage("largeDebris.png");
      } else {
        this.large = false;
        debris = loadImage("debris.png");
      }
    }

    void moveDown() { // Moves DebrisUnit
      pos.add(vel); // Add velocity to position
      // Following two if-statements make DebrisUnit reappear at other side of the screen when it moves out of the screen horizontally
      if (pos.x < 0) pos.x = width;
      if (pos.x > width) pos.x = 0;
    }

    void draw() { // Draws DebrisUnit
      stroke(255); // set stroke color
      fill(255); // set fill color

      if (large) { // if large debrisunit
        image(debris, pos.x-32, pos.y-32); // draw image at position for large debrisunit
      } else {
        image(debris, pos.x-7, pos.y-7); // draw image at position for 'regular' debrisunit
      }
    }

    boolean isDead() { // checks is debrisunit is 'dead'
      if (triggerDead) { // if triggerDead variable is true
        return true; // returns true boolean
      } else { // if not
        if (pos.y > height) { // check whether debrisunit has left the screen
          return true; // returns true boolean
        } else { // if still on screen
          return false; // returns false boolean
        }
      }
    }
  }

  ArrayList<DebrisUnit> debris; // arraylist for debrisunits
  ArrayList<ParticleSystem> explosions; // arraylist for explosion particlesystems

  Random generator; // random number generator

  boolean generateNew = true; // if true, Debris class will generate new DebrisUnits on itself without input

  Debris() { // constructor for debris class
    debris = new ArrayList<DebrisUnit>(); // init arraylist for debrisunits
    explosions = new ArrayList<ParticleSystem>(); // init arraylist for explosion particlesystems

    generator = new Random(); // init random number generator
  }

  void draw() {
    if (generateNew) { // check whether debris has to generate debrisunits
      float num = (float) generator.nextGaussian(); // generate random number
      num = num * 50 + 100; // add sdev and mean

      if (num < 1+level*2) { // generates debrisunits based on random number generated and level
        debris.add(new DebrisUnit(new PVector(random(0, width), 0))); // adds debrisunit to arraylist
      }
    }

    Iterator<DebrisUnit> it = debris.iterator(); // create iterator for debris

    while (it.hasNext ()) { // loop through debris
      DebrisUnit d = it.next(); // load next from iterator
      d.moveDown(); // move debrisunit down
      d.draw(); // draw debrisunit

      if (d.pos.y > height) { // check whether debrisunit has left the screen
        d.triggerDead = true; // trigger dead
        lives--; // remove one live
      }

      if (d.isDead()) { // if debrisunit is dead
        it.remove(); // remove from arraylist
      }
    }

    Iterator<ParticleSystem> it2 = explosions.iterator(); // create iterator for explosion particlesystems

    while (it2.hasNext ()) { // loop through explosion particlesystems
      ParticleSystem p = it2.next(); // load next from iterator
      if (p.totalParticles < 10) { // if less than 10 particles spawned
        p.addParticle(); // add particle to particlesystem
      }
      p.run(); // run particleystem
      if (p.isDead()) { // if particlesystem = dead
        it2.remove(); // remove particlesystem from arraylist
      }
    }
  }
  
  void addDebris(PVector newPos) { // adds debrisunit at given position
    debris.add(new DebrisUnit(newPos, new PVector(random(-1, 1), int(random(2, 3))), false)); // add debrisunit to arraylist with given pos, random speed and small size
  }

  void blowUpAll() { // blows all debrisunits up
    for (int i = 0; i<debris.size (); i++) { // loop through debris arraylist
      DebrisUnit d = debris.get(i); // load debrisunit from arraylist
      explosions.add(new ParticleSystem(new PVector(d.pos.x, d.pos.y), new PVector(-0.2, 0.2), new PVector(-0.2, 0.2), new PVector(-1, 1), new PVector(-1, 1), 200, 255, 200, 255, 200, 255)); // add particlesystem for explosions
      d.triggerDead = true; // trigger dead of debrisunit
    }
  }

  boolean collide(PVector bulletPos) { // collision detection
    ListIterator<DebrisUnit> it = debris.listIterator(); // create iterator for collision

    boolean returnBool = false; // boolean that will be returned, initially false; true when collision

    while (it.hasNext ()) {
      int colDist = 10; // margin for collision

      DebrisUnit d = it.next(); // load next from iterator

      if (d.large) colDist = 32; // if the debris is large, make margin larger


      if (d.pos.x > bulletPos.x - colDist && d.pos.x < bulletPos.x + colDist && d.pos.y > bulletPos.y - colDist && d.pos.y < bulletPos.y + colDist) { // collision detection
        if (d.large) { // if large, spawn smaller Debris
          for (int i = 0; i<int (random (6, 10)); i++) {
            it.add(new DebrisUnit(d.pos, new PVector(random(-1, 1), int(random(2, 3))), false));
          }
        }

        explosions.add(new ParticleSystem(new PVector(bulletPos.x, bulletPos.y), new PVector(-0.2, 0.2), new PVector(-0.2, 0.2), new PVector(-1, 1), new PVector(-1, 1), 200, 255, 200, 255, 200, 255)); // add particles

        d.triggerDead = true; // trigger delete of debris
        returnBool = true; // make returnBool true; collision has occured.
      }
    }
    return returnBool; // return boolean
  }
}
