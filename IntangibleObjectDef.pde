class IntangibleObjectDef {
  private Vec2 location, linearVelocity, acceleration;
  private float angle, angularVelocity, angularAcceleration, mass;
  
  public Vec2 getLocation() {
    return getVectorCopy(location);
  }
  
  public void setLocation(Vec2 location) {
    this.location = getVectorCopy(location);
  }
  
  public Vec2 getLinearVelocity() {
    return getVectorCopy(linearVelocity);
  }
  
  public void setLinearVelocity(Vec2 linearVelocity) {
    this.linearVelocity = getVectorCopy(linearVelocity);
  }
  
  public Vec2 getAcceleration() {
    return getVectorCopy(acceleration);
  }
  
  public void setAcceleration(Vec2 acceleration) {
    this.acceleration = getVectorCopy(acceleration);
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
  
  public float getAngularAcceleration() {
    return angularAcceleration;
  }
  
  public void setAngularAcceleration(float angularAcceleration) {
    this.angularAcceleration = angularAcceleration;
  }
  
  public float getMass() {
    return mass;
  }
  
  public void setMass(float mass) {
    this.mass = mass;
  }
  
  public IntangibleObject createIntangibleObject() {
    return new IntangibleObject(this);
  }
}
