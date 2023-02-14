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

void setup() {
  frameRate(50);
  size(1000, 600);
  for (int i = 0; i < pointNum; i++) {
    pointX[i] = (int) random(width - pointSize);
    pointY[i] = (int) random(-height, 0);
    pointActive[i] = true;
  }
}

void draw() {
  background(255);
  drawPlayer();
  movePoints();
  drawPoints();
  checkCollisions();
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
        pointActive[i] = false;
      }
    }
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    playerX -= 20;
  } else if (keyCode == RIGHT) {
    playerX += 20;
  }
  if (playerX < 0) {
    playerX = 0;
  } else if (playerX > width - playerWidth) {
    playerX = width - playerWidth;
  }
}
