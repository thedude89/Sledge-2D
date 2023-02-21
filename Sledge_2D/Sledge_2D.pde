// Bilder
PImage gameOverImg, TreeImg, SledImg, CoinImg;

// Anfangs Code
int playerX = 200; // start position of player bar
int playerY = 450;
int playerWidth = 32;
int playerHeight = 32;
int treeSize = 30; // size of falling trees
int treeSpeed = 5; // speed of falling trees
int treeNum = 10; // number of falling trees
int coinNum = 10;
int score = 0;
int coinSize = 25;
int coinX;
int coinY;
int[] treeX = new int[treeNum];
int[] treeY = new int[treeNum];
boolean[] treeActive = new boolean[treeNum]; 
boolean coinActive = true;
boolean gameOver = false;  // Declare global variable to track whether the game is over


void setup() {
  frameRate(50);
  size(1000, 600);
  
  // Laden der Bilder
  gameOverImg = loadImage("game_over.png");
  TreeImg = loadImage("pine-tree.png");
  SledImg = loadImage("sledge.png");
  CoinImg = loadImage("coin.png");
  
  for (int i = 0; i < treeNum; i++) {
    treeX[i] = (int) random(width - treeSize);
    treeY[i] = (int) random(-height, 0);
    treeActive[i] = true;
  }
  coinX = (int) random(width - coinSize);
  coinY = (int) random(-height, 0);
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
    drawCoin();
    checkCoinCollision();
    drawScore();
  }
}

void drawPlayer() {
  image(SledImg, playerX, playerY, playerWidth, playerHeight);
  // <a href="https://www.flaticon.com/free-icons/sledge" title="sledge icons">Sledge icons created by Freepik - Flaticon</a>
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
  
  coinY += treeSpeed; // Move the coin along with the trees
  if(coinY > height){
    coinX = (int) random(width - coinSize);
    coinY = (int) random(-height, 0);
    coinActive = true;
  }
}

void drawTrees() {
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      image(TreeImg, treeX[i], treeY[i], treeSize, treeSize);
      // <a href="https://www.flaticon.com/free-icons/christmas-tree" title="christmas tree icons">Christmas tree icons created by Freepik - Flaticon</a>
    }
  }
}

void drawCoin() { 
  for (int i = 0; i < coinNum; i++) {
    if(coinActive == true) {
      image(CoinImg, coinX, coinY, coinSize, coinSize);
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

void checkCoinCollision() {
  if (coinActive) {
    float coinRadius = coinSize / 2.0;
    float playerRadius = playerWidth / 2.0;
    float distance = dist(playerX + playerRadius, playerY + playerRadius, coinX + coinRadius, coinY + coinRadius);
    if (distance < coinRadius + playerRadius) {
      coinActive = false;
      score += 10;
    }
  }
}

void drawScore() {
  fill(0);
  textAlign(LEFT);
  textSize(20);
  text("SCORE: " + score, 20, 30);
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
    score = 0;
    for (int i = 0; i < treeNum; i++) {
      treeX[i] = (int) random(width - treeSize);
      treeY[i] = (int) random(-height, 0);
      treeActive[i] = true;
    }
  }
}
