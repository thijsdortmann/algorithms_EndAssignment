class ParticleSystem { // particlesystem class

  class Particle { // particle class

    PVector location; // location of particle
    PVector velocity; // velocity of particle
    PVector acceleration; // acceleration of particle
    float lifespan; // lifespan of particle

    Particle(PVector location, PVector acceleration, PVector velocity) { // constructor for particle. give initial location, init speed and acceleration
      this.location = location.get(); // store constructor parameter to object
      this.acceleration = acceleration.get(); // store constructor parameter to object
      this.velocity = velocity.get(); // store constructor parameter to object
      lifespan = 255; // set lifespan to 255
    }

    void run() { // runs particle
      this.update(); // updates position
      this.display(); // displays particle
    }

    void update() {
      velocity.add(acceleration); // add acceleration to velocity
      location.add(velocity); // add velocity to location
      lifespan -= 2.0; // decrease lifespan
    }

    void display() { // draw particle
      noStroke(); // no stroke around particle
      fill(random(color_red1, color_red2), random(color_green1, color_green2), random(color_blue1, color_blue2), lifespan); // set colors; gets colors from parent ParticleSystem object
      ellipse(location.x, location.y, 6, 6); // draw ellipse
    }

    boolean isDead() { // check if particle is dead
      if (lifespan < 0.0) { // if lifespan has ended
        return true; // return true
      } else { // if lifespan hasn't ended
        return false; // return false
      }
    }
  }

  // Initializes variables needed
  ArrayList<Particle> particles; // arraylist for particles
  PVector origin; // PVector for origin of particlesystem

  // Not the right usage of PVectors, but very handy datatype for this kind of data
  PVector accelerationBoundsX; // random acceleration on x-axis between these values
  PVector accelerationBoundsY; // random acceleration on y-axis between these values
  PVector velocityBoundsX; // random velocity on x-axis between these values
  PVector velocityBoundsY; // random velocity on y-axis between these values

  int color_red1; // left bound for red color
  int color_red2; // right bound for red color
  int color_green1; // left bound for green color
  int color_green2; // right bound for green color
  int color_blue1; // left bound for blue color
  int color_blue2; // right bound for blue color

  int totalParticles = 0; // counts total amount of particles ever spawned in this system

  ParticleSystem(PVector origin, PVector accelerationBoundsX, PVector accelerationBoundsY, PVector velocityBoundsX, PVector velocityBoundsY, int color_red1, int color_red2, int color_green1, int color_green2, int color_blue1, int color_blue2
    ) { // constructor for ParticleSystem. for explanation of parameters, see variables above

    // Stores parameters to object
    this.origin = origin.get();
    this.accelerationBoundsX = accelerationBoundsX.get();
    this.accelerationBoundsY = accelerationBoundsY.get();
    this.velocityBoundsX = velocityBoundsX.get();
    this.velocityBoundsY = velocityBoundsY.get();
    this.color_red1 = color_red1;
    this.color_red2 = color_red2;
    this.color_green1 = color_green1;
    this.color_green2 = color_green2;
    this.color_blue1 = color_blue1;
    this.color_blue2 = color_blue2;

    particles = new ArrayList<Particle>(); // init arraylist for particles in particlesystem
  }

  boolean isDead() { // check if particlesystem is dead
    if (particles.size() == 0) { // if no particles in arraylist
      return true; // return true boolean
    } else {
      return false;
    }
  }

  int particleCount() { // returns particlecount
    return particles.size();
  }

  void addParticle() { // adds particle at random position withing given bounds
    PVector acceleration = new PVector(random(accelerationBoundsX.x, accelerationBoundsX.y), random(accelerationBoundsY.x, accelerationBoundsY.y)); // calculates random acceleration within given bounds
    PVector velocity = new PVector(random(velocityBoundsX.x, velocityBoundsX.y), random(velocityBoundsY.x, velocityBoundsY.y)); // calculates random velocity within given bounds
    particles.add(new Particle(origin, acceleration, velocity)); // adds new particle to arraylist
    totalParticles++; // adds 1 to current total particle count
  }

  void changeOrigin(PVector origin) { // changes origin of particlesystem
    this.origin = origin.get();
  }

  void run() { // runs particlesystem
    Iterator<Particle> it = particles.iterator(); // create iterator from arraylist
    while (it.hasNext ()) { // loops through arraylist
      Particle p = it.next(); // load next from iterator
      p.run(); // run loaded particle
      if (p.isDead()) { // is particle dead
        it.remove(); // remove from arraylist
      }
    }
  }
}
