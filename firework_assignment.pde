import processing.sound.*;
// If this throws an error, go to Sketch -> Import Library -> Add Library
// Search for "sound" and install the library called "Sound" by the Processing foundation

SoundFile boom;
SoundFile wind_s;
SoundFile whistle;

int fade = 0;
int timer;

int rocketMass;
int flareMass;

int moving = 0;
int imageNr = 0;

int windDir;

ArrayList<item> objects = new ArrayList();
ArrayList<windParticle> wind = new ArrayList();

color randomColor() {
 return color(random(0, 255), random(0, 255), random(0, 255)); 
}

player character;

void setup () {
  size(1040, 800, P2D);
  strokeWeight(4);
  textSize(20);
  
  boom = new SoundFile(this, "explosion.wav");
  wind_s = new SoundFile(this, "wind.wav");
  whistle = new SoundFile(this, "whistle.wav");
  
  wind_s.amp(0.05);
  
  rocketMass = 10;
  flareMass = 5;
  
  character = new player(loadImage("character_left.png"));
} //<>//

void draw () {
  fade+=5;
  background(51, fade%255);
  
  if (!!mousePressed && timer < millis()) {
    objects.add(new item( character.pos.x, height, 80.0f, rocketMass, randomColor(), randomColor(), 'r')); 
    timer = millis() + 1000;
    whistle.play();
  }
  
  if (moving == 0) {
    character.show(2);
  } else {
    imageNr++;
    character.show((imageNr / 10) % 2); //(
  }
  character.move(moving * 10);
  
  // Iterate through list backwards so we don't mess up the array when deleting items
  for (int i = objects.size() - 1; i >= 0; i--) {
    if (objects.get(i).expired()) {                        // Check if our object has exploded or can be seen
      if (objects.get(i).itemType == 'r') {                // Check if out current object is a rocket
        addRandFlares(17, i);                              // Create flares where the rocket was (Appended to the end of the list so it doesn't have an effect until the next iteration of draw())
        if (whistle.isPlaying())                           // if the wistling sound is still playing stop it
          whistle.stop();
      }
      
      objects.remove(i);                                   
    } else {
      objects.get(i).update(new PVector(windDir * 10, 0)); // Otherwise update our current object
    }
  }
  
  
  // Wind control
  draw_wind(windDir);
  
  if (windDir != 0) {                  // If the wind is blowing
    if (!wind_s.isPlaying())           // And if the wind sound is not playing
      wind_s.loop();                   // Play sound
  } else {                             // If its not blowing
    if (wind_s.isPlaying())            // But the sound is playing
      wind_s.stop();                   // Stop sound
  }
  
  fill(255);
  text("A/D to move and Q/E for wind \nTap the same key to stop wind \nAnd click to shoot rockets!", 0, 20);
  
  if (timer - millis() >= 0){
    fill(255);
    text("Timer: " + (timer - millis())/100, width-100, 20);
  }
}

// Recursive function to make random flares
int addRandFlares (int iterator, int index) {    
  objects.add( new item(objects.get(index).pos.x, objects.get(index).pos.y, random(-100, 100), random(-100, 100), flareMass, randomColor(), 'f') );
  
  if (iterator == 1) {
    return iterator;  
  } else {
    return addRandFlares (iterator - 1, index); 
  }
}

void draw_wind(int wind_dir) {
  // This lowers the amount of wind particles on the screen so it looks better and doesn't add new wind particles if the wind is not blowing
  if (random(0, 10) < 5 && wind_dir != 0)
    wind.add(new windParticle(wind_dir == 1));
  
  // Looping through each wind particle backwards because we don't want to mess up the array
  for (int i = wind.size() - 1; i >= 0; i--) {
    wind.get(i).update();           // Update positions
    
    if (wind.get(i).exists())       // Check if the particle is still visible
      wind.get(i).show();         
    else
      wind.remove(i);
  }
}

/* Movement handling code 
 * the values are being assigned -1 or 1 or 0 to tell whether the thing should moving positively, negatively or not on the x-axis
 * this isn't to make things more complicated, I would rather use a bool, but I need 3 values not 2
 */
void keyPressed () {
  switch (key) {
    case 'a':
      moving = -1;
      character = new player(character.pos, loadImage("character_left.png"));
      break;
      
    case 'd':
      moving = 1;
      character = new player(character.pos, loadImage("character_right.png"));
      break;
      
    case 'e':
      if (windDir == 1)
        windDir = 0;
      else
        windDir = 1;
      break;
    
    case 'q':
      if (windDir == -1)
        windDir = 0;
      else
        windDir = -1;
      break;
      
    default:
      break;
  }
}

/* Here the if statements are being used to check if another key (other than the one being pressed) is getting pressed
 * this was because of a bug caused when pressing right then pressing left and then lifting your finger off right
 * it caused the player that was going right to go left but when right was released the player would stop
 */
void keyReleased() {
  switch (key){
    case 'a':
      if (!keyPressed)
        moving = 0;
      break;
      
    case 'd':
      if (!keyPressed)
        moving = 0;
      break;
    
    default:
      break;
  
  }
}
