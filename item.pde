class item extends forces {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector acc_grav = new PVector(0, 9.81); // Acceleration due to gravity
  
  PVector size;
  int mass;
  
  boolean flag;
  boolean explodable;
  
  color strokePallette;
  color fillPallette;
  
  float tExplode;
  
  char itemType;
  
  int itemAlpha;
  
  // Basic constructor function, for rockets that aren't given a specific velocity and are rather targeted at the mouse
  item (float loc_x, float loc_y, float init_vel, int tempMass, color stroke, color fill, char type, float T, float bonusTE, boolean defined) {
    this.pos = new PVector(loc_x, loc_y);
    
    
    // This code gets a unit vector in the direction of the mouse
    PVector mouse = new PVector(mouseX, mouseY);
    PVector direction = mouse.sub(this.pos);
    direction.normalize();
    
    // This multiplies the unit direction vector by our initial velocity
    this.vel = direction.mult(init_vel);
    
    this.acc = new PVector(0, 0);
    
    this.size = new PVector(2.5, 10);
    this.mass = tempMass;
    
    this.strokePallette = stroke;
    this.fillPallette = fill;
    
    this.tExplode = millis() + (!defined ? random(300, 1000) : (T + bonusTE));
    
    this.flag = false;
    
    this.itemType = type;
    
    this.explodable = !(type == 'f');
    
    this.itemAlpha = 255;
  }
  
  // Overloaded constructor for direct control over starting velocities rather than heading for mouse
  item (float loc_x, float loc_y, float init_vel_x, float init_vel_y, int tempMass, color stroke, color fill, char type, float T, float bonusTE, boolean defined) {
    this.pos = new PVector(loc_x, loc_y);
    this.vel = new PVector(init_vel_x, init_vel_y);  
    this.acc = new PVector(0, 0);
    
    this.size = new PVector(10, 10);
    this.mass = tempMass; //kg
    
    this.strokePallette = stroke;
    this.fillPallette = fill;
    
    this.tExplode = millis() + (defined ? random(300, 1000) : (T + bonusTE));
    
    this.flag = false;
    
    this.itemType = type;
    
    this.explodable = !(type == 'f');
    
    this.itemAlpha = 255;
  }
  
  // Constructor overloads for one color pallette instead of 2 and no defined time
  item (float loc_x, float loc_y, float init_vel, int mass, color pallette, char type) {
    this(loc_x, loc_y, init_vel, mass, pallette, pallette, type, 0f, 0f, false);
  }
  
  item (float loc_x, float loc_y, float init_vel_x, float init_vel_y, int mass, color pallette, char type) {
    this(loc_x, loc_y, init_vel_x, init_vel_y, mass, pallette, pallette, type, 0f, 0f, false);
  }
  
  // For 2 pallettes but no defined time
  item (float loc_x, float loc_y, float init_vel, int mass, color pallette, color pallette2, char type) {
    this(loc_x, loc_y, init_vel, mass, pallette, pallette2, type, 0f, 0f, false);
  }
  
  item (float loc_x, float loc_y, float init_vel_x, float init_vel_y, int mass, color pallette, color pallette2, char type) {
    this(loc_x, loc_y, init_vel_x, init_vel_y, mass, pallette, pallette2, type, 0f, 0f, false);
  }
  
  boolean expired() {
    if (!this.flag && (this.tExplode < millis()) && explodable) {                      // !flag is included for performance because an int comparison is more expensive than a bool comparison
      this.flag = true; 
      boom.play();
    }
    
    // Flares don't explode but they fade away
    if (this.itemAlpha <= 0 && !explodable) {
      this.flag = true; 
    }
    
    return flag;
  }

  // Method that draws our rocket
  void show() {
    switch(itemType) {
      case 'r':
        this.drawRocket();
        break;
        
      case 'f':
        this.drawFlare();
        break;
      
      default:
        println("No type on the item");
        break;
    }
  }
  
  void drawFlare() {
    noStroke();
    fill(this.fillPallette, this.itemAlpha);
    ellipse(pos.x, pos.y, 8, 8);
    this.itemAlpha = this.itemAlpha - 4;
    //filter( BLUR, 1 ); 
  }
  
  void drawRocket () {
    rectMode(CORNER);
    
    fill(this.fillPallette);
    stroke(this.strokePallette);
    strokeWeight(4);
    
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    
    line(this.pos.x, this.pos.y, 
          this.pos.x + (this.size.x / 2), 
          this.pos.y - (this.size.y / 2));
          
    line(this.pos.x + this.size.x, this.pos.y, 
          this.pos.x + (this.size.x / 2), 
          this.pos.y - (this.size.y / 2));
  }
  
  // This method handles everything that happens to a rocket frame by frame
  // Because of overloading this function can take an additional force as its parameters
  void update (PVector force) {
    // Apply forces                
    this.acc = allForces(force, this.pos, this.size, this.vel, this.mass, (this.itemType == 'f'));
    this.acc = applyForce(this.acc, force, this.mass);
    
    this.vel.add(this.acc);
    
    this.pos.add(this.vel);
    
    this.show();
  }
  
  // Operator overloading the update function with no additional forces
  void update () {
    this.update(new PVector(0, 0));        // Call this function but with a PVector parameter of (0, 0)
  }

}
