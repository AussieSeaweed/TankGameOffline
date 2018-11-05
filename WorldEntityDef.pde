abstract class WorldEntityDef extends EntityDef {
  private WorldObjectDef worldObjectDef;
  
  public WorldObjectDef getWorldObjectDef() {
    return worldObjectDef;
  }
  
  public void setWorldObjectDef(WorldObjectDef worldObjectDef) {
    this.worldObjectDef = worldObjectDef;
  }
  
  public float getAngle() {
    return worldObjectDef.getAngle();
  }
  
  public void setAngle(float angle) {
    worldObjectDef.setAngle(angle);
  }
  
  public float getAngularDamping() {
    return worldObjectDef.getAngularDamping();
  }
  
  public void setAngularDamping(float angularDamping) {
    worldObjectDef.setAngularDamping(angularDamping);
  }
  
  public float getAngularVelocity() {
    return worldObjectDef.getAngularVelocity();
  }
  
  public void setAngularVelocity(float angularVelocity) {
    worldObjectDef.setAngularVelocity(angularVelocity);
  }
  
  public float getLinearDamping() {
    return worldObjectDef.getLinearDamping();
  }
  
  public void setLinearDamping(float linearDamping) {
    worldObjectDef.setLinearDamping(linearDamping);
  }
  
  public Vec2 getLinearVelocity() {
    return worldObjectDef.getLinearVelocity();
  }
  
  public void setLinearVelocity(Vec2 linearVelocity) {
    worldObjectDef.setLinearVelocity(linearVelocity);
  }
  
  public Vec2 getLocation() {
    return worldObjectDef.getLocation();
  }
  
  public void setLocation(Vec2 location) {
    worldObjectDef.setLocation(location);
  }
  
  public WorldObject createWorldObject() {
    return worldObjectDef.createWorldObject();
  }
}
