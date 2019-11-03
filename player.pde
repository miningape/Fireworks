class player extends forces {
  PVector pos;
  PVector vel;
  public PVector acc;
  PVector size;
  color pcolor;
  
  PImage wings;
  
  float mass;
  
  ArrayList<PImage> sprites = new ArrayList();
  
  player(PVector posi, PImage sheet) {
    this.pos = posi;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.pcolor = color(255, 0, 0);
    
    mass = 0.5 * 4; // Nicest mass I found for moving the character width the wind resistance and speed and for jumping
    
    int N = 3;
    int W = sheet.width / N;
    
    for (int i = 0; i < N; i++) {
      this.sprites.add( sheet.get(i * W, 0, W, sheet.height) );
    }
    
    this.size = new PVector(W, sheet.height);
    this.size.mult(3);
  }
  
  void move (float dV, float wind) {
    // Movement code, I haven't programmed friction / collision yet so its interesting that the character stops because of air resistance
    // that means if you bump up the mass the character slides more, which is why the character has to have a really low mass
    this.pos.add(this.vel);
    this.vel.add(dV * 3/4, 0);
    this.vel.add(acc);
    
    this.acc = allForces(new PVector(wind * 0.25 * 0.25, 0), this.pos, this.size, this.vel, this.mass); 
    
    if (this.pos.y > height) 
      this.pos.y = height;
     
    if (this.pos.x > width)
      this.pos.x = 0;
     
    if (this.pos.x < 0)
      this.pos.x = width;
  }
  
  void show (int sprite) {
    stroke(0);
    strokeWeight(1);
    
    fill(200);
    rect(0, height - 5, width, 5);
    
    fill(this.pcolor);
    
    showObj();
    image(this.sprites.get(sprite), this.pos.x, this.pos.y - this.size.y, this.size.x, this.size.y);
  }
}
