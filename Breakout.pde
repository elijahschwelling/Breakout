// Breakout

// Location of the ball
float lx = 500, ly = 250;
// Velocity of the ball
float dx, dy;
float tempx = 4, tempy = 4;
// Leftover balls
int numBalls = 3;

// Bricks
final int BRICKS_ACROSS = 10, BRICKS_DOWN = 4;
final int BRICK_WIDTH = 100, BRICK_HEIGHT = 20;
boolean bricks[][] = new boolean[BRICKS_ACROSS][BRICKS_DOWN];
int bricksBroken = 0;
boolean won = false;
boolean lost = false;

// Setup
void setup() {
  size(1000, 500);
  background(0);

  // Bricks
  for (int i = 0; i < BRICKS_ACROSS; i++)
    for (int j = 0; j < BRICKS_DOWN; j++)
      bricks[i][j] = true;
}

// Reset ball
void resetBall() {
  lx = width/2;
  ly = height/2;
  dx = 0;
  dy = 0;
}

// Draw bricks
void drawBricks() {
  for (int i = 0; i < BRICKS_ACROSS; i++) {
    for (int j = 0; j < BRICKS_DOWN; j++) {
      if (bricks[i][j]) {
        switch (j) {
        case 0: 
          fill(0, 0, 255);
          break;
        case 1:
          fill(255, 0, 0);
          break;
        case 2:
          fill(0, 255, 0);
          break;
        case 3:
          fill(255, 255, 0);
          break;
        }
      } else {
        fill(0);
      }
      rect(i*BRICK_WIDTH, j*BRICK_HEIGHT, 100, 20);
    }
  }
}

// Reset bricks
void resetBricks() {
  // Bricks
  for (int i = 0; i < BRICKS_ACROSS; i++)
    for (int j = 0; j < BRICKS_DOWN; j++)
      bricks[i][j] = true;

  drawBricks();
}

// Key pressed
void keyPressed() {
  // Launch ball
  if ((key == 'r') && (dx == 0) && (dy == 0)) {
    dx = tempx;
    dy = tempy;
  }

  if ((lost) || (won)) {
    if ((key == 'r')) {
      lost = false;
      won = false;
      resetBall();
      resetBricks();
      numBalls = 3;
      bricksBroken = 0;
      tempx = 4;
      tempy = 4;
    }
  }
}

// Draw and move ball
void draw() {
  fill(0);
  rect(0, 0, 1000, 500);

  // HUD
  fill(150);
  rect(0, 420, width, 100);

  if (((dx == 0) && (dy == 0)) && ((!lost && !won))) {
    textSize(40);
    text("BREAKOUT", 0, 420);
    textSize(20);
    text("PRESS R TO LAUNCH", 220, 420);
  }
  
  // Display lives
  fill(255);
  if (numBalls == 0)
    fill(150);
  ellipse(width/2-20, 470, 10, 10);
  if (numBalls == 1)
    fill(150);
  ellipse(width/2, 470, 10, 10);
  if (numBalls == 2)
    fill(150);
  ellipse(width/2+20, 470, 10, 10);

  // Bricks
  drawBricks();
  boolean collision = false;

  // Collisions
  for (int i = 0; i < BRICKS_ACROSS; i++) {
    for (int j = 0; j < BRICKS_DOWN; j++) {
      if (bricks[i][j]) {
        if ((ly >= j*BRICK_HEIGHT) && (ly <= j*BRICK_HEIGHT+20)) {
          if ((lx >= i*BRICK_WIDTH && lx <= i*BRICK_WIDTH+5) || (lx >= i*BRICK_WIDTH+95 && lx <= i*BRICK_WIDTH+100)) {
            dx = -dx;
            bricks[i][j] = false;
            collision = true;
          } else if ((lx >= i*BRICK_WIDTH+5 && lx <= i*BRICK_WIDTH+95)) {
            dy = -dy;
            bricks[i][j] = false;
            collision = true;
          }
        }
      }
    }
  }

  // Increment speed
  if (collision) {
    if (dy < 0)
      dy -= .1;
    else
      dy += .1;

    if (dx < 0)
      dx -= .1;
    else
      dx += .1;

    tempx = dx;
    tempy = dy;
    
    collision = false;

    // Update bricks broken
    bricksBroken++;

    // Check for win
    if (bricksBroken == 40)
      won = true;
  }

  // Ball
  fill(255);
  ellipse(lx, ly, 10, 10);
  lx = lx + dx;
  ly = ly + dy;

  // Wall collisions
  if (lx > 1000 || lx < 0) {
    dx = -dx;
  }
  if (ly < 0) {
    dy = -dy;
  }

  // Paddle collisions
  if (ly > 400)
    if ((lx > mouseX) && (lx < mouseX+100))
      dy = -dy;
    
  // Loss
  if (ly > 420) {
    numBalls--;

    if (numBalls == 0) {
      lost = true;
      resetBall();
    } else {
      resetBall();
    }
  }

  if (lost) {
    fill(150);
    textSize(40);
    text("YOU LOST", 620, 420);
    textSize(20);
    text("PRESS R TO RESET", 820, 420);
  }

  // Win
  if (won) {
    resetBall();
    fill(150);
    textSize(40);
    text("YOU WON", 620, 420);
    textSize(20);
    text("PRESS R TO RESET", 820, 420);
  }

  // Paddle
  fill(255, 0, 0);

  if (dx == 0 && dy == 0)
    rect(width/2-50, 400, 100, 20);
  else
    rect(mouseX, 400, 100, 20);
}