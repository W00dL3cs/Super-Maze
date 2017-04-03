/*:
 
 # Super Maze
 
 **Super Maze** is a programmatic maze generator and solver, built with Swift 3.
 
 ## Background
 
 In the context of an industry which is worth more than 40 billion dollars, most mobile games nowadays come with crafted and _carefully_ designed levels... which always remain the same: experienced players know exactly what happens at any given time.
 
 While this is not always a bad thing, it surely reduces the game's lifespan with a given player: why play the same level over and over again?!
 
 One way to increase your game’s replay value is to allow the game to generate its content **programmatically** (also known as adding **procedurally** generated content).
 
 This playground has been built with the intent of demonstrating how to create a virtually **unlimited** amount of tile-based maps, each one different from the other: you control a red ball, and your aim is to complete the maze as fast as possible... tilting the device.
 
 ## "Random'... or 'Procedural'?
 
 Before starting, it's important to underline the **difference** between these two terms: _random_ means that you have little to no control over what happens, which should **not** be the case in game development.
 
 What if an user could not complete the level? Or playing a platformer in which the exit is placed in an unreachable spot?
 
 In this sense, designing a _procedurally_ generated level might actually be **harder** than carefully craft it ad-hoc.
 
 ## Maze Generation
 
 In order to generate a real _procedural_ level, this playground performs four different sets operations on a bi-dimensional matrix (which represents the nodes of the map):
 1. Fill the matrix with placeholder obstacles
    ````
     for row in 0..<mazeHeight
     {
         var currentRow = [Node]()
         
         for column in 0..<mazeWidth
         {
             let node = Node(x: column, y: row, type: .obstacle)
             
             currentRow.append(node)
         }
         
         result.graph.append(currentRow)
     }
     ````
 2. Set the external borders of the map as walkable (in order to start path generation)
     ````
     for i in 0 ..< mazeWidth
     {
         result.graph[0][i].type = .walkable
         result.graph[mazeHeight - 1][i].type = .walkable
     }
     
     for i in 0 ..< mazeHeight
     {
         result.graph[i][0].type = .walkable
         result.graph[i][mazeWidth - 1].type = .walkable
     }
     ````
 3. Generate a random pair of entry/exit nodes
    ````
     let startNode = result.graph[Utils.randomOddValue(min: 1, max: mazeHeight - 1)][Utils.randomEvenValue(min: 1, max: mazeWidth - 1)]
     
     let endNode = result.graph[Utils.randomEvenValue(min: 1, max: mazeHeight - 2)][Utils.randomOddValue(min: 1, max: mazeWidth - 1)]
     
     ````
 4. 'Carve' the maze from the entry point to the exit
     ````
     carve(maze: result, startNode: firstNode)
     ````
 5. Remove random obstacles in order to create multiple paths and increase difficulty
     ````
     let walkable = result.graph.flatMap
     {
         $0.filter
         {
             $0.type == .obstacle &&
             ($0.x > 1 && $0.x < (mazeWidth - 2)) &&
             ($0.y > 1 && $0.y < (mazeHeight - 2))
         }
     }
     
     for i in 0..<arc4random_uniform(UInt32(sqrt(Double(walkable.count))))
     {
         walkable[Int(arc4random_uniform(UInt32(walkable.count)))].type = .walkable
     }
     ````
 
 ## Maze Solving
 
 In order to check for solvable (but at the same time, **challenging**) levels, this playground makes use of a custom Swift implementation of the _A*_ pathfinding algorithm: starting from the entry point of the maze, every neighbor node is assigned a score which depends on multiple factors... including a raw **estimation** of its distance from the exit point.
 
 As the calculation proceeds and more nodes are _visited_, these scores are more likely to change: once the exit point has been reached, the path with the lowest score is selected.
 
 If you need help solving a particular maze, you can **rely** on such algorithm: just click the _question mark_ button in the upper right part of the screen, and you will be presented with a glowing solution for a couple of seconds.
 
 
 ## Final Notes
 
 - Important:
 Turn on your device orientation lock
 
 
 - Important:
 Run the game at full screen size, in portrait mode
 
 
 */

//#-hidden-code

import UIKit
import SpriteKit
import PlaygroundSupport

let scene = GameScene()
scene.scaleMode = .aspectFit

let view = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

view.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = view

//#-end-hidden-code
