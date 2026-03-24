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
float E_CONSTANT = 0.1;

int SPRING_LENGTH = 50;
float SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;


int GRAVITY = 0;
int SPRING = 1;
int DRAGF = 2;
int EF = 3;
int COMB = 4;


String[] modes = {"Gravity", "Spring", "Drag", "Electrostatic", "Combination"}; //these are the modes we can switch between for different simulations
boolean[] toggles = new boolean[5];

String[] defaultModes = {"Moving", "Bounce"}; //modes for all force simulation except combination
boolean[] defaultToggles = new boolean[2];




FixedOrb earth;
Orb[] orbs;
int orbCount;


void setup()
{
  size(600, 600);

  //Part 0: Write makeOrbs below
  earth = new FixedOrb(width / 2, height / 2, 80, 50);
  
  orbCount = NUM_ORBS;
  
  makeOrbs(); // must be recalled when a new simulation is triggered
}//setup


void draw()
{
  background(255);
  displayMode();
  
  
  /*
  earth.display();

  
  for (int o=0; o < orbCount; o++) {
    orbs[o].display();


    if (o < orbCount - 1) {
      drawSpring(orbs[o], orbs[o+1]);
    }
  }

  if (toggles[MOVING]) {
    applySprings();

    for (int o=0; o < orbCount; o++) {
      if (toggles[GRAVITY]) {
        PVector gForce = orbs[o].getGravity(earth, G_CONSTANT);
        orbs[o].applyForce(gForce);
      }
      if (toggles[DRAGF]) {
        orbs[o].applyForce(orbs[o].getDragForce(D_COEF));
      }
    }

    for (int o=0; o < orbCount; o++) {
      orbs[o].move(toggles[BOUNCE]);
    }
  }*/
  
  if (toggles[GRAVITY]) {
    earth.display();
    gravitySim();
  }
  
  else if (toggles[SPRING]) {
    springSim();
  }
  
  else if (toggles[DRAGF]) {
    dragSim();
  }
  
  
  
  
  
  
}


void gravitySim() {
  
  

  for (int o = 0; o < orbs.length; o++) {
    if (orbs[o] != null) {
      orbs[o].display();
      PVector gForce = orbs[o].getGravity(earth, G_CONSTANT);
      orbs[o].applyForce(gForce);
      orbs[o].move(defaultToggles[BOUNCE]);
    }
  }
}

void springSim() {
  
  
  for (int o = 0; o < orbs.length; o++) {
    if (orbs[o] != null) {
      orbs[o].display();

      if (o < orbs.length - 1) {
        drawSpring(orbs[o], orbs[o+1]);
      }
    }
  }
  applySprings();

  for (int i = 0; i < orbs.length; i++) {
    if (orbs[i] != null) {
      orbs[i].move(defaultToggles[BOUNCE]);
    }
  }
}


void dragSim() {

  for (int o = 0; o < orbs.length; o++) {
    if (orbs[o] != null) {
      orbs[o].display();

      PVector dragForce = orbs[o].getDragForce(D_COEF);
      orbs[o].applyForce(dragForce);

      orbs[o].move(defaultToggles[BOUNCE]);
    }
  }
}

void EFSim() {

  for (int o = 0; o < orbs.length; o++) {
    if (orbs[o] != null) {
      orbs[o].display();
    }
  }

  applyElectro();

  for (int i = 0; i < orbs.length; i++) {
    if (orbs[i] != null) {
      orbs[i].move(defaultToggles[BOUNCE]);
    }
  }
}

void makeOrbs() {
  orbCount = NUM_ORBS;
  orbs = new Orb[orbCount];


  for (int i = 0; i < orbCount; i++) {
    orbs[i] = new Orb();
    orbs[i].center.x = random(0 + orbs[i].bsize, width - orbs[i].bsize);
    orbs[i].center.y = random(0 + orbs[i].bsize, height - orbs[i].bsize);
  }
}//makeOrbs


