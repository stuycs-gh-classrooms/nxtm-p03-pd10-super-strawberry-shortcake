class Orb
{

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;
  float charge;


  /**
   The default constructor for Orb, sets the Orb to standardized values.
   */
  Orb()
  {
    bsize = random(10, MAX_SIZE);
    float x = random(bsize/2, width-bsize/2);
    float y = random(bsize/2, height-bsize/2);
    center = new PVector(x, y);
    mass = random(10, 100);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }


  /**
   A constructor for Orb that allows you to edit its position, size, and mass.
   */
  Orb(float x, float y, float s, float m)
  {
    bsize = s;
    mass = m;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }

  /**
   A function that moves the orb.
   */
  void move(boolean bounce)
  {
    if (bounce) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move


  /**
   Applies force onto the orb
   */
  void applyForce(PVector force)
  {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }


  /**
   Calculates the drag force acting upon the orb.
   */
  PVector getDragForce(float cd)
  {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }


  /**
   Gets the vector of the gravitational force that another orb applies onto this orb.
   */
  PVector getGravity(Orb other, float G)
  {
    float strength = G * mass*other.mass;
    //dont want to divide by 0!
    float r = max(center.dist(other.center), MIN_SIZE);
    strength = strength/ pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }

  /**
   getSpring()
   
   This should calculate the force felt on the calling object by
   a spring between the calling object and other.
   
   The resulting force should pull the calling object towards
   other if the spring is extended past springLength and should
   push the calling object away from o if the spring is compressed
   to be less than springLength.
   
   F = kx (ABhat)
   k: Spring constant
   x: displacement, the difference of the distance
   between A and B and the length of the spring.
   (ABhat): The normalized vector from A to B
   */
  PVector getSpring(Orb other, int springLength, float springK)
  {
    PVector direction = PVector.sub(other.center, this.center);
    direction.normalize();

    float displacement = this.center.dist(other.center) - springLength;
    float mag = springK * displacement;
    direction.mult(mag);
    return direction;
  }//getSpring
  
  /**
   getEF()
   
   Calculates the force felt by another objects electrostatic field onto this object.
   
   The resulting force should push the calling object away if the charges are both positive or both negative, 
   and the resulting force should pull the calling object if the charges are positive and negative, or neutral and positive, or vice versa.
   
   eK: electrostatic constant
   */
  
PVector getEF (Orb other, float eK) {
    PVector direction = PVector.sub(other.center, this.center);
    direction.normalize();
    float displacement = max(this.center.dist(other.center), MIN_SIZE);
    float mag = (eK * (this.charge * other.charge)) / sq(displacement);
    direction.mult(mag);
    direction.mult(-1);

    return direction;
}

  /**
   Makes the orb bounce off of the top and bottom sides of the box.
   */
  boolean yBounce()
  {
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce


  /**
   Makes the orb bounce off the left and right sides of the box.
   */
  boolean xBounce()
  {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    } else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce


  /**
   Checks if the orb is colliding with any other orbs.
   */
  boolean collisionCheck(Orb other)
  {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck


  /**
   Sets the color of the orb.
   */
  void setColor()
  {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    /*
    YOUR CONCISE EXPLANATION IN COLLOQUIAL ENGLISH 
    OF WHAT THIS PROCESSING BUILT-IN DOES...
    */
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));
  }//setColor


  //visual behavior
  void display()
  {
    noStroke();
    fill(c);
    circle(center.x, center.y, bsize);
    fill(0);
    
    if (mode == ELECTROSTATIC || mode == COMBINATION) {
      textSize(20);
      noStroke();
      text(int(charge),center.x,center.y);
      
    }
    

    //text(mass, center.x, center.y);
  }//display
}//Ball
