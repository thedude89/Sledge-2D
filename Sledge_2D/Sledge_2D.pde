// Bilder
PImage gameOverImg;


// Anfangs Code
int playerX = 200; // start position of player bar
int playerY = 450;
int playerWidth = 50;
int playerHeight = 10;
int pointSize = 10; // size of falling points
int pointSpeed = 5; // speed of falling points
int pointNum = 10; // number of falling points
int[] pointX = new int[pointNum];
int[] pointY = new int[pointNum];
boolean[] pointActive = new boolean[pointNum]; 
boolean gameOver = false;  // Declare global variable to track whether the game is over

void setup() {
  frameRate(50);
  size(1000, 600);
  
  // Laden des Game Over Bilds
  gameOverImg = loadImage("game_over.png");
  
  for (int i = 0; i < pointNum; i++) {
    pointX[i] = (int) random(width - pointSize);
    pointY[i] = (int) random(-height, 0);
    pointActive[i] = true;
  }
}  

void draw() {
  background(255);
  
  if (gameOver) {
    // If the game is over, draw the game over image in the center of the screen
    image(gameOverImg, 0, 0,width,height);
    noLoop(); // Stopt den Game Loop
  } else {
    // If the game is not over, update the game state as usual
    drawPlayer();
    movePoints();
    drawPoints();
    checkCollisions();
  }
}

void drawPlayer() {
  fill(0, 200, 0);
  rect(playerX, playerY, playerWidth, playerHeight);
}

void movePoints() {
  for (int i = 0; i < pointNum; i++) {
    pointY[i] += pointSpeed;
    if (pointY[i] > height) {
      pointX[i] = (int) random(width - pointSize);
      pointY[i] = (int) random(-height, 0);
      pointActive[i] = true;
    }
  }
}

void drawPoints() {
  fill(200, 0, 0);
  for (int i = 0; i < pointNum; i++) {
    if (pointActive[i]) {
      ellipse(pointX[i], pointY[i], pointSize, pointSize);
    }
  }
}

void checkCollisions() {
  for (int i = 0; i < pointNum; i++) {
    if (pointActive[i]) {
      if (pointY[i] + pointSize >= playerY && pointX[i] >= playerX && pointX[i] + pointSize <= playerX + playerWidth) {
        gameOver = true;
      } else if (pointY[i] >= height) {
        pointX[i] = (int) random(width - pointSize);
        pointY[i] = (int) random(-height, 0);
        pointActive[i] = true;
      }
    }
  }
}

void keyPressed() {
  if (!gameOver) {  // Only allow player input if game is not over
    if (keyCode == LEFT || keyCode == 65) {
      playerX -= 20;
    } else if (keyCode == RIGHT || keyCode == 68) {
      playerX += 20;
    }
    if (playerX < 0) {
      playerX = 0;
    } else if (playerX > width - playerWidth) {
      playerX = width - playerWidth;
    }
  }
}
