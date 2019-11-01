class windParticle {
  PVector pos;
  int particle_alpha;
  int dir;
  float offset;
  
  windParticle (boolean fromLeft) {
    if (fromLeft) {
      this.pos = new PVector(random(-10, 30), random(0, height));
      this.dir = 10;
    } else {
      this.pos = new PVector(width - random(-10, 30), random(-30, height + 30));
      this.dir = -10;
    }
      
    this.offset = random(-PI, PI);  
    this.particle_alpha = 255;
  }
  
  void update () {
    this.pos.x += this.dir;
    this.pos.y += 5 * sin((0.01 * (this.pos.x)) + this.offset);
    
    this.particle_alpha -= 2;
    
    if (this.particle_alpha < 0) {
      this.particle_alpha = 0;
    }
  }
  
  boolean exists () {
    return particle_alpha > 0; 
  }
  
  void show () {
    fill(255, particle_alpha);
    noStroke();
    ellipse(this.pos.x, this.pos.y, 2, 2);
    stroke(4);
  }
}
