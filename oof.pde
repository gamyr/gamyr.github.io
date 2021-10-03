Player[] players = new Player[0];
Player main;
PImage lose;
int lost = 0;
float x = 3;
int score = 0;

void setup() {
  rectMode(CENTER);
  size(500, 500);  
  main = new Player(0);
  lose = loadImage("lose.png");
}

void draw() {
  if (lost == 0) {
    background(0);
    if ((frameCount%((round((frameRate+1)*x/10)*10)+1) == 0)) {
      players = (Player[])append(players, new Player(1));
      score += 1;
      if (x > 0.75) x -= 0.1;
    }
    for (int i = 0; i<players.length; i++) {
      players[i].update();
      for (int j = 1; j<main.bullets.length; j++) {
        if (rectBall(players[i].x, players[i].y, players[i].size, players[i].size, main.bullets[j].x, main.bullets[j].y, 10) && i!=j) players[i].isComp = 2;
      }
      for (int j = 1; j<players[i].bullets.length; j++) {
        if (rectBall(main.x, main.y, main.size, main.size, players[i].bullets[j].x, players[i].bullets[j].y, 10)) {
          print("Score: "+score);
          lost = 1;
        }
      }
    }
    main.update();
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == UP) main.shoot("up");
        if (keyCode == DOWN) main.shoot("down");
        if (keyCode == LEFT) main.shoot("left");
        if (keyCode == RIGHT) main.shoot("right");
      }
      if (key == 'w' || key == 'W') main.forward();
      if (key == 'd' || key == 'D') main.right();
      if (key == 'a' || key == 'A') main.left();
      if (key == 's' || key == 'S') main.back();
    }
  } else {
    image(lose, 0, 0);
  }
}

boolean rectBall(int rx, int ry, int rw, int rh, int bx, int by, int d) {
  if (bx+d/2 >= rx-rw/2 && bx-d/2 <= rx+rw/2 && abs(ry-by) <= d/2) return true;
  else if (by+d/2 >= ry-rh/2 && by-d/2 <= ry+rh/2 && abs(rx-bx) <= d/2) return true;
  float xDist = (rx-rw/2) - bx;
  float yDist = (ry-rh/2) - by;
  float shortestDist = sqrt((xDist*xDist) + (yDist * yDist));
  xDist = (rx+rw/2) - bx;
  yDist = (ry-rh/2) - by;
  float distanceUR = sqrt((xDist*xDist) + (yDist * yDist));
  if (distanceUR < shortestDist) shortestDist = distanceUR;
  xDist = (rx+rw/2) - bx;
  yDist = (ry+rh/2) - by;
  float distanceLR = sqrt((xDist*xDist) + (yDist * yDist));
  if (distanceLR < shortestDist) shortestDist = distanceLR;
  xDist = (rx-rw/2) - bx;
  yDist = (ry+rh/2) - by;
  float distanceLL = sqrt((xDist*xDist) + (yDist * yDist));
  if (distanceLL < shortestDist) shortestDist = distanceLL;
  if (shortestDist < d/2) return true;
  else return false;
}

class Player {
  String direction = "";
  String olddirection = direction;
  String[] directions = {"right", "left", "up", "down"};
  int isComp;
  int speed = 5;
  int size = 50;
  int x = int(random(500));
  int y = int(random(500));
  int dead = 0;
  Bullet[] bullets = new Bullet[0];
  Player(int isComp) {
    this.isComp = isComp;
  }
  void forward() {
    if (isComp == 0) y -= speed;
  }
  void left() {
    if (isComp == 0) x -= speed;
  }
  void right() {
    if (isComp == 0) x += speed;
  }
  void back() {
    if (isComp == 0) y += speed;
  }
  void shoot(String direction) {
    if (isComp == 0) {
      bullets = (Bullet[])append(bullets, new Bullet(x, y, direction));
    }
  }
  void update() {
    if ((frameCount%((round((frameRate+1)*0.1/10)*10)+1) == 0) & isComp == 1) {
      direction = directions[int(random(directions.length))];
      olddirection = direction;
      bullets = (Bullet[])append(bullets, new Bullet(x, y, directions[int(random(directions.length))]));
    }
    for (int i = 1; i<bullets.length; i++) bullets[i].update();
    if (direction == "right") x += speed;
    if (direction == "left") x -= speed+0.003;
    if (direction == "down") y += speed+0.007;
    if (direction == "up") y -= speed;
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
    if (isComp == 1) fill(255, 0, 0);
    else if (isComp == 2) fill(0, 0, 255);
    else fill(0, 255, 0);
    if (dead == 0) rect(x, y, size, size);
  }
}


class Bullet {
  int speed = 10;
  int x;
  int y;
  String direction;
  Bullet(int x, int y, String direction) {
    this.x = x;
    this.y = y;
    this.direction = direction;
  }
  void update() {
    if (direction == "right") x += speed;
    if (direction == "left") x -= speed;
    if (direction == "down") y += speed;
    if (direction == "up") y -= speed;
    ellipse(x, y, 10, 10);
  }
}
