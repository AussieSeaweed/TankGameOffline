/*
 * A WorldObject class that defines the physics object with collidable body using JBox2D. 
 */

abstract class WorldObject extends PhysicsObject {
  private Body body;
  private Box2DProcessing world;
  private color fill, stroke;
  private float strokeWeight, maxLinearVelocityMagnitude, maxAngularVelocityValue, initialAngle;
  private Vec2 initialLocation;
  
  public WorldObject(WorldObjectDef worldObjectDef) {
    this.world = worldObjectDef.getWorld();
    this.body = worldObjectDef.createBody();
    setStyles(worldObjectDef.getFill(), worldObjectDef.getStroke(), worldObjectDef.getStrokeWeight());
    
    initialLocation = getLocation();
    initialAngle = getAngle();
    maxLinearVelocityMagnitude = worldObjectDef.getMaxLinearVelocityMagnitude();
    maxAngularVelocityValue = worldObjectDef.getMaxAngularVelocityValue();
  }
  
  /*
   * These methods are getters and setters. 
   */
  
  public float getInertia() {
    return body.getInertia();
  }
  
  public color getFill() {
    return fill;
  }
  
  public void setFill(color fill) {
    this.fill = fill;
  }
  
  public color getStroke() {
    return stroke;
  }
  
  public void setStroke(color stroke) {
    this.stroke = stroke;
  }
  
  public float getStrokeWeight() {
    return strokeWeight;
  }
  
  public void setStrokeWeight(float strokeWeight) {
    this.strokeWeight = strokeWeight;
  }
  
  public void setStyles(color fill, color stroke, float strokeWeight) {
    this.fill = fill;
    this.stroke = stroke;
    this.strokeWeight = strokeWeight;
  }
  
  public void applyStyles() {
    fill(fill);
    stroke(stroke);
    strokeWeight(strokeWeight);
  }
  
  public Vec2 getLocation() {
    return world.coordWorldToPixels(body.getWorldCenter());
  }
  
  public void setLocation(Vec2 location) {
    body.setTransform(world.coordPixelsToWorld(location), body.getAngle());
  }
  
  public float getAngle() {
    return -body.getAngle();
  }
  
  public void setAngle(float angle) {
    body.setTransform(body.getWorldCenter(), -angle);
  }
  
  public void setTransform(Vec2 location, float angle) {
    body.setTransform(world.coordPixelsToWorld(location), -angle);
  }
  
  public Vec2 getLinearVelocity() {
    return world.vectorWorldToPixels(body.getLinearVelocity());
  }
  
  public void setLinearVelocity(Vec2 linearVelocity) {
    body.setLinearVelocity(world.vectorPixelsToWorld(linearVelocity));
  }
  
  public float getAngularVelocity() {
    return -body.getAngularVelocity();
  }
  
  public void setAngularVelocity(float angularVelocity) {
    body.setAngularVelocity(-angularVelocity);
  }
  
  public void applyForceToCenter(Vec2 force) {
    body.applyForceToCenter(world.vectorPixelsToWorld(force));
  }
  
  public void applyForce(Vec2 force, Vec2 location) {
    body.applyForce(world.vectorPixelsToWorld(force), world.coordPixelsToWorld(location));
  }
  
  public float getMass() {
    return body.getMass();
  }
  
  public void destroy() {
    world.destroyBody(body);
  }
  
  public void applyAngularForce(float angularForce) {
    body.applyAngularImpulse(-perSecond(angularForce) * body.getInertia());
  }
  
  public void setUserData(Object userData) {
    body.setUserData(userData);
  }
  
  public Object getUserData() {
    return body.getUserData();
  }
  
  public float getAngularDamping() {
    return body.getAngularDamping();
  }
  
  public void setAngularDamping(float angularDamping) {
    body.setAngularDamping(angularDamping);
  }
  
  public float getGravityScale() {
    return body.getGravityScale();
  }
  
  public void setGravityScale(float gravityScale) {
    body.setGravityScale(gravityScale);
  }
  
  public float getLinearDamping() {
    return body.getLinearDamping();
  }
  
  public void setLinearDamping(float linearDamping) {
    body.setLinearDamping(linearDamping);
  }
  
