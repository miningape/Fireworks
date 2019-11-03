# Fireworks
I needed to make a physics simulation of a firework, so I made this. It contains a physics engine I hope to expand on and use for other projects.

This document is just a general description of every significant portion of code. For more information on specific parts of code look at the source files which have a bunch of comments on the code.

Directory:
	/Executables/ -> You can run these
	/Data/ -> Graphics and Sound Files
Main file -> Most of the I/O and Logic
Physics engine “forces.pde”-> Calculates forces
Rocket Items Prototype class “items.pde” -> Prototypes what an object has and does
Player Prototype class “player.pde” -> Prototypes what the player can do
Wind Particles Prototype class “windParticle.pde” -> Prototypes each particle for the wind, these particles aren’t according to physics and just look nice 

I tried to follow a functional programming paradigm but of course I made errors with that, the main file therefore controls most of the input, output and logic and uses information from each of the other files. One weird quirk of the code is that the player’s motion isn’t stopped by friction as it appears, but rather by air resistance. I’m currently trying to program friction into the code, and you can see a prototype of this in the physics engine.
Forces
The physics engine, basic idea is that any method takes acceleration as a parameter as well as other values and then return a PVector for acceleration so the useage of this engine is purely functional and easy to understand, this means the basic syntax for calculations with this engine is: 
object.acceleration = someEngineFunction(object.acceleration [, forceParams]);
allForces() -> Does not take an acceleration value as it creates a new one to return, it also just calls each of the other functions to calculate a final velocity.
applyForce() -> Takes force, mass and current acceleration. Returns acceleration + force/mass
airResistance() -> Calculates a force
gravity()
You can also see a class below this, this is the contact engine so that I can add friction and contact. At the moment it kind of works but I really need to add a whole lot more to get it to work properly so I just left it in but it is unused by any other code. In the future I plan to add methods to “forces” such as contact() to calculate if an object is touching another one and what happens to an object on contact based on the methods defined in the other class. 

Items Class
The Rocket Items Class contains a prototype for each kind of item from a rocket, either the rocket itself or the residue that explodes from it. It inherits from the physics engine “forces” so it can use any method described in there and I use that to apply physics to each rocket item. 
The class contains 4 overloaded constructors so that I could create an object with different parameters that might cause the object to behave differently. The reason this was done was primarily so that an item could be initialized with a speed towards the mouse, or with specific values for x and y velocities. One very important parameter is the “itemType” which is supposed to be either ‘r’ or ‘f’ for rocket or flare respectively and is mostly used for determining what to draw.
A general outline for each method within this class’ purpose 
Expired() -> Contains several if statements to determine whether the current item has expired (as a rocket it could have exploded and as a flare it could have faded out). And returns a boolean value that says as much. So it can be removed from arrays that contain several items.
Show() -> Determines what to draw (flare or rocket) then calls a specific function to draw where and what the object is. Each specific function just calls line() or ellipse() or combinations of those to represent the object it is.
Update() -> Uses the physics engine to determine the acceleration for this frame for this object and then applies that to that objects velocity and position and then calls the show() method.


Player Class
// Unfinished

WindParticle
This class is almost purely artistic. It’s used to create each individual wind particle and contains the methods to draw the particle, update the particle and test if it needs to be destroyed for memory management purposes. What’s important here is the alpha value as it controls how the particle fades and the offset and amplitude variables. The constructor just asks what direction this particle is heading and then sets a direction integer and where the particle starts. The motion of the particle is modelled by a sine wave, so the constructor also sets an offset and amplitude value for the particle. Offset is random is so that the particles don’t all move up or down at the same position and amplitude is also random to break up how similar each wind particle is and make the wind as a whole look better.
Update() -> This method is called once a frame. Each particle only has a position not a velocity, so I manually change the x-position of the particle by a fixed value that is set in the constructor, and I have the y-position equal to the sine of the x-position and changed by constant random offset and amplitude values for each particle. And lowers the alpha value.
Show() -> Lowers the alpha but makes sure not to lower it below 0 and cause errors, and then draws an ellipse where the wind particle is. This means that frame after frame the transparency of the ellipse increases until it can’t be seen.
Exists() -> returns whether the particle can be seen or not so that the particle can be removed from the array that contains all the wind particles, and makes up the wind, for memory management purposes.

Main File
Several arrays for objects
Several Variables
Several functions for behavior and display+

Several functions for input

And of course:
Setup()
Draw()


