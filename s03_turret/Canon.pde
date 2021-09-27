class Canon extends GraphicObject {

  float shootingAngle = QUARTER_PI;
  float angleIncrement = PI/60;
  float angleMax = 1.41; // sqrt 2

  float w = 32;
  float h = 16;
  
  PVector shootingVector = new PVector();
  PVector canonTip = new PVector();
  
  Canon() {
    super();

    location.x = width / 2;
    location.y = height - h;
  }
  
  PVector getCanonTip() {
    
    return canonTip;
  }
  
  PVector getShootingVector() {
    return shootingVector;
  }
  
  void move () {
    
    
    // X et Y sont inverses
    shootingVector.y = -cos(shootingAngle);
    shootingVector.x = sin(shootingAngle);
    shootingVector.normalize();
    
    // Calcul du bout du canon
    
    
  }

  

  void display() {
    
   
  }
}
