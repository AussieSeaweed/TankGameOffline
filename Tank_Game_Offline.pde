/*
 * Tank Game Offline
 *
 * Written by Juho Kim
 
 * Design Choices:
 * You can see classes such as Camera and CameraDef, or WorldObject and WorldObjectDef, and many other pairs. This is because these classes have countless properties.
 * I must supply all the values to the class constructor and java does not support default parameters, but instead, complex function overloading stuff. Still, I needed to
 * supply most of the properties anyway and it is hard to figure out the order in which they are supplied. Thus, I created the 'definition' classes. They store the properties' values,
 * and, during instantiation, the non-definition class takes all the property values. Still, since some properties require other properties to be there first, the order of suppliance
 * seldom matter. Because Definition Classes only handle getting and setting properties, I will not comment them.
 *
 * Trivial Getter and Setter methods will not be explained, since they are simple.
 *   - Getter methods are named 'get-'
 *   - Setter methods are named 'set-'
 *   - Creater methods are named 'create-'
 * Creater method, inside definition classes, creates objects on the fly based on its properties, which is handy.
 *
 * The Crux of the geometry system of this game are physicsObjects.
 * Largely, they are divided into two.
 *   1. WorldObjects
 *     - These are connected to the JBox2D physics engine, which handles unit collisions, etc.
 *     - WorldObject class takes cares of most methods that Body in JBox2D library provides. 
 *   2. IntangibleObjects
 *     - These have no collisions, since they are 'intangible'
 *     - These are completely independant from JBox2D, and has 3 crucial vector data and 3 crucial float data.
 *         - location
 *         - velocity
 *         - acceleration
 *         - angle
 *         - angularVelocity
 *         - angularAcceleration
 * These efforts have cumulated into a 'mostly' framerate independant physics system, but it is not perfect.
 * But it is good enough, in my opinion.
 */

/*
 * Importing necessary libraries:
 *   - Minim
 *   - Box2DProcessing
 *   - Java Utilities
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import shiffman.box2d.*;
import java.util.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;

Game game;

void setup() {
  /*
   * Setting up sketch properties
   *   - Feel free to change ther resolution and frameRate
   */
  
  fullScreen(P2D);
  frameRate(1000);
  smooth();
  
  rectMode(CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  cursor(CROSS);
  
  game = new Game(this); // Initiating the instance of Game class
}

/*
 * Everything is handled within the Game class, so look at that
 */

void draw() {
  game.update();
  game.display();
}

void keyPressed() {
  game.keyPressed();
}

void keyReleased() {
  game.keyReleased();
}

void keyTyped() {
  game.keyTyped();
}

void mousePressed() {
  game.mousePressed();
}

void mouseReleased() {
  game.mouseReleased();
}

void mouseClicked() {
  game.mouseClicked();
}

void mouseDragged(MouseEvent event) {
  game.mouseDragged(event);
}

void mouseWheel(MouseEvent event) {
  game.mouseWheel(event);
}
