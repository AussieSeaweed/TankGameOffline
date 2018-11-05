/*
 * A ProjectileEntity class that implements bullets, grenades, rockets, etc.  
 */

class ProjectileEntity extends WorldEntity {
  private float damage, range, lifeTime;
  private int numCollisionsBeforeDestruction, numCollisions;
  private boolean explosive;
  private ParticleSystemDef explosionDef;
  private LinkedList<KinematicEntity> exceptions;
  
  public ProjectileEntity(ProjectileEntityDef projectileEntityDef) {
    super(projectileEntityDef);
    
    damage = projectileEntityDef.getDamage();
    range = projectileEntityDef.getRange();
    numCollisionsBeforeDestruction = projectileEntityDef.getNumCollisionsBeforeDestruction();
    explosive = projectileEntityDef.isExplosive();
    lifeTime = projectileEntityDef.getLifeTime();
    explosionDef = projectileEntityDef.getExplosionDef();
    exceptions = new LinkedList<KinematicEntity>();
  }
  
  /*
   * These methods are getters and setters.  
   */
  
  public void addException(KinematicEntity that) {
    exceptions.add(that);
  }
  
  public boolean isExcepted(KinematicEntity that) {
    for (KinematicEntity exception : exceptions)
      if (exception == that) return true;
    return false;
  }
  
  public float getDamage() {
    return damage;
  }
  
  public void setDamage(float damage) {
    this.damage = damage;
  }
  
  public int getNumCollisionsBeforeDestruction() {
    return numCollisionsBeforeDestruction;
  }
  
  public void setNumCollisionsBeforeDestruction(int numCollisionsBeforeDestruction) {
    this.numCollisionsBeforeDestruction = numCollisionsBeforeDestruction;
  }
  
  public boolean isExplosive() {
    return explosive;
  }
  
  public void setExplosive(boolean explosive) {
    this.explosive = explosive;
  }
  
  public float getRange() {
    return range;
  }
  
  public void setRange(float range) {
    this.range = range;
  }
  
  public float getLifeTime() {
    return lifeTime;
  }
  
  public void setLifeTime(float lifeTime) {
    this.lifeTime = lifeTime;
  }
  
  /*
   * A method that updates the projectile  
   */
  
  public void update() {
    super.update();
    checkForDestruction();
  }
  
  /*
   * A method that checks for the destruction of the projectile.  
   */
  
  private void checkForDestruction() {
    if (numCollisions >= numCollisionsBeforeDestruction)
      markForDestruction();
    if (seconds() - getInitialTime() > lifeTime)
      markForDestruction();
    if (getDistanceBetween(getInitialLocation(), getLocation()) > range)
      markForDestruction();
  }
  
  /*
   * A method that handles the collision between the projectile and other WorldEntity.  
   */
  
  public void handleCollision(WorldEntity that) {
    numCollisions++;
    
    if (explosive) {
      explosionDef.setLocation(getLocation());
      getEnvironment().addEntity(explosionDef.createEntity());
    }
  }
}
