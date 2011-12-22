# The Cars


This is study project for course "Programming Languages" @ Afeka College of Engineering
Game with map of city, random roads, AI and User driven cars and traffic lights.
User need to reach destination with minimum time.

## Highlights

* Visual Prolog 7.3
* Randomized Prim algorithm for building maze
* BFS algorith to find short way between 2 points

## Information


### Explanation of usage :

* To run the game after compiling click File -> New (F7)

At the beginning you will see Main Menu of the game.

### Navigation:
* Main Menu - arrows Up,Down to select between items, Enter button to choose an item
* Game - Esc button to pause the game, Space or Enter to Continue
* Game Finish screen - Space or Enter show main menu
* Top Ten screen - Space or Enter in order to return to the main menu

### Control of the car:
* User car is yellow, need to reach green destination point
* W,A,S,D as described in requirements
* To turn on the road from one cell to another, car should be completely inside a cell.

### Implementation highlights:

* Random roads are generated by Randomized Prim algorithm
* Way between 2 points calculated using BFS algorithm. Each cell is the node of the graph that connected one to each other
* Every violation of traffic rules gives +10 seconds to the total times.
* There is 2 violation rules: user car drive on red light and user car drive to cell with other car in the same direction 
* top ten stored in file: top.fac and restored each run

### Classes overview:

* lawn - main form where game is drawn
* gameController - receive events from lawn
* cityGenerator - generate map, buildings and random roads (using prim algorithm)
* cityTrafficLights - create traffic lights on junctions in the city and mange states of them
* car - basic car implementation
* car/carAI - computer car extends car
* car/carUser - user driven car, extends car
* carManager - create and handle car objects
* mapBFS - calculate way between 2 cells on the map
* draw - draw current screen on the lawn form
* topTenManager - manage list of top ten
* utils - helpers used by multiple classes

## Author

Alex Gavrishev, 2011