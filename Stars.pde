class Stars {

  ArrayList<Star> stars; // arraylist for stars
  Random generator; // random number generator

  class Star {
    PVector pos; // position of star
    PVector vel; // velocity of star

    Star(PVector pos) { // constructor. parameter: initial position
      this.pos = pos.get(); // store position
      vel = new PVector(0, int(random(2, 4))); // generate random velocity
    }

    void moveDown() { // moves star
      pos.add(vel); // add velocity to position
    }

    void draw() { // draws star
      strokeWeight(1); // set stroke weight
      stroke(255); // set color
      line(pos.x, pos.y, pos.x, pos.y+2*vel.y); // draw line
    }

    boolean isDead() { // check if star object is dead
      if (pos.y > height) { // if moved off screen
        return true; // return true
      } else { // if not
        return false; // return false
      }
    }
  }

  Stars() { // constructor for starsystem
    stars = new ArrayList<Star>(); // init arraylist for star objects
    generator = new Random(); // init random number generator
  }

  void draw() {
    float num = (float) generator.nextGaussian(); // generate random gaussian
    num = num * width/2 + width; // add sdev and mean
    if (random(0, 200) < 100) { // create random number to see if star should be drawn
      stars.add(new Star(new PVector(random(-32, width), 0))); // draw at position
    }

    Iterator<Star> it = stars.iterator(); // iterator for stars arraylist

    while (it.hasNext ()) { // loop through star arraylist
      Star s = it.next(); // load next star object
      s.moveDown(); // move star
      s.draw(); // draw star
      if (s.isDead()) it.remove(); // if star object dead, remove from arraylist
    }
  }
}
