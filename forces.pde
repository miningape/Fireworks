// This class is designed to be hínherited by other classes so its methods can be used to calculate forces

class forces extends physical{
  // Initializing variables for force
  public PVector acc_gravity = new PVector(0, 1);
  
  // Hardcoded values for airdensity as well as the drag coefficient (editing these values affect how air resistance will work)
  public float airDensity = 2;
  public float dragCoefficient = 0.01; 
  
  // Method that applies all the forces (gravity and air resistance and wind) and returns the acceleration on that object
  public PVector allForces (PVector wind_force, PVector pos, PVector temp_dim, PVector temp_vel, float temp_mass, boolean sphere) {
    PVector acc = new PVector(0, 0); // Initializes at 0, 0 so we don't have to worry about resetting the value of our acceleration
    
    if (collides(pos, temp_dim)) {
      println("collision");
      acc = applyForce(acc, acc.copy().mult(temp_mass), temp_mass);
    } else {
    
    
    acc = applyForce(acc, wind_force, temp_mass); // Calculate acceleration due to the wind
    acc = airResistance(acc, temp_dim, temp_vel, temp_mass, sphere); // Pass in our temporary variables
    acc = gravity(acc); // Functional Programming at its finest
    
    }
    // Return the calculated acceleration
    return acc;
  }
  
  // Any call that does not explicitely say the object as a sphere is given a semi-arbitrary cross sectional area based on the average of length and width
  public PVector allForces (PVector wind_force, PVector temp_pos, PVector temp_dim, PVector temp_vel, float temp_mass) {
    return this.allForces(wind_force, temp_pos, temp_dim, temp_vel, temp_mass, false);
  }
  
  // Inherited method that calculates final acceleration given a force and an initial acceleration
  public PVector applyForce (PVector init_acc, PVector force, float mass) {
    return init_acc.add(force.div(mass));
  }
  
  // Inherited method for air resistance, formula: Fd (as a vector) = -1/2 * density * vel^2 * Area * drag coefficient * directional vector
  public PVector airResistance (PVector init_acc, PVector dim, PVector vel, float mass, boolean sphere) {
    PVector v = vel.copy();      // Copying variables so we don't accidentaly change value of velocity, I'm not completely sure how java passes objects by reference so this is just not to take a chance
    float velo = v.mag(); // Again so we dont change values for each ".mag()" call
    
    float area;
    
    if (sphere){
      area = PI; //PI * ((dim.x + dim.y)/2)*((dim.x + dim.y)/2); is what I wanna use but it slows down my pc too much
    } else {
      area = 1; // assuming the cross sectional area of EVERY rocket is 1 
    }
      
    float dragMag = area * velo * velo * airDensity * dragCoefficient; // Magnitude of the drag
    
    // Directional Vector stuff
    PVector drag = vel.copy();  // Assigning unchanged velocity variable so our direction isn't wrong
    drag.mult(-1);       // Reverse Direction
    drag.normalize();    // Unit vector
    drag.mult(dragMag);  // Drag Force Vector
    
    return init_acc.add(drag.div(mass));// Return acceleration
  }
  
  // Inherited method for gravity
  public PVector gravity(PVector init_acc) {
    return init_acc.add(acc_gravity);
  }
}

// Additional code that I want to use later / for experiments. It doesn't have an actual effect on the code.
class physical {
  ArrayList<anObject> Objects = new ArrayList();
  
  class anObject {
    public PVector pos;
    public PVector size;
    
    anObject (PVector temp_pos, PVector temp_size) {
      this.pos = temp_pos;
      this.size = temp_size;
    }
    
    anObject (float x, float y, float dx, float dy) {
      this(new PVector(x, y), new PVector(dx, dy));
    }
  }
  
  physical () {
    // Uncomment any of these to see how it works and why it's not included yet
    //Objects.add(new anObject(100, 700, 20, 700));
    //Objects.add(new anObject(300, 700, 20, 700));
  }
  
  public boolean collides (PVector otherPos, PVector otherSize) {
    for (anObject myObj : Objects) {
      if ((otherPos.x + otherSize.x > myObj.pos.x && otherPos.x < myObj.pos.x) || (otherPos.x < myObj.pos.x + myObj.size.x && otherPos.x > myObj.pos.x)) {
        if ((otherPos.y + otherSize.y > myObj.pos.y && otherPos.y < myObj.pos.y) || (otherPos.y < myObj.pos.y + myObj.size.y && otherPos.y > myObj.pos.y)) {
          return true;
        }
      }
    }
    return false;
  }
  
  public void showObj (color objColor) {
    fill(objColor);
    
    for (anObject iterationObj : Objects) {
      rect(iterationObj.pos.x, iterationObj.pos.y, iterationObj.size.x, iterationObj.size.y); 
    }
  }
  
  public void showObj () {
    this.showObj(color(0, 255, 0));
  }
}
