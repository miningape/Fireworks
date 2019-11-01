// This class is designed to be hínherited by other classes so its methods can be used to calculate forces

class forces {
  // Initializing variables for force
  PVector acc_gravity = new PVector(0, 1);
  
  // Hardcoded values for airdensity as well as the drag coefficient (editing these values affect how air resistance will work)
  float airDensity = 2;
  float dragCoefficient = 0.01; 
  
  // Method that applies all the forces (gravity and air resistance and wind) and returns the acceleration on that object
  PVector allForces (PVector wind_force, PVector temp_dim, PVector temp_vel, int temp_mass, boolean sphere) {
    PVector acc = new PVector(0, 0); // Initializes at 0, 0 so we don't have to worry about resetting the value of our acceleration
    
    acc = gravity(acc); // Functional Programming at its finest
    acc = applyForce(acc, wind_force, temp_mass); // Calculate acceleration due to the wind
    acc = airResistance(acc, temp_dim, temp_vel, temp_mass, sphere); // Pass in our temporary variables
    
    // Return the calculated acceleration
    return acc;
  }
  
  // Any call that does not explicitely say the object as a sphere is given a semi-arbitrary cross sectional area based on the average of length and width
  PVector allForces (PVector wind_force, PVector temp_dim, PVector temp_vel, int temp_mass) {
    return this.allForces(wind_force, temp_dim, temp_vel, temp_mass, false);
  }
  
  // Inherited method that calculates final acceleration given a force and an initial acceleration
  PVector applyForce (PVector init_acc, PVector force, int mass) {
    return init_acc.add(force.div(mass));
  }
  
  // Inherited method for air resistance, formula: Fd (as a vector) = -1/2 * density * vel^2 * Area * drag coefficient * directional vector
  PVector airResistance (PVector init_acc, PVector dim, PVector vel, int mass, boolean sphere) {
    PVector v = vel.copy();      // Changing variables so we don't accidentaly change value of velocity
    float velo = v.mag(); // Again so we dont change values for each ".mag()" call
    
    float area;
    
    if (sphere){
      area = PI; //PI * ((dim.x + dim.y)/2)*((dim.x + dim.y)/2); 
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
  PVector gravity(PVector init) {
    return init.add(acc_gravity);
  }
}
