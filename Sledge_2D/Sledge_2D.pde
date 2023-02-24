//Imports
import processing.sound.*;
import gifAnimation.*;
SoundFile file, file1, file2;

// Bilder
PImage gameOverImg, TreeImg, SledImg, CoinImg, expl1, expl2, expl3;

//Gamestate
boolean startGame = false;
// Anfangs Code
int gameSpeed = 30;
int playerX = 200; // start position of player bar
int playerY = 450;
int playerWidth = 32;
int playerHeight = 32;
int treeSize = 70; // size of falling trees
int treeSpeed = 5; // speed of falling trees
int treeNum = 10; // number of falling trees
int[] treeX = new int[treeNum];
int[] treeY = new int[treeNum];
boolean[] treeActive = new boolean[treeNum];
boolean gameOver = false;  // Declare global variable to track whether the game is over
int coinNum = 50;
int score;
int highscore;
int coinSize = 25;
int coinX;
int coinY;
boolean coinActive = true;
int distance;


void setup() {
  frameRate(gameSpeed);
  size(1000, 600);

  //Musik des Spiels
  file = new SoundFile(this, "dragonball.mp3");
  file.loop();
  // Katsching Sound für Coin
  file1 = new SoundFile(this, "katsching.mp3");
  //crash sound
  file2 = new SoundFile(this, "crash.mp3");

  // Laden der Bilder
  gameOverImg = loadImage("game_over.png");
  TreeImg = loadImage("pine-tree.png");
  SledImg = loadImage("sledge.png");
  CoinImg = loadImage("coin.png");
  expl1 = loadImage("expl1.jpg");
  expl2 = loadImage("expl2.jpg");
  expl3 = loadImage("expl3.jpg");

  for (int i = 0; i < treeNum; i++) {
    treeX[i] = (int) random(width - treeSize);
    treeY[i] = (int) random(-height, 0);
    treeActive[i] = true;
  }
  coinX = (int) random(width - coinSize);
  coinY = (int) random(-height, 0);
}

void draw() {
  // Game schwieriger machen
  if (score > 20) {
    // Framerate basierend auf dem Scorewert erhöhen, aber auf 20 bis 120 FPS begrenzen
    float fps = constrain(50 + score/10, 50, 120);
    frameRate(fps);
  }

  if (!startGame) {
    start_bildschirm();
  }
  // Musik spielt, nur so lange Spiel nicht gestartet ist
  else {
    file.stop();
  }
  if (!gameOver && startGame) {
    distance +=1;
    // If the game is not over and start button is clicked, update the game state as usual
    // Bildschirm jedes mal übermalen, um die Spur zu verwischen
    fill(255);
    noStroke(); // Kein Rand um das Rechteck zeichnen
    rect(0, 0, width * 2, height*2);
    // Game Methods
    drawPlayer();
    moveTrees();
    drawTrees();
    checkCollisions();
    drawCoin();
    checkCoinCollision();
    drawStats();
  }

  if (gameOver) {
    // If the game is over, draw the game over image in the center of the screen
    image(gameOverImg, 0, 0, width, height);

    // Draw a restart button in the center of the screen
    fill(255, 0, 0);
    rect(width/2 + 25, height/2 +120, 150, 50);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("RESTART", width/2 + 25, height/2 +120);
  }
}

void start_bildschirm() {
  // Landschaft
  int snowColor = #FFFFFF;
  int treeColor = #2E8B57;
  int skyColor = #87CEEB;

  // Himmel
  background(skyColor);

  // Schnee
  noStroke();
  fill(snowColor);
  for (int i = 0; i < 200; i++) {
    int x = int(random(width));
    int y = int(random(height));
    ellipse(x, y, 5, 5);
  }

  // Bäume
  fill(treeColor);
  for (int i = 0; i < 10; i++) {
    int x = int(random(width));
    int y = int(random(height/2, height-50));
    int size = int(random(30, 50));
    triangle(x, y, x-size/2, y+size, x+size/2, y+size);
  }

  // Start Button
  rectMode(CENTER);
  fill(255, 0, 0);
  rect(width/2, height/2, 150, 50);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Spiel starten", width/2, height/2);
  // Titel vom Game
  textSize(75);
  fill(0);
  text("SLEDGE 2D", width/2, height/10);

  if (mousePressed && mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
    mouseY > height/2 - 25 && mouseY < height/2 + 25) {
    startGame = true;
    fill(255);
    noStroke(); // Kein Rand um das Rechteck zeichnen
    rect(0, 0, width * 2, height*2);
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
  if (coinY > height) {
    coinX = (int) random(width - coinSize);
    coinY = (int) random(-height, 0);
    coinActive = true;
  }
}

void drawTrees() {
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      image(TreeImg, treeX[i], treeY[i], treeSize, treeSize);
    }
  }
}

void drawCoin() {
  for (int i = 0; i < coinNum; i++) {
    if (coinActive == true) {
      image(CoinImg, coinX, coinY, coinSize, coinSize);
    }
  }
}

void checkCollisions() {
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      // Calculate the bottom edge of the tree
      int treeBottom = treeY[i] + treeSize;

      // Check for collision with the player only if the tree is not fully passed
      if (treeBottom > playerY) {
        // create hitbox for tree
        if (dist(playerX, playerY, treeX[i] + 2, treeY[i] + treeSize/2) < playerWidth/2 + 10) {
          // Explosions Animation machen:
          image(expl1, playerX, playerY, 50, 50);
          image(expl2, playerX, playerY, 50, 50);
          image(expl3, playerX, playerY, 50, 50);
          delay(300);
          gameOver = true;
          file2.play();
        }
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
      score += (10 + int(frameRate/10));
      // setzen des highscores
      if (score >= highscore){
        highscore = score;
      }
      // Sound für Coin spielen lassen
      file1.play();
    }
  }
}

void drawStats() {
  fill(0);
  textAlign(LEFT);
  textSize(20);
  text("SCORE: " + score, 20, 30);
  text("HIGHSCORE: " + highscore, 20, 60);
  text("DISTANCE: " + distance, 20, 90);
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
    distance = 0;
    frameRate(gameSpeed);
    for (int i = 0; i < treeNum; i++) {
      treeX[i] = (int) random(width - treeSize);
      treeY[i] = (int) random(-height, 0);
      treeActive[i] = true;
    }
  }
}
