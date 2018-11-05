class ProjectileEntityDef extends WorldEntityDef {
  private float damage, range, lifeTime;
  private int numCollisionsBeforeDestruction;
  private boolean explosive;
  private ParticleSystemDef explosionDef;
  
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
  
  public ProjectileEntity createProjectileEntity() {
    return new ProjectileEntity(this);
  }
  
  public Entity createEntity() {
    return createProjectileEntity();
  }
  
  public ParticleSystemDef getExplosionDef() {
    return explosionDef;
  }
  
  public void setExplosionDef(ParticleSystemDef explosionDef) {
    this.explosionDef = explosionDef;
  }
}