void drawSpring(Orb o0, Orb o1)
{
  float d = dist(o0.center.x, o0.center.y, o1.center.x, o1.center.y);
  if (SPRING_LENGTH < d) {
    stroke(255, 0, 0);
  }
  if (SPRING_LENGTH > d) {
    stroke(0, 255, 0);
  }
  if (SPRING_LENGTH == d) {
    stroke(0);
  }

  line(o0.center.x, o0.center.y, o1.center.x, o1.center.y);
  stroke(0);
}//drawSpring


void applySprings()
{
  PVector f;
  PVector bSpring;
  PVector fSpring;
  for (int i = 1; i < orbCount; i++) {
    if (orbs[i] != null) {
      if (i == orbCount - 1) {
        bSpring = orbs[i].getSpring(orbs[i - 1], SPRING_LENGTH, SPRING_K);
        f = bSpring;
      } else {
        bSpring = orbs[i].getSpring(orbs[i - 1], SPRING_LENGTH, SPRING_K);
        fSpring = orbs[i].getSpring(orbs[i + 1], SPRING_LENGTH, SPRING_K);
        f = PVector.add(bSpring, fSpring);
      }
      orbs[i].applyForce(f);
    }
  }
}//applySprings

void applyElectro() {
  PVector f;
  PVector bEF;
  PVector fEF;

  for (int i = 1; i < orbCount; i++) {

    if (i == orbCount - 1) {
      bEF = orbs[i].getEF(orbs[i-1], E_CONSTANT);
      f = bEF;
    } else {
      bEF = orbs[i].getEF(orbs[i-1], E_CONSTANT);
      fEF = orbs[i].getEF(orbs[i+1], E_CONSTANT);
      f = PVector.add(bEF, fEF);
    }
    orbs[i].applyForce(f);
  } //applyElectro
}

void addOrb()
{
  int index = findAvailableIndex();
  if (index == -1) {
    Orb[] tempArray = new Orb[orbCount + 1];
    arrayCopy(orbs, tempArray);
    tempArray[orbCount] = new Orb();
    tempArray[orbCount].center.x = orbs[orbCount - 1].center.x + SPRING_LENGTH;
    tempArray[orbCount].center.y = orbs[orbCount - 1].center.y;
    orbCount++;
    orbs = tempArray;
  } else {
    orbs[index] = new Orb();
  }
}//addOrb


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
  int previous = GRAVITY;
  
  if (key == ' ') {
    defaultToggles[MOVING]  = !defaultToggles[MOVING];
  }
  if (key == 'b') {
    defaultToggles[BOUNCE]  = !defaultToggles[BOUNCE];
  }
  
  
  if (key == '1') {
    toggles[GRAVITY] = !toggles[GRAVITY];
    
    for (int i = 0; i < GRAVITY; i++) {
      toggles[i] = false;
    }
    for (int j = GRAVITY+1; j < toggles.length; j++) {
      toggles[j] = false;
    }
  }
  
  if (key == '2') {
    toggles[SPRING] = !toggles[SPRING];
    
    for (int i = 0; i < SPRING; i++) {
      toggles[i] = false;
    }
    for (int j = SPRING+1; j < toggles.length; j++) {
      toggles[j] = false;
    }
  }
  
  if (key == '3') {
    toggles[DRAGF] = !toggles[DRAGF];
    
    for (int i = 0; i < DRAGF; i++) {
      toggles[i] = false;
    }
    for (int j = DRAGF+1; j < toggles.length; j++) {
      toggles[j] = false;
    }
  }
  
  if (key == '4') {
    toggles[EF] = !toggles[EF];
    
    for (int i = 0; i < EF; i++) {
      toggles[i] = false;
    }
    for (int j = EF+1; j < toggles.length; j++) {
      toggles[j] = false;
    }
  }
  
  if (key == '5') {
    toggles[COMB] = !toggles[COMB];
    
    for (int i = 0; i < COMB; i++) {
      toggles[i] = false;
    }
    for (int j = COMB+1; j < toggles.length; j++) {
      toggles[j] = false;
    }
  }
  
  if (key == 'p') {
    makeOrbs();
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
}//keyPressed


void displayMode()
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
}//display
