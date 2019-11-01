class player {
  PVector pos;
  PVector size;
  color pcolor;
  
  ArrayList<PImage> sprites = new ArrayList();
  
  player(PVector posi, PImage sheet) {
    this.pos = posi;
    this.pcolor = color(255, 0, 0);
    
    int N = 3;
    int W = sheet.width / N;
    
    for (int i = 0; i < N; i++) {
      this.sprites.add( sheet.get(i * W, 0, W, sheet.height) );
    }
    
    this.size = new PVector(W, sheet.height);
    this.pos.y -= (this.size.y + 5);
  }
  
  player (PImage sheet) {
    this(new PVector(width/2, 0), sheet); 
  }
  
  void move (int dist) {
    this.pos.add(new PVector(dist, 0));
  }
  
  void show (int sprite) {
    stroke(0);
    strokeWeight(1);
    
    fill(200);
    rect(0, height - 5, width, 5);
    
    fill(this.pcolor);
    
    image(this.sprites.get(sprite), this.pos.x, this.pos.y - this.size.y, this.size.x, this.size.y);
  }
}
