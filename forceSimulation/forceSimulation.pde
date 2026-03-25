/** -----------------------------------------------
 SpringArrayDriver (Most Work Goes Here)
 
 TASK:
 You will write a program that creates an array of orbs. 
 When run, the simulation should show the orbs,
 connected by springs,
 moving according to the push/pull of the spring forces.
 
 Earth gravity will be a toggle-able option,
 as well as whether the simulation is running movement or not.
 
 Part 0: Create and populate the array of orbs.
 
 Part 1: Draw the "springs" connecting the orbs.
 
 Part 2: Calculate and apply the spring force to the
 orbs in the array.
 Part 3: Apply earth based gravity and drag if those
 options are turned on.
 
 Part 4: Allow for the removal and addition of orbs
 
 CONCURRENT TASK:
 As you go, or just before you submit,
 Fill in the placeholder comment zones with YOUR OWN WORDS.
 ----------------------------------------------- */


int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 0.1;
float D_COEF = 0.1;
float E_CONSTANT = 5000;

int SPRING_LENGTH = 50;
float SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAGF = 3;
int SPRING = 4;
int ELECTROSTATIC = 5;
int COMBINATION = 6;
boolean[] toggles = new boolean[7];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag","Spring","Electrostatic","Combination"};
int mode;

FixedOrb earth;
Orb[] orbs;
int orbCount;

int s = GRAVITY; //used to switch between constants in combination

void setup()
{
  size(600, 600);

  //Part 0: Write makeOrbs below
  earth = new FixedOrb(width / 2, height / 2, 80 , 50);
  makeOrbs(true);
  
}//setup


void draw()
{
  background(255);
    mode = -1;
  for (int i = 2; i < toggles.length; i++) {
    if (toggles[i]) {
      mode = i;
    }
  }
  displayMode(mode);

  //draw the orbs and springs
  for (int o=0; o < orbCount; o++) {
    orbs[o].display();
  }

  if (toggles[MOVING]) {
    //part 3: apply other forces if toggled on
    for (int o=0; o < orbCount; o++) {
      if (toggles[GRAVITY]) {
        for (int other = 0; other < orbCount; other++) {
          if (o != other) {
            PVector gForce = orbs[o].getGravity(orbs[other], G_CONSTANT);
            orbs[o].applyForce(gForce);
          }

        }
      }
      if (toggles[DRAGF]) {
        orbs[o].applyForce(orbs[o].getDragForce(D_COEF));
      }
      
      if (toggles[ELECTROSTATIC]) {
        for (int other = 0; other < orbCount; other++) {
          if (o != other && orbs[o] != null && orbs[other] != null) {
           
        PVector eForce = orbs[o].getEF(orbs[other], E_CONSTANT);
        orbs[o].applyForce(eForce);
      }
        }
      }
      
      if (toggles[SPRING]) {
        applySprings();
        if (o < orbCount - 1) {
          drawSpring(orbs[o],orbs[o+1]);
        }
      }      
      
      if (toggles[COMBINATION]) {
        for (int other = 0; other < orbCount; other++) {
          if (o != other) {
            PVector gForce = orbs[o].getGravity(orbs[other], G_CONSTANT);
            orbs[o].applyForce(gForce);            
            orbs[o].applyForce(orbs[o].getDragForce(D_COEF));
        PVector eForce = orbs[o].getEF(orbs[other], E_CONSTANT);            
        orbs[o].applyForce(eForce);   
        applySprings();
        if (o < orbCount - 1) {
          drawSpring(orbs[o],orbs[o+1]);
        }
          }
        }
        }
      
    }//gravity, drag, electrostatic

    for (int o=0; o < orbCount; o++) {
      orbs[o].move(toggles[BOUNCE]);
    }
  }//moving
}//draw


/**
 makeOrbs(boolean ordered)
 
 Set orbCount to NUM_ORBS
 Initialize and create orbCount Orbs in orbs.
 All orbs should have random mass and size.
 The first orb should be a FixedOrb
 If ordered is true:
 The orbs should be spaced SPRING_LENGTH distance
 apart along the middle of the screen.
 If ordered is false:
 The orbs should be positioned radomly.
 
 Each orb will be "connected" to its neighbors in the array.
 */
void makeOrbs(boolean ordered)
{
  orbCount = NUM_ORBS;
  orbs = new Orb[orbCount];
  if (mode != ELECTROSTATIC) {
    orbs[0] = earth;
  } else {
    orbs[0] = new Orb();
  }
  for (int i = 1; i < orbCount; i++) {
    orbs[i] = new Orb();
    
    if (ordered) {
      orbs[i].center.x = (SPRING_LENGTH / 2) + (i * SPRING_LENGTH);
      orbs[i].center.y = height / 2;
    }
    else {
      orbs[i].center.x = random(0 + orbs[i].bsize, width - orbs[i].bsize);
      orbs[i].center.y = random(0 + orbs[i].bsize, height - orbs[i].bsize);
    }
    
    if (toggles[ELECTROSTATIC] || toggles[COMBINATION]) {
      orbs[i].charge = int(random(-5,6));
    }
  }
}
/**
 drawSpring(Orb o0, Orb o1)
 
 Draw a line between the two Orbs.
 Line color should change as follows:
 red: The spring is stretched.
 green: The spring is compressed.
 black: The spring is at its normal length
 */
