// Bilder
PImage gameOverImg;

// Anfangs Code
int playerX = 200; // start position of player bar
int playerY = 450;
int playerWidth = 50;
int playerHeight = 10;
int treeSize = 30; // size of falling trees
int treeSpeed = 5; // speed of falling trees
int treeNum = 10; // number of falling trees
int[] treeX = new int[treeNum];
int[] treeY = new int[treeNum];
boolean[] treeActive = new boolean[treeNum]; 
boolean gameOver = false;  // Declare global variable to track whether the game is over


void setup() {
  frameRate(50);
  size(1000, 600);
  
  // Laden der Bilder
  gameOverImg = loadImage("game_over.png");
  
  for (int i = 0; i < treeNum; i++) {
    treeX[i] = (int) random(width - treeSize);
    treeY[i] = (int) random(-height, 0);
    treeActive[i] = true;
  }
}  

void draw() {
  background(255);

  if (gameOver) {
    // If the game is over, draw the game over image in the center of the screen
    image(gameOverImg, 0, 0, width, height);
    
    // Draw a restart button in the center of the screen
    fill(255,0,0);
    rect(width/2 - 50, height/2 +100, 150, 50);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("RESTART", width/2 + 25, height/2 +120);
  } else {
    // If the game is not over, update the game state as usual
    drawPlayer();
    moveTrees();
    drawTrees();
    checkCollisions();
  }
}

void drawPlayer() {
  fill(0, 200, 0);
  rect(playerX, playerY, playerWidth, playerHeight);
}

void moveTrees() {
  for (int i = 0; i < treeNum; i++) {
    treeY[i] += treeSpeed;
    if (treeY[i] > height) {
      treeX[i] = (int) random(width - treeSize);
      treeY[i] = (int) random(-height, 0);
      treeActive[i] = true;
    }
  }
}

void drawTrees() {
  fill(0, 200, 0);
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      triangle(treeX[i] + treeSize/2, treeY[i], treeX[i], treeY[i] + treeSize, treeX[i] + treeSize, treeY[i] + treeSize);
    }
  }
}

void checkCollisions() {
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      if (treeActive[i] && treeY[i] + treeSize >= playerY && 
    treeX[i] <= playerX + playerWidth && 
    treeX[i] + treeSize >= playerX) {
        gameOver = true;
      } else if (treeY[i] >= height) {
        treeX[i] = (int) random(width - treeSize);
        treeY[i] = (int) random(-height, 0);
        treeActive[i] = true;
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
    } else if (keyCode == UP || keyCode == 87) {
      // Add a green triangle at the player's position
      for (int i = 0; i < treeNum; i++) {
        if (!treeActive[i]) {
          treeX[i] = playerX + playerWidth/2;
          treeY[i] = playerY - treeSize;
          treeActive[i] = true;
          break;  // Stop searching for an inactive point
        }
      }
    }
    if (playerX < 0) {
      playerX = 0;
    } else if (playerX > width - playerWidth) {
      playerX = width - playerWidth;
    }
  }
}

void mousePressed() {
  if (gameOver && mouseX >= width/2 - 50 && mouseX <= width/2 + 100 && mouseY >= height/2 + 100 && mouseY <= height/2 + 150) {
    // Reset the game state
    playerX = 200;
    playerY = 450;
    gameOver = false;
    for (int i = 0; i < treeNum; i++) {
      treeX[i] = (int) random(width - treeSize);
      treeY[i] = (int) random(-height, 0);
      treeActive[i] = true;
    }
  }
}
