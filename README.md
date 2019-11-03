# Fireworks
I needed to make a physics simulation of a firework for class, so I made this. It contains a physics engine I hope to expand on and use for other projects.

This document is just a general description of every significant portion of code. For more information on specific parts of code look at the source files which have a bunch of comments on the code.

<h5>Directory:</h5>
<ul>	
	<li>/Data/ -> Graphics and Sound Files</li>
	<li>Main file -> Most of the I/O and Logic</li>
	<li>Physics engine “forces.pde”-> Calculates forces</li>
	<li>Rocket Items Prototype class “items.pde” -> Prototypes what an object has and does</li>
	<li>Player Prototype class “player.pde” -> Prototypes what the player can do </li>
	<li>Wind Particles Prototype class “windParticle.pde” -> Prototypes each particle for the wind, these particles aren’t according to physics and just look nice </li>
</ul>


<p>I tried to follow the functional programming paradigm but of course I made errors with that, the main file therefore controls most of the input, output and logic and uses information from each of the other files.
</p>
<p>
One weird quirk of the code is that the player’s motion isn’t stopped by friction as it appears, but rather by air resistance. 
I’m currently trying to program friction into the code, and you can see a prototype of this in the physics engine: "Forces.pde"
</p>
<h3>Overview of the physics engine</h3>
<p>
The basic idea behind the physics engine is that any method takes acceleration as a parameter as well as other values for force and then return a PVector for acceleration so the useage of this engine is purely functional, making the basic syntax for calculations with this engine: 
</p>
<code>
object.acceleration = someEngineFunction(object.acceleration [, forceParams]);
</code>

<h5>Function Overview:</h5>

<ul>
<li>allForces() -> Does not take an acceleration value as it creates a new one to return, it also just calls each of the other functions to calculate a final velocity.</li>
<li>applyForce() -> Takes force, mass and current acceleration. Returns acceleration + force/mass</li>
<li>airResistance() -> Calculates a force</li>
<li>gravity() -> Calculates the acceleration on the object due to gravity</li>
</ul>	


<p>You can also see a class below this, this is the part of the physics engine that will handle friction and contact. At the moment it is in the works but I really need to add a whole lot more to get it to work properly so I just left it in but it is unused by any other code. In the future I plan to add methods to “forces” such as contact() to calculate if an object is touching another one and what happens to an object on contact based on the methods defined in the other class. </p>


<hr />

<h3>Items Class</h3>

<p>The Rocket Items Class contains a prototype for each kind of item from a rocket, either the rocket itself or the residue that explodes from it. It inherits from the physics engine “forces” so it can use any method described in there and I use that to apply physics to each rocket item. 
</p>

<p>The class contains 4 overloaded constructors so that I could create an object with different parameters that might cause the object to behave differently. The reason this was done was primarily so that an item could be initialized with a speed towards the mouse, or with specific values for x and y velocities. One very important parameter is the “itemType” which is supposed to be either ‘r’ or ‘f’ for rocket or flare respectively and is mostly used for determining what to draw.
</p>

<h5>Function Overview: </h5>

<ul>
<li>
Expired() -> Contains several if statements to determine whether the current item has expired (as a rocket it could have exploded and as a flare it could have faded out). And returns a boolean value that says as much. So it can be removed from arrays that contain several items.
	</li><li>
Show() -> Determines what to draw (flare or rocket) then calls a specific function to draw where and what the object is. Each specific function just calls line() or ellipse() or combinations of those to represent the object it is.
	</li><li>
Update() -> Uses the physics engine to determine the acceleration for this frame for this object and then applies that to that objects velocity and position and then calls the show() method.
	</li></ul>

<hr />
<h3>Player Class</h3>
// Unfinished

<hr />
<h3>WindParticle</h3>
This class is almost purely artistic. It’s used to create each individual wind particle and contains the methods to draw the particle, update the particle and test if it needs to be destroyed for memory management purposes.

What’s important here is the alpha value as it controls how the particle fades and the offset and amplitude variables. The constructor just asks what direction this particle is heading and then sets a direction integer and where the particle starts. 

The motion of the particle is modelled by a sine wave, so the constructor also sets an offset and amplitude value for the particle. Offset is random is so that the particles don’t all move up or down at the same position and amplitude is also random to break up how similar each wind particle is and make the wind as a whole look better.

<h5> Function Overview </h5>
<ul>
<li>Update() -> This method is called once a frame. Each particle only has a position not a velocity, so I manually change the x-position of the particle by a fixed value that is set in the constructor, and I have the y-position equal to the sine of the x-position and changed by constant random offset and amplitude values for each particle. And lowers the alpha value.
	</li><li>
Show() -> Lowers the alpha but makes sure not to lower it below 0 and cause errors, and then draws an ellipse where the wind particle is. This means that frame after frame the transparency of the ellipse increases until it can’t be seen.
	</li><li>
Exists() -> returns whether the particle can be seen or not so that the particle can be removed from the array that contains all the wind particles, and makes up the wind, for memory management purposes.
	</li>
</ul>

<hr />
<h3>Main File</h3>
// Description unfinished but an over view is this

Several arrays for objects

Several Variables

Several functions for behavior and display+

Several functions for input

And of course:
	Setup()
	Draw()