  public boolean isBullet() {
    return body.isBullet();
  }
  
  public void setBullet(boolean bullet) {
    body.setBullet(bullet);
  }
  
  public boolean isFixedRotation() {
    return body.isFixedRotation();
  }
  
  public void setFixedRotation(boolean fixedRotation) {
    body.setFixedRotation(fixedRotation);
  }
  
  public Body getBody() {
    return body;
  }
  
  public float getMaxLinearVelocityMagnitude() {
    return maxLinearVelocityMagnitude;
  }
  
  public void setmaxLinearVelocityMagnitude(float maxLinearVelocityMagnitude) {
    this.maxLinearVelocityMagnitude = maxLinearVelocityMagnitude;
  }
  
  public float getMaxAngularVelocityValue() {
    return maxAngularVelocityValue;
  }
  
  public void setMaxAngularVelocityValue(float maxAngularVelocityValue) {
    this.maxAngularVelocityValue = maxAngularVelocityValue;
  }
  
  public Vec2 getInitialLocation() {
    return initialLocation;
  }
  
  public float getInitialAngle() {
    return initialAngle;
  }
  
  /*
   * A method that updates the world object, such as limiting speed. 
   */
  
  public void update() {
    Vec2 linearVelocity = getLinearVelocity();
    if (linearVelocity.length() > maxLinearVelocityMagnitude)
      setLinearVelocity(linearVelocity.mul(maxLinearVelocityMagnitude / linearVelocity.length()));
    
    float angularVelocity = getAngularVelocity();
    if (abs(angularVelocity) > maxAngularVelocityValue)
      setAngularVelocity(sign(angularVelocity) * maxAngularVelocityValue);
  }
  
  /*
   * A method that displays the world object. 
   */
  
  public void display() {
    pushMatrix();
    pushStyle();
    translateToBody();
    applyStyles();
    displayShape();
    popStyle();
    popMatrix();
  }
  
  /*
   * A method that displays the individual shapes of the object.
   * Since WorldObject does not specify any shape to be drawn, this method must be implemented by inherited classes.
   */
  
  protected abstract void displayShape();
}

class CircularWorldObject extends WorldObject {
  private float radius, diameter;
  
  public CircularWorldObject(CircularWorldObjectDef circularWorldObjectDef) {
    super(circularWorldObjectDef);
    
    radius = circularWorldObjectDef.getRadius();
    diameter = circularWorldObjectDef.getDiameter();
  }
  
  protected void displayShape() {
    ellipse(0, 0, diameter, diameter);
  }
  
  public float getRadius() {
    return radius;
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  public float getLongestDistanceFromCenter() {
    return getRadius() + getStrokeWeight();
  }
}

class RectangularWorldObject extends WorldObject {
  private float width, height;
  
  public RectangularWorldObject(RectangularWorldObjectDef rectangularWorldObjectDef) {
    super(rectangularWorldObjectDef);
    
    width = rectangularWorldObjectDef.getWidth();
    height  = rectangularWorldObjectDef.getHeight();
  }
  
  protected void displayShape() {
    rect(0, 0, width, height); 
  }
  
  public float getWidth() {
    return width;
  }
  
  public float getHeight() {
    return height;
  }
  
  public float getLongestDistanceFromCenter() {
    return sqrt(pow(width, 2) + pow(height, 2)) / 2f + getStrokeWeight();
  }
}

class PolygonalWorldObject extends WorldObject {
  private LinkedList<Vec2> vertices;
  private float longestDistanceFromCenter;
  
  public PolygonalWorldObject(PolygonalWorldObjectDef polygonalWorldObjectDef) {
    super(polygonalWorldObjectDef);
    
    vertices = polygonalWorldObjectDef.getVertices();
    longestDistanceFromCenter = polygonalWorldObjectDef.getLongestDistanceFromCenter();
  }
  
  public LinkedList<Vec2> getVertices() {
    return vertices;
  }
  
  protected void displayShape() {
    beginShape();
    for (Vec2 vertex : vertices)
      vertex(vertex.x, vertex.y);  
    endShape(CLOSE);
  }
  
  public float getLongestDistanceFromCenter() {
    return longestDistanceFromCenter + getStrokeWeight();
  }
}
