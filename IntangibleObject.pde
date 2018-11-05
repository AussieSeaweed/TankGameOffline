/*
 * An IntangibleObject class that defines the physics object without collidable body. 
 */

class IntangibleObject extends PhysicsObject {
  private Vec2 location, linearVelocity, acceleration;
  private float angle, angularVelocity, angularAcceleration, mass;
  
  public IntangibleObject(IntangibleObjectDef intangibleObjectDef) {
    this.location = intangibleObjectDef.getLocation();
    this.linearVelocity = intangibleObjectDef.getLinearVelocity();
    this.acceleration = intangibleObjectDef.getAcceleration();
    this.angle = intangibleObjectDef.getAngle();
    this.angularVelocity = intangibleObjectDef.getAngularVelocity();
    this.angularAcceleration = intangibleObjectDef.getAngularAcceleration();
    this.mass = intangibleObjectDef.getMass();
  }
  
  /*
   * These methods are getters and setters. 
   */
  
  public float getMass() {
    return mass;
  }
  
  public void setMass(float mass) {
    this.mass = mass;
  }
  
  public Vec2 getLocation() {
    return location;
  }
  
  public void setLocation(Vec2 location) {
    this.location = location;
  }
  
  public Vec2 getLinearVelocity() {
    return linearVelocity;
  }
  
  public void setLinearVelocity(Vec2 linearVelocity) {
    this.linearVelocity = linearVelocity;
  }
  
  public float getAngle() {
    return angle;
  }
  
  public void setAngle(float angle) {
    this.angle = angle;
  }
  
  public float getAngularVelocity() {
    return angularVelocity;
  }
  
  public void setAngularVelocity(float angularVelocity) {
    this.angularVelocity = angularVelocity;
  }
  
  public float getLongestDistanceFromCenter() {
    return 0;
  }
  
  /*
   * A method that applies force to center.  
   */
  
  public void applyForceToCenter(Vec2 force) {
    acceleration.addLocal(force.mul(1f / mass));
  }
  
  /*
   * A method that applies angular force to the intangible object.  
   */
  
  public void applyAngularForce(float angularForce) {
    angularAcceleration += angularForce;
  }
  
  /*
   * A method that geometrically updates the intangible object. 
   */
  
  public void update() {
    linearVelocity.addLocal(perSecond(acceleration));
    location.addLocal(perSecond(linearVelocity));
    acceleration.setZero();
    angularVelocity += perSecond(angularAcceleration);
    angle += perSecond(angularVelocity);
    angularAcceleration = 0;
  }
}
