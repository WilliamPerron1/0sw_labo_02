Canon c;
Vaisseau v;
ArrayList<Projectile> bullets;
int maxBullets = 6;
ArrayList<Mover> flock;
int flockSize = 20;
int kill;
int score;
boolean debug = false;
int lvl =1;
void setup() {
  size (800, 600);
  flock = new ArrayList<Mover>();
  flockSize = 15+(lvl*5);
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  c = new Canon();
  kill =0;
  score=0;
  bullets = new ArrayList<Projectile>();
  lvl++;
  for (int i = 0; i < flockSize; i++) {
   createEt(); 
  }
  println(flockSize);
  textAlign(CENTER, CENTER);
}

int currentTime;
int previousTime = 0;
int deltaTime;

void draw() {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;
  
  update(deltaTime);
  render();
  display();
}
PVector thrusters = new PVector(0, -0.02);
float angle = 0;

void update (float deltaTime) {
  if(flockSize == 0){
    reset();
   }

  for (Mover m : flock) {
    if(m.isVisible){
      if(v.isVisible){
        if(v.isCollidingMover(m)){
          m.isVisible = false;
          v.life--;
          kill++;
          score++;
          flockSize--;
          //print(v.life);
        }
      }
      for (Projectile b : bullets){
         if (b.isVisible){
          if(b.isCollidingMover(m)){
            b.isVisible = false;
            m.isVisible = false;
            flockSize--;
            kill++;
            score++;
          }
        }
      }
      m.flock(flock);
      m.update(deltaTime);
    }
 }
 if(kill ==10){
   v.life++;
   kill =0;
 }
  if (keyPressed) {
    switch (key) {
      case ' ':
        v.thrust();
        break;
      case CODED:
        if (keyCode == LEFT) v.pivote(-.03);
        if (keyCode == RIGHT) v.pivote(.03);
        break;
    }
  }

  v.update(deltaTime);

  c.update();

  for ( Projectile p : bullets) {
    if(p.isVisible){
      if(v.isCollidingProjectile(p)){
        p.isVisible = false;
        v.life--;
        //print(v.life);
      }
      p.update(deltaTime);
    }
  }
}

void display () {
  for (Mover m : flock) {
    m.display();
    
  }
  
  c.shootingAngle = v.heading;
  v.display();
}

void render() {
  background(0);
  if(v.life ==0){
   designGameOver();
 }
 Text(lvl,v.life,score);
 
  
  for ( Projectile p : bullets) {
    p.display();
  }
  
  //c.display();
  c.move();
  v.getTips();
  c.canonTip = v.Tip;
}

void keyPressed() {
  
  if (key == 'c') {
    
    fire (c);
  }
  if(key == 'r'){
    lvl =1;
    setup();
  }
  

}

void keyReleased() {
    switch (key) {
      case ' ':
        v.noThrust();
        break;
    }  
}

void fire(GraphicObject m) {
  Canon c = (Canon)m;
  
  if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = c.getCanonTip().copy();
    p.topSpeed = 5;
    p.velocity = c.getShootingVector().copy().mult(p.topSpeed);
   
    p.activate();
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = c.getCanonTip().x;
        p.location.y = c.getCanonTip().y;
        p.velocity.x = c.getShootingVector().x;
        p.velocity.y = c.getShootingVector().y;
        p.velocity.mult(p.topSpeed);
        p.activate();
        break;
      }
    }
  }
  
}

void createEt(){
  float minX = v.location.x-(5*v.w);
  float maxX = v.location.x+(5*v.w);
  float minY = v.location.y-(5*v.h);
  float maxY = v.location.y+(5*v.h); 

  flock = new ArrayList<Mover>();
  for (int i = 0; i < flockSize; i++) {
    float mover_x = random(0,width);
    float mover_y = random(0,height);

    while((mover_x > minX && mover_x < maxX)||(mover_y > minY && mover_y < maxY)){
      mover_x = random(0,width);
      mover_y = random(0,height);
    }
    Mover m = new Mover(new PVector(mover_x, mover_y), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
}


void reset(){
  size (800, 600);
  flock = new ArrayList<Mover>();
  flockSize = 15+(lvl*5);
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  c = new Canon();
  kill =0;
  bullets = new ArrayList<Projectile>();
  lvl++;
  for (int i = 0; i < flockSize; i++) {
   createEt(); 
  }
  println(flockSize);
  textAlign(CENTER, CENTER);
}

void designGameOver(){
  
  fill(255,0,0);
  textSize(30);
  text("Game over", width/2, height/3 - 40);
  text("click r to play again", width/2, height/3 +40);
}
void Text(int lvl, int life, int score){
  lvl-=1;
  textSize(25);
  fill(0,255,0);
  text("life: "+life,  width-50, 15);
  fill(0,0,255);
  text("lvl: "+lvl, 50, 15);
  fill(255,0,255);
  text("score: "+score, width/2, 15);
}
