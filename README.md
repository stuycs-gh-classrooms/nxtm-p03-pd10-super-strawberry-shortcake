[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/-jWdCFXs)
## Project 00
### NeXTCS
### Period: 10
## Thinker0: Andrew Zhao
## Thinker1: Unmesh Ghosh
---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:
- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination


## Phase 0: Force Selection, Analysis & Plan
---------- 

#### Custom Force: Electrostatic Force

### Custom Force Formula
What is the formula for your force? Including descriptions/definitions for the symbols. (You may include a picture of the formula if it is not easily typed.)

Fe = (kq1q2 / r2) * rHAT

### Custom Force Breakdown
- What information that is already present in the `Orb` orA distinct demonstration for each individual force (including gravity and the spring force).
A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
The ability to toggle movement on/off
The ability to toggle bouncing on/off
The user should be able to switch between simluations using the number keys as follows:

    1: Gravity
    2: Spring Force `OrbNode` classes does this force use?
  - distance between two orbs.

- Does this force require any new constants, if so what are they and what values will you try initially?
  - the electrostatic constant, 9.0 * 10^9 N*m^2/C^2

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  - we will use a float datatype to represent Charge in coulombs
    
- Does this force interact with other `Orbs`, or is it applied based on the environment?
  - This force does interact with other Orbs, as charge is individual to each orb.

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  - We will need to determine the normalized vector between the two orbs which this force is acting on.

--- 

### Simulation 1: Gravity
Describe how you will attempt to simulate orbital motion.

--- Each orb will apply a gravitational force to the other orbs, however there will be one fixed orb at the center of the screen with the most mass, and other orbs will orbit around this one orb as its gravitational A distinct demonstration for each individual force (including gravity and the spring force).


### Simulation 2: Spring
Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

Orbs will be connected to the orb behind it in an array of orbs with a "spring" represented by a line. This spring will make each orb act as if it is attached to a spring to another orb. Orbs will be attracted to other orbs unless the spring between them is compressed, then they will repel.

--- 

### Simulation 3: Drag
Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

A drag force will be applied to each orb depending on its mass. This force will not be evident unless the orb is moving, however this force will constantly decelerate an orb if it is moving. A force can be applied on an orb by pressing a button.

--- 

### Simulation 4: Custom force
Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

Our electrostatic force simulation will give each orb a random charge, or give each orb a neutral charge based on a setting. Orbs with positive charges will repel other orbs with positive charges, and attract negative and neutral charges, and vice versa.
--- 

### Simulation 5: Combination
Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

The combination simulation will look like a combination of all the other simulations, there will be a fixed orb at the center(which will inflict gravitational force), each orb will be be connected to the orb behind it and/or in front of it in an orb array with springs(each orb wil inflict spring force on the other), drag force will be applied to every orb (slowing down orbs based on velocity and direction), and all orbs have individually adjustable charges(allowing electrostatic force to be present, creating both repulsion and attraction between orbs).

