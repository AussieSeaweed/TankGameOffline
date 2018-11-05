/*
 * A Weapon class which KinematicEntity holds to fire projectile entities.
 */

class Weapon {
  private ProjectileEntityDef projectileEntityDef;
  private KinematicEntity user;
  private boolean active, reloading;
  private int magazineCapacity, magazineClip;
  private float initialProjectileSpeed, reloadTime, shootingTime, reloadBeginTime, shootingBeginTime, deviation;
  private Vec2 barrelTipLocation;
  private RandomGenerator randomGen;
  private AudioPlayer shotAudio;
  private AudioPlayer reloadAudio;
  
  public Weapon(WeaponDef weaponDef) {
    user = weaponDef.getUser();
    projectileEntityDef = weaponDef.getProjectileEntityDef();
    active = weaponDef.isActive();
    reloading = weaponDef.isReloading();
    magazineCapacity = weaponDef.getMagazineCapacity();
    magazineClip = weaponDef.getMagazineClip();
    reloadTime = weaponDef.getReloadTime();
    shootingTime = weaponDef.getShootingTime();
    barrelTipLocation = weaponDef.getBarrelTipLocation();
    initialProjectileSpeed = weaponDef.getInitialProjectileSpeed();
    reloadBeginTime = Float.NEGATIVE_INFINITY;
    shootingBeginTime = Float.NEGATIVE_INFINITY;
    deviation = weaponDef.getDeviation();
    
    if (weaponDef.getShotSoundFileSketchPath() != null) {
      shotAudio = projectileEntityDef.getEnvironment().getGame().getMinim().loadFile(weaponDef.getShotSoundFileSketchPath());
    } else {
      shotAudio = null;
    }
    
    if (weaponDef.getReloadSoundFileSketchPath() != null) {
      reloadAudio = projectileEntityDef.getEnvironment().getGame().getMinim().loadFile(weaponDef.getReloadSoundFileSketchPath());
    } else {
      reloadAudio = null;
    }
    
    randomGen = new RandomGenerator();
  }
  
  /*
   * These methods are getters and setters.  
   */
  
  public float getDeviation() {
    return deviation;
  }
  
  public void setDeviation(float deviation) {
    this.deviation = deviation;
  }
  
  public ProjectileEntityDef getProjectileDef() {
    return projectileEntityDef;
  }
  
  public void setProjectileDef(ProjectileEntityDef projectileEntityDef) {
    this.projectileEntityDef = projectileEntityDef;
  }
  
  public float getReloadTime() {
    return reloadTime;
  }
  
  public void setReloadTime(float reloadTime) {
    this.reloadTime = reloadTime;
  }
  
  public float getShootingTime() {
    return shootingTime;
  }
  
  public void setShootingTime(float shootingTime) {
    this.shootingTime = shootingTime;
  }
  
  public Vec2 getBarrelTipLocation() {
    return user.getLocation().add(rotate(barrelTipLocation, user.getSightAngle()));
  }
  
  public boolean isReloading() {
    return reloading;
  }
  
  public KinematicEntity getUser() {
    return user;
  }
  
  public void setUser(KinematicEntity user) {
    this.user = user;
  }
  
  public void setActive(boolean active) {
    this.active = active;
  }
  
  public boolean isActive() {
    return active;
  }
  
  public int getMagazineCapacity() {
    return magazineCapacity;
  }
  
  public void setMagazineCapacity(int magazineCapacity) {
    this.magazineCapacity = magazineCapacity;
  }
  
  public int getMagazineClip() {
    return magazineClip;
  }
  
  public void setMagazineClip(int magazineClip) {
    this.magazineClip = magazineClip;
  }
  
  /*
   * A method that updates the weapon.
   */
  
  public void update() {
    if (active && magazineClip > 0 && !reloading && seconds() - shootingBeginTime > shootingTime) {
      fire();      
    }
    
    if (!reloading && magazineClip <= 0) {
      beginReload();
    }
    
    if (reloading && seconds() - reloadBeginTime > reloadTime) {
      endReload();
    }
  }
  
  /*
   * A method that fires the weapon.
   */
  
  public void fire() {
    if (shotAudio != null) {
      shotAudio.rewind();
      shotAudio.play();
    }
    magazineClip--;
    shootingBeginTime = seconds();
    float fireAngle = user.getSightAngle() + map(randomGen.getNoise(seconds()), 0, 1, -deviation, deviation);
    
    projectileEntityDef.setAngle(fireAngle);
    projectileEntityDef.setLocation(getBarrelTipLocation());
    projectileEntityDef.setLinearVelocity(getUnitVectorOf(fireAngle).mulLocal(initialProjectileSpeed));
    
    ProjectileEntity projectileEntity = projectileEntityDef.createProjectileEntity();
    projectileEntity.addException(user);

    user.getEnvironment().addEntity(projectileEntity);
  }
  
  /*
   * A method that begins the reload of the weapon.
   */
  
  public void beginReload() {
    if (!reloading) {
      if (reloadAudio != null) {
        reloadAudio.rewind();
        reloadAudio.play();
      }
      
      reloading = true;
      reloadBeginTime = seconds();
    }
  }
  
  /*
   * A method that ends the reload of the weapon.
   */
  
  public void endReload() {
    if (reloadAudio != null) {
      reloadAudio.pause();
    }
    
    reloading = false;
    magazineClip = magazineCapacity;
    reloadBeginTime = Float.NEGATIVE_INFINITY;
  }
}
