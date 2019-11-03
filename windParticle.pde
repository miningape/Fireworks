class windParticle {
  PVector pos;
  float particle_alpha;  // Transparency
  int dir;  // Directional integer / velocity
  float offset;  // Constant Random Phase to make each particle unique
  float amp;  // Constant Random Amplitude to make each particle unique
  float constYPos;
  
  // Constructor
  windParticle (boolean fromLeft) {
    if (fromLeft) {
      this.pos = new PVector(random(-10, 30), random(0, height)); // Spawn in random positions close to the left side of the screen
      this.dir = 10; 
    } else {
      this.pos = new PVector(width - random(-10, 30), random(-30, height + 30)); // Spawn in random positions close to the right side of the screen
      this.dir = -10;
    }
     
    this.constYPos = this.pos.y;
    
    this.offset = random(-PI, PI);   // Change the phase of the wave randomly but constantly
    this.amp = random(2, 8);         // Change the amplitude of the wave
    this.particle_alpha = 255;       // Initialize alpha value
  }
  
  void update () {
    this.pos.x += this.dir;          // Move the particle a few pixels
    this.pos.y += this.amp * sin((0.01 * this.pos.x) + this.offset);      // Add the value of sin(x) to the current y pos with the phase and amplitude for that particles wave
    
    this.particle_alpha -= 2500/width;  // Scale how quickly the particle fades based on the screen width
    
    // Makes sure that the particle's alpha doesn't go below 0 and cause errors
    if (this.particle_alpha < 0) {  
      this.particle_alpha = 0;
    }
  }
  
  // Returns whether the alpha>0 (in other words: whether the particle can be seen)
  boolean exists () {
    return particle_alpha > 0; 
  }
  
  // Method to draw each particle at a point
  void show () {
    fill(255, particle_alpha);  // How the apha is implemented
    noStroke();  
    ellipse(this.pos.x, this.pos.y, 2, 2);  // Draw a dot where the particle is
    stroke(4);  // Return stroke to default value
  }
}
