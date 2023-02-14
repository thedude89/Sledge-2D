Spot[] spots; // Declare array
Spot safer; // Declare safer Object on Ground
int saferWidth = 40;
int saferHeight = 10;
int score = 0;
int offsetY = 60;
PFont fScore;
int fontSize = 50;
int numSpots = 9; // Number of objects
int speedFactor = 1000;
int maxDia = 50;

void setup() {
  size(1000, 600);
  fScore = createFont("Arial", 80, true);
  
  //Create Safer on Ground to catch Spots
  safer = new Spot(width/2, height-offsetY, offsetY, 0);
  //Create Spots
  spots = new Spot[numSpots]; // Create array
  for (int i = 0; i < spots.length; i++) {
    float dia = random(10,maxDia); // Calculate diameter
    float x = random(dia/2, width-dia); //set Start X Position
    float y = random(-height, 0); //set Start Y Position
    float speed = random(0.1, 2.0); //set SpotSpeed
    // Create each object
    spots[i] = new Spot(x, y, dia, speed);
  }
  noStroke();
}
void draw() {
  //set Transparency and length of spot shadow with fill color of rect over background
  fill(0, 20);
  rect(0, 0, width, height);
  //draw all Spot-Objects
  for (int i=0; i < spots.length; i++) {
    spots[i].move(); // Move each object
    spots[i].display(); // Display each object
  }
  //draw Safer on mouseX Position
  safer.x = mouseX;
  safer.displaySafer();
  //draw actual Score
  fill(255);
  textFont(fScore, fontSize);
  text(score, fontSize/2, fontSize*1.3);
}

class Spot {
  float x, y;         // X-coordinate, y-coordinate
  float diameter;     // Diameter of the circle
  float speed;        // Distance moved each frame
  color col = color(random(0,255),random(0,255),random(0,255));
  
  // Constructor
  Spot(float xpos, float ypos, float dia, float sp) {
    x = xpos;
    y = ypos;
    diameter = dia;
    speed = sp;
  }
    
  void move() {
    y += (speed * 1);
    //Check if Safer catched the spot >> compare xPos Safer with xPos Spot on safer height
    if (y+diameter/2 > height-offsetY && (x > safer.x-(saferWidth/2) && x < safer.x+(saferWidth/2))) {
      score++;
      y=0;
      x=random(0,width);
      speed = random(0.3, 2.0)+frameCount/speedFactor;
      diameter = random(10,maxDia);
      col = color(random(0,255),random(0,255),random(0,255));
    }
    
    //If Spot leaves the bottom of SaferHeight, renew start parameters
    if (y > height) { 
      y=0;
      x=random(0,width);
      speed = random(0.3, 2.0)+frameCount/speedFactor;
      diameter = random(10,maxDia);
      col = color(random(0,255),random(0,255),random(0,255));
    } 
  }
  
  void display() {
    fill(col);
    ellipse(x, y, diameter, diameter);
  }
  
  void displaySafer() {
    fill(col);
    rect(x-saferWidth/2, y-saferHeight/2, saferWidth, saferHeight);
  }
} //end of Spot Class
