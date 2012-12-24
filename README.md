Storify - A Prolog Story Generator
==================================

Storify will take a given set of actions and states and generate a story.

The story world is based on a homework assignment created by Piper Jackson at Simon Fraser University. Please refer to this [image] (http://i.imgur.com/4JDNG.png) to better understand the story world.

The world is currently setup as a graph of doubly connected nodes, you may change the world by altering the values of `connected(A, B)` in the sourcecode.

### Usage
    story([get(hero, treasure), move(hero, home)], A, [at(hero, home), at(treasure, dungeon)], W).

### Example Output
    A = [travel(hero, home, forest), travel(hero, forest, dungeon), take(hero, treasure), travel(hero, dungeon, mountains), travel(hero, mountains, home)],
    W = [at(hero, home), has(hero, treasure)].


The first parameter represents the goal state we wish to achieve and the second parameter, `a`, will contain the actions performed to achieve our goal actions.

The latter two parameters serve as the world state before and the world state after the transformations, `w`.

### Verbose Output
You may use `storify(GOAL, START).` for more verbose output.

Available Actions
----------------
`get(Person, Object)` - Person travels to Object's location and picks up Object.

`move(Person, Location)` - Person travels to Location.

State Predicates
----------------
These are either true or false.

`at(Object, Location)`, `has(Object1, Object2)`

Testing
-------
To run the default test case, call `test(A, W).` or `test_storify.`