void drawSpring(Orb o0, Orb o1)
{
  float d = dist(o0.center.x,o0.center.y,o1.center.x,o1.center.y);
  if (SPRING_LENGTH < d) {
    stroke(255,0,0);
  }
  if (SPRING_LENGTH > d) {
    stroke(0,255,0);
  }
  if (SPRING_LENGTH == d) {
    stroke(0);
  }

  line(o0.center.x,o0.center.y,o1.center.x,o1.center.y);
  stroke(0);
}//drawSpring


/**
 applySprings()
 
 FIRST: Fill in getSpring in the Orb class.
 
 THEN:
 Go through the Orbs array and apply the spring
 force correctly for each orb. We will consider every
 orb as being "connected" via a spring to is
 neighboring orbs in the array.
 */
void applySprings()
{
  PVector f;
  PVector bSpring;
  PVector fSpring;
  for (int i = 1; i < orbCount; i++) {
    if (i == orbCount - 1) {
      bSpring = orbs[i].getSpring(orbs[i - 1], SPRING_LENGTH, SPRING_K);
      f = bSpring;
    }
    else {
      bSpring = orbs[i].getSpring(orbs[i - 1], SPRING_LENGTH, SPRING_K);
      fSpring = orbs[i].getSpring(orbs[i + 1], SPRING_LENGTH, SPRING_K);
      f = PVector.add(bSpring,fSpring);
    }
    orbs[i].applyForce(f);
  }
}//applySprings

/**
 applyCharge()
 
 applies a random charge to each of the orbs
 */
 
void applyCharge() {
  for (int i = 0; i < orbCount; i++) {
    orbs[i].charge = int(random(-3,3));   
  }
}


/**
 addOrb()
 
 Add an orb to the arry of orbs.
 
 If the array of orbs is full, make a
 new, larger array that contains all
 the current orbs and the new one.
 (check out arrayCopy() to help)
 */
void addOrb()
{
  int index = findAvailableIndex();
  if (index == -1) {
    orbCount++;
    Orb[] tempArray = new Orb[orbCount];
    arrayCopy(orbs, tempArray);
    tempArray[orbCount-1] = new Orb();
    tempArray[orbCount-1].center.x = orbs[orbCount - 2].center.x + SPRING_LENGTH;
    tempArray[orbCount-1].center.y = orbs[orbCount - 2].center.y;
    orbs = tempArray;
  }
  else {
    orbs[index] = new Orb();
  }
}//addOrb

/**
 findAvailableIndex()
 
 Checks for an empty index in the orbs array. Returns the value of the closest empty index to 0 if successful,
 otherwise, returns a -1 if there are no available indexes.
 */

int findAvailableIndex() { // finds the first available index for an orb
  for (int i = 0; i < orbs.length; i++) { // checks every index in orbs.
    if (orbs[i] == null) { // if there is nothing, then return the index number
      return i;
    }
  }
  return -1; // if there is not something return -1
}

/**
 keyPressed()
 
 Toggle the various modes on and off
 Use 1 and 2 to setup model.
 Use - and + to add/remove orbs.
 */
void keyPressed()
{
  if (key == ' ') {
    toggles[MOVING]  = !toggles[MOVING];
    
  }
  if (key == 'g') {
    toggles[GRAVITY] = !toggles[GRAVITY];
    println(toggles[GRAVITY]);
    toggles[DRAGF] = false;
    toggles[ELECTROSTATIC] = false;
    toggles[COMBINATION] = false;
    toggles[SPRING] = false;    
    mode = GRAVITY;
    makeOrbs(false);
  }
  if (key == 'b') {
    toggles[BOUNCE]  = !toggles[BOUNCE];
    
    
  }
  if (key == 'd') {
    toggles[DRAGF]   = !toggles[DRAGF];
    toggles[GRAVITY] = false;
    toggles[ELECTROSTATIC] = false;
    toggles[COMBINATION] = false;
    toggles[SPRING] = false;
    mode = DRAGF;
    
  }
  if (key == 's') {
    toggles[SPRING] = !toggles [SPRING];
    toggles[GRAVITY] = false;
    toggles[ELECTROSTATIC] = false;
    toggles[COMBINATION] = false;
    toggles[DRAGF] = false;
    mode = SPRING;
    makeOrbs(false);
  }
  if (key == 'e') {
    toggles[ELECTROSTATIC]   = !toggles[ELECTROSTATIC];
    toggles[GRAVITY] = false;
    toggles[DRAGF] = false;
    toggles[COMBINATION] = false;
    toggles[SPRING] = false;
    mode = ELECTROSTATIC;
    makeOrbs(false);
    applyCharge();
  }
  if (key == 'c') {
    toggles[COMBINATION]   = !toggles[COMBINATION];
    toggles[GRAVITY] = false;
    toggles[DRAGF] = false;
    toggles[ELECTROSTATIC] = false;
    toggles[SPRING] = false;
    mode = COMBINATION;
    makeOrbs(false);
    applyCharge();
  }
  if (key == 'o') {
    makeOrbs(true);
  }
  if (key == 'u') {
    makeOrbs(false);
  }

  if (key == '-') {
    if (orbCount > 2) {
      orbs[orbCount - 1] = null;
      orbCount--;
    }
  }//removal
  if (key == '=' || key == '+') {
    addOrb();
  }//addition
  //separate simulations
  if (keyCode == UP) {
    if (toggles[GRAVITY]) {
      G_CONSTANT *= 10;
      G_CONSTANT += 1;
      G_CONSTANT /= 10;
    }
    else if (toggles[DRAGF]) {
      D_COEF *= 10;
      D_COEF += 1;
      D_COEF /= 10;
    }
    else if (toggles[SPRING]) {
      SPRING_K *= 1000;
      SPRING_K += 5;
      SPRING_K /= 1000;
    }
  }
  if (keyCode == DOWN) {
    if (toggles[GRAVITY]) {
      G_CONSTANT *= 10;
      G_CONSTANT -= 1;
      G_CONSTANT /= 10;
    }
    else if (toggles[DRAGF]) {
      D_COEF *= 10;
      D_COEF -= 1;
      D_COEF /= 10;
    }
    else if (toggles[SPRING]) {
      SPRING_K *= 1000;
      SPRING_K -= 5;
      SPRING_K /= 1000;
    }
  }
  
  if (toggles[COMBINATION]) {
    
    if (keyCode == LEFT) {
      if (s == GRAVITY) {
        s = SPRING;
      }
      else {
        s--;
      }
    }
    
    if (keyCode == RIGHT) {
      if (s == SPRING) {
        s = GRAVITY;
      }
      else {
        s++;
      }
    }
    
    if (keyCode == UP) {
      if (s == GRAVITY) {
        G_CONSTANT *= 10;
        G_CONSTANT += 1;
        G_CONSTANT /= 10;
      }
      else if (s == DRAGF) {
        D_COEF *= 10;
        D_COEF += 1;
        D_COEF /= 10;
      }
      else if (s == SPRING) {
        SPRING_K *= 1000;
        SPRING_K += 5;
        SPRING_K /= 1000;
        //SPRING_K += 0.005;
      }
    }
    
    if (keyCode == DOWN) {
      if (s == GRAVITY) {
        G_CONSTANT *= 10;
        G_CONSTANT -= 1;
        G_CONSTANT /= 10;
      }
      else if (s == DRAGF) {
        D_COEF *= 10;
        D_COEF -= 1;
        D_COEF /= 10;
      }
      else if (s == SPRING) {
        SPRING_K *= 1000;
        SPRING_K -= 5;
        SPRING_K /= 1000;
        //SPRING_K -= 0.005;
      }
    }
  }
  
  
}//keyPressed


void displayMode(int mode)
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
  
  //gravity mode
  if (mode == GRAVITY) {
    text("G: "+G_CONSTANT,0,30);
  }
  
  // drag mode
  
  if (mode == DRAGF) {
    text("Drag: "+D_COEF,0,30);
  }
  
  // spring mode
  
  if (mode == SPRING) {
    text("Spring K: "+SPRING_K,0,30);
  }
  
  //electrostatic mode
  
  if (mode == ELECTROSTATIC) {
    
    text("Coulomb K: "+E_CONSTANT,0,30);
  }
  
  // combination mode
  
  if (mode == COMBINATION) {
    fill(255,0,0);
    if (s == GRAVITY) {
      rect(0,30,20,20);
    }
    else if (s == DRAGF) {
      rect(0,50,45,20);
    }
    else if (s == SPRING) {
      rect(0,70,75,20);
    }
    else if (s == ELECTROSTATIC) {
      rect(0,90,100,20);
    }
    
    fill(0);
    text("G: "+G_CONSTANT,0,30);
    text("Drag: "+D_COEF,0,50);
    text("Spring K: "+SPRING_K,0,70);
    text("Coulomb K: "+E_CONSTANT,0,90);
    
   
  }
  
  // combination mode
}//display
