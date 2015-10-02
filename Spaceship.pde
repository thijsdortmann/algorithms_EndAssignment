class Spaceship {

  class Bullet {
    PVector pos; // position of bullet
    PVector vel; // velocity of bullet

    PImage bullet; // image of bullet

    Bullet(PVector pos) { // constructor for bullet object. give starting position
      this.pos = pos.get(); // save to object
      vel = new PVector(0, -15); // set acceleration
      bullet = loadImage("bullet.png"); // load image for bullet
    }

    void move() {
      pos.add(vel); // add acceleration to position
    }

    void draw() {
      image(bullet, pos.x-7, pos.y-7); // draw image of bullet of position
    }

    boolean isDead() { // check if bullet dead
      if (pos.y < 0) { // if at top of screen
        return true; // return true
      } else {
        return false;
      }
    }
  }


  PVector pos; // position of spaceship

  ArrayList<Bullet> bullets; // arraylist for bullets

  ParticleSystem p1; // particlesystem for exhaust 1
  ParticleSystem p2; // particlesystem for exhaust 2

  Spaceship() {
    pos = new PVector(width/2, height/2); // set initial position
    bullets = new ArrayList<Bullet>(); // init arraylist for bullets
    p1 = new ParticleSystem(new PVector(width/2, height/2), new PVector(0, 0), new PVector(0.5, 0.5), new PVector(-0.5, 0.5), new PVector(1, 2), 255, 255, 35, 190, 25, 25); // init particlesystem 1
    p2 = new ParticleSystem(new PVector(width/2, height/2), new PVector(0, 0), new PVector(0.5, 0.5), new PVector(-0.5, 0.5), new PVector(1, 2), 255, 255, 35, 190, 25, 25); // init particlesystem 2
  }

  void move(PVector pos) {
    this.pos = pos.get(); // change position of ship
  }
  
  void moveOff() {
    pos.y -= 5; // move ship to top
  }

  void draw() {
    p1.changeOrigin(new PVector(pos.x-10, pos.y+10)); // change origin of particlesystem 1
    p1.addParticle(); // add particle to particlesystem
    p1.run(); // run particlesystem

    p2.changeOrigin(new PVector(pos.x+10, pos.y+10)); // change origin of particlesystem 2
    p2.addParticle(); // add particle to particlesytem
    p2.run(); // run particlesystem

    Iterator<Bullet> it = bullets.iterator(); // creat iterator for bullets

    while (it.hasNext ()) { // loop through bullet arraylist
      Bullet b = it.next(); // load next bullet object
      b.move(); // trigger move function for bullet
      b.draw(); // draw bullet

      boolean remove = false; // set boolean remove to false, changes if remove is needed (on collision)

      if (debris.collide(b.pos)) { // if debris collides with bullet
        if (random(0, 200) < 10) powerups.addRandom(b.pos, new PVector(0, 1)); // add random powerup when condition is met
        score++; // add to score
        remove = true; // trigger remove
      }

      if (boss.collide(b.pos)) { // if bullet collides with boss vehicle
        score++; // add to score
        remove = true; // trigger remove
      }

      if (b.isDead() || remove == true) it.remove(); // if remove boolean has been set to true, remove bullet from arraylist
    }

    // Draws rocket
    pushMatrix();

    translate(pos.x, pos.y);

    stroke(255, 0, 0);

    strokeWeight(2);

    if (twoGuns) { // if rocket has two guns, draw those

      line(-7, -55, -5, -40);
      ellipse(-7, -55, 5, 5);
      line(7, -55, 5, -40);
      ellipse(7, -55, 5, 5);
    } else { // if rocket has one gun, draw one

      line(0, -55, 0, -40);
      ellipse(0, -55, 5, 5);
    }

    fill(150);

    noStroke();

    ellipse(0, -20, 20, 50);

    fill(130);

    ellipse(0, -20, 15, 45);

    fill(110);

    ellipse(0, -20, 10, 40);

    fill(255, 87, 36);

    ellipse(-10, 0, 10, 20);
    ellipse(10, 0, 10, 20);

    popMatrix();

    if (debris.collide(new PVector(pos.x, pos.y-70)) == true) { // if collision with debris, remove live
      lives--;
    }

    powerups.collide(pos, 40); // collide with powerups
  }

  void spawnBullet() { // spawns bullets
    if (twoGuns) { // if two guns
      // spawn two bullets
      bullets.add(new Bullet(new PVector(pos.x-7, pos.y-55)));
      bullets.add(new Bullet(new PVector(pos.x+7, pos.y-55)));
    } else {
      // if one gun, spawn one bullet
      bullets.add(new Bullet(new PVector(pos.x, pos.y-55)));
    }
  }
}
