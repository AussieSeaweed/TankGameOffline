/*
 * A PhysicsObject class which works as a template for geometrical objects.  
 */

abstract class PhysicsObject {
  protected void translateToBody() {
    Vec2 location = getLocation();
    float angle = getAngle();
    
    translate(location.x, location.y);
    rotate(angle);
  }
  
  public abstract Vec2 getLocation();
  public abstract void setLocation(Vec2 location);
  public abstract Vec2 getLinearVelocity();
  public abstract void setLinearVelocity(Vec2 linearVelocity);
  public abstract float getAngle();
  public abstract void setAngle(float angle);
  public abstract float getAngularVelocity();
  public abstract void setAngularVelocity(float angularVelocity);
  public abstract void applyForceToCenter(Vec2 force);
  public abstract void applyAngularForce(float angularForce);
  public abstract void update();
  public abstract float getLongestDistanceFromCenter();
}
