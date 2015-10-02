class Boss {

  
  // Vehicle class
  // source: The Nature of Code
  // author: Daniel Shiffman

  class Vehicle {

    // All the usual stuff
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;    // Maximum steering force
    float maxspeed;    // Maximum speed

      // Constructor initialize all values
    Vehicle(float x, float y) {
      location = new PVector(x, y);
      r = 12;
      maxspeed = 3;
      maxforce = 0.2;
      acceleration = new PVector(0, 0);
      velocity = new PVector(0, 0);
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    void applyBehaviors(ArrayList<Vehicle> vehicles, PVector newPos) {
      PVector separateForce = separate(vehicles);
      PVector seekForce = seek(new PVector(newPos.x, newPos.y));
      separateForce.mult(2);
      seekForce.mult(1);
      applyForce(separateForce);
      applyForce(seekForce);
    }

    // A method that calculates a steering force towards a target
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector target) {
      PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target

      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);  // Limit to maximum steering force

        return steer;
    }

    // Separation
    // Method checks for nearby vehicles and steers away
    PVector separate (ArrayList<Vehicle> vehicles) {
      float desiredseparation = r*2;
      PVector sum = new PVector();
      int count = 0;
      // For every boid in the system, check if it's too close
      for (Vehicle other : vehicles) {
        float d = PVector.dist(location, other.location);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        sum.div(count);
        // Our desired vector is the average scaled to maximum speed
        sum.normalize();
        sum.mult(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
        sum.sub(velocity);
        sum.limit(maxforce);
      }
      return sum;
    }


    // Method to update location
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      location.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    void display() {
      fill(255,100,0);
      stroke(0);
      pushMatrix();
      translate(location.x, location.y);
      ellipse(0, 0, r, r);
      popMatrix();
    }
  }


  ArrayList<Vehicle> vehicles; // arraylist for vehicles
  ArrayList<ParticleSystem> explosions; // arraylist for explosion particlesystems

  int totalVehicles = 0; // total amount of vehicles spawned
  int maxVehicles = 200; // maximum amount of vehicles allowed to spawn

  PVector bossPos; // position of boss

  Boss() { // constructor for Boss class
    vehicles = new ArrayList<Vehicle>(); // init vehicles arraylist
    bossPos = new PVector(width/2, 0); // init PVector for boss position
    explosions = new ArrayList<ParticleSystem>(); // init arraylist for explosion particlesystems
  }

  void draw() {
    moveDown(); // move boss down
    drawOrb(); // draw the centre orb of boss
    drawVehicles(); // draw vehicles

    Iterator<ParticleSystem> it2 = explosions.iterator(); // create iterator object for particlesystems

    while (it2.hasNext ()) { // loop through particles
      ParticleSystem p = it2.next(); // get next particle from iterator
      if (p.totalParticles < 10) { // if less than 10 particles spawned in total
        p.addParticle(); // add particle
      }
      p.run(); // run particlesytem
      if (p.isDead()) { // if particle 'dead'
        it2.remove(); // remove particle from arraylist
      }
    }
  }

  void drawVehicles() { // function for drawing vehicles
    if (vehicles.size() < 50 && totalVehicles < maxVehicles) { // if less than 50 vehicles on screen and no more than maximum spawned in total
      addVehicle(bossPos); // add vehicle to position of boss
      totalVehicles++; // add 1 up to total vehicles spawned
    }
    for (Vehicle v : vehicles) {
      // Path following and separation are worked on in this function
      v.applyBehaviors(vehicles, bossPos);
      // Call the generic run method (update, borders, display, etc.)
      v.update();
      v.display();
    }
  }

  void drawOrb() {

    float multiplier = sq(totalVehicles - vehicles.size()) * 0.02; // make orb bigger as player progresses through level

    // draws the orb in the middle of the boss
    noStroke();
    fill(200, 200, 200, 200);
    ellipse(bossPos.x, bossPos.y, 20+multiplier*5, 20+multiplier*5);
    fill(50, 50, 200, 150);
    ellipse(bossPos.x, bossPos.y, 30+multiplier*3, 30+multiplier*3);
    fill(50, 50, 200, 100);
    ellipse(bossPos.x, bossPos.y, 40+multiplier*2, 40+multiplier*2);
    fill(50, 50, 200, 50);
    ellipse(bossPos.x, bossPos.y, 50+multiplier, 50+multiplier);
  }

  void moveDown() { // moves boss down in beginning of level
    if (bossPos.y <= width/4) { // if boss isn't at position
      bossPos.y += 1; // move down
    }
  }

  void addVehicle(PVector vehiclePos) { // adds vehicle
    vehicles.add(new Vehicle(vehiclePos.x+random(-width/2, width/2), vehiclePos.y-height/2)); // add new vehicle with a bit of randomness
  }

  boolean collide(PVector bulletPos) { // collide function
    ListIterator<Vehicle> it = vehicles.listIterator(); // create iterator for collision

    boolean returnBool = false; // boolean that will be returned, initially false; true when collision

    while (it.hasNext ()) {
      int colDist = 10; // margin for collision

      Vehicle d = it.next(); // load next from iterator


      if (d.location.x > bulletPos.x - colDist && d.location.x < bulletPos.x + colDist && d.location.y > bulletPos.y - colDist && d.location.y < bulletPos.y + colDist) { // collision detection

        explosions.add(new ParticleSystem(new PVector(bulletPos.x, bulletPos.y), new PVector(-0.2, 0.2), new PVector(-0.2, 0.2), new PVector(-1, 1), new PVector(-1, 1), 200, 255, 200, 255, 200, 255)); // add particles

        if(random(0,5) > 3) debris.addDebris(d.location); // sometimes adds some debris

        it.remove();
        returnBool = true; // make returnBool true; collision has occured.
      }
    }
    return returnBool; // return boolean
  }
}
