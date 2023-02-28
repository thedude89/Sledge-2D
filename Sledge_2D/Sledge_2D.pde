//Imports
import processing.sound.*;

//Sounds
SoundFile file, file1, file2;

// Bilder
PImage gameOverImg, TreeImg, SledImg, CoinImg;

//Schriftart
PFont Schriftart;

//Variablen
boolean startGame = false;
boolean gameOver = false;  
int gameSpeed = 30;
int distance;
int score;
int highscore;
//Startposition Spieler
int playerX = 200;
int playerY = 450;

// Player 
int playerWidth = 32;
int playerHeight = 32;

// Trees
int treeSize = 70; 
int treeSpeed = 5; 
int treeNum = 10; 
int[] treeX = new int[treeNum];
int[] treeY = new int[treeNum];
boolean[] treeActive = new boolean[treeNum];

// Coins
int coinNum = 50;
int coinSize = 25;
int coinX;
int coinY;
boolean coinActive = true;


void setup() {
  frameRate(gameSpeed);
  size(1000, 600);

  //Musik des Startbildschirms
  file = new SoundFile(this, "dragonball.mp3");
  file.loop();
  // Katsching Sound für Coin
  file1 = new SoundFile(this, "katsching.mp3");
  //crash sound
  file2 = new SoundFile(this, "crash.mp3");

  //Schriftart laden
  Schriftart = createFont("Schriftart.ttf", 50);
  textFont(Schriftart);
  
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
  // Game schwieriger machen, wenn Score > 20
  if (score > 20) {
    // Framerate basierend auf dem Scorewert erhöhen, aber auf 120 FPS begrenzen
    float fps = constrain(50 + score/10, 50, 120);
    frameRate(fps);
  }
  // Startbildschirm
  if (!startGame) {
    start_bildschirm();
  }
  // Musik spielt, nur so lange Spiel nicht gestartet ist
  else {
    file.stop();
  }
  
  // Spielt starten
  if (!gameOver && startGame) {
    distance +=1;
    
    // Bildschirm jedes mal übermalen, um die Spur zu verwischen
    fill(255);
    noStroke(); 
    rect(0, 0, width * 2, height*2);
    
    // Game Funktionen
    drawPlayer();
    moveTrees();
    drawTrees();
    checkCollisions();
    drawCoin();
    checkCoinCollision();
    drawStats();
  }

  if (gameOver) {
    // Wenn Game Over, Text anzeigen
    background(0);
    textAlign(CENTER, CENTER);
    textSize(64);
    fill(255, 0, 0);
    text("Game Over", width/2, height/2);

    // Restart Button
    fill(255, 0, 0);
    rect(width/2 + 25, height/2 +120, 150, 50);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("RESTART", width/2 + 25, height/2 +120);
  }
}

void start_bildschirm() {
  // Farben für Startbildschirm
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

  // Button um das Spiel zu starten
  if (mousePressed && mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
    mouseY > height/2 - 25 && mouseY < height/2 + 25) {
    startGame = true;
    fill(255);
    noStroke(); 
    rect(0, 0, width * 2, height*2);
  }
}



void drawPlayer() {
  //Schlitten 
  image(SledImg, playerX, playerY, playerWidth, playerHeight);
}

void drawTrees() {
  // Baume im Display anzeigen
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      image(TreeImg, treeX[i]-(TreeImg.width/2), treeY[i] - TreeImg.height, treeSize, treeSize);
    }
  }
}

void drawCoin() {
  // Coins auf dem Bildschirm zeigen
  for (int i = 0; i < coinNum; i++) {
    if (coinActive == true) {
      image(CoinImg, coinX, coinY, coinSize, coinSize);
    }
  }
}

// Bewegung der Trees nach unten
void moveTrees() {
  for (int i = 0; i < treeNum; i++) {
    // Bewegung des Baums nach unten
    treeY[i] += treeSpeed;
    // Wenn der Baum unteren Rand erreicht, dann oben auf neue random Position setzen
    if (treeY[i] > height) {
      treeX[i] = (int) random(width - treeSize);
      treeY[i] = (int) random(-height, 0);
      treeActive[i] = true;
    }
  }
  // Coin nach unten bewegen
  coinY += treeSpeed; 
  // Wenn Coin unteren Rand erreicht, wieder an random Position oben setzen
  if (coinY > height) {
    coinX = (int) random(width - coinSize);
    coinY = (int) random(-height, 0);
    coinActive = true;
  }
}


//Kollisionschecker für Baum und Schlitten
void checkCollisions() {
  for (int i = 0; i < treeNum; i++) {
    if (treeActive[i]) {
      // Untersten Teil des Baums berechnen
      int treeBottom = treeY[i] + treeSize;

      //Kollision nur checken, wenn Spieler nicht am Baum vorbei ist
      if (treeBottom > playerY) {
        // Kollisionspunkt des Spielers berechnen
        int playerCollisionX = playerX + (SledImg.width / 2);
        int playerCollisionY = playerY + SledImg.height;

        // Kollisionspunkt des Baums berechnen
        int treeCollisionX = treeX[i] + (TreeImg.width / 2);
        int treeCollisionY = treeY[i] + TreeImg.height;

        // Checken, ob die Kollisionspunkte überlappen
        if (dist(playerCollisionX, playerCollisionY, treeCollisionX, treeCollisionY) < (SledImg.width / 2) + 3) {
          gameOver = true;
          
          //crash sound
          file2.play();
        }
      }
    }
  }
}

// Kollision vom Coin mit Spieler checken
void checkCoinCollision() {
  if (coinActive) {
    float coinRadius = coinSize / 2.0;
    float playerRadius = playerWidth / 2.0;
    float distance = dist(playerX + playerRadius, playerY + playerRadius, coinX + coinRadius, coinY + coinRadius);
    if (distance < coinRadius + playerRadius) {
      coinActive = false;
      score += (10 + int(frameRate/10));
      
      // setzen des highscores
      if (score >= highscore) {
        highscore = score;
      }
      // Sound für Coin 
      file1.play();
    }
  }
}

//Score + Highscore + Distance im Display anzeigen
void drawStats() {
  fill(0);
  textAlign(LEFT);
  textSize(20);
  text("SCORE: " + score, 20, 30);
  text("HIGHSCORE: " + highscore, 20, 60);
  text("DISTANCE: " + distance, 20, 90);
}

//Tastatur Eingabe
void keyPressed() {
  if (!gameOver) {  
    // linker Key oder a
    if (keyCode == LEFT || keyCode == 65) {
      //Spieler nach links bewegen
      playerX -= 20;
    } else if (keyCode == RIGHT || keyCode == 68) {
      //Spieler nach rechts bewegen
      playerX += 20;
    } else if (keyCode == UP || keyCode == 87) {
      // Alle trees durchlaufen
      for (int i = 0; i < treeNum; i++) {
        //Wenn inaktiver Baum: 
        if (!treeActive[i]) {
          //Auf Position des Spielers setzen
          treeX[i] = playerX + playerWidth/2;
          treeY[i] = playerY - treeSize;
          //Baum aktivieren
          treeActive[i] = true;
          break;  
        }
      }
    }
    // Beweegung auf Bildschirm begrenzen
    if (playerX < 0) {
      playerX = 0;
    } else if (playerX > width - playerWidth) {
      playerX = width - playerWidth;
    }
  }
}

void mousePressed() {
  if (gameOver && mouseX >= width/2 - 50 && mouseX <= width/2 + 100 && mouseY >= height/2 + 100 && mouseY <= height/2 + 150) {
    // GameStates reset
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
