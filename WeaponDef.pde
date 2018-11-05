class WeaponDef {
  private ProjectileEntityDef projectileEntityDef;
  private boolean active, reloading;
  private KinematicEntity user;
  private int magazineCapacity, magazineClip;
  private float initialProjectileSpeed, reloadTime, shootingTime, deviation;
  private Vec2 barrelTipLocation;
  private String shotSoundFileSketchPath, reloadSoundFileSketchPath;
  
  public KinematicEntity getUser() {
    return user;
  }
  
  public void setUser(KinematicEntity user) {
    this.user = user;
  }
  
  public float getDeviation() {
    return deviation;
  }
  
  public void setDeviation(float deviation) {
    this.deviation = deviation;
  }
  
  public ProjectileEntityDef getProjectileEntityDef() {
    return projectileEntityDef;
  }
  
  public void setProjectileEntityDef(ProjectileEntityDef projectileDef) {
    this.projectileEntityDef = projectileDef;
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
  
  public void setReloading(boolean reloading) {
    this.reloading = reloading;
  }
  
  public boolean isReloading() {
    return reloading;
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
  
  public Vec2 getBarrelTipLocation() {
    return barrelTipLocation;
  }
  
  public void setBarrelTipLocation(Vec2 barrelTipLocation) {
    this.barrelTipLocation = barrelTipLocation;
  }
  
  public float getInitialProjectileSpeed() {
    return initialProjectileSpeed;
  }
  
  public void setInitialProjectileSpeed(float initialProjectileSpeed) {
    this.initialProjectileSpeed = initialProjectileSpeed;
  }
  
  public String getShotSoundFileSketchPath() {
    return shotSoundFileSketchPath;
  }
  
  public void setShotSoundFileSketchPath(String shotSoundFileSketchPath) {
    this.shotSoundFileSketchPath = shotSoundFileSketchPath;
  }
  
  public String getReloadSoundFileSketchPath() {
    return reloadSoundFileSketchPath;
  }
  
  public void setReloadSoundFileSketchPath(String reloadSoundFileSketchPath) {
    this.reloadSoundFileSketchPath = reloadSoundFileSketchPath;
  }
  
  public Weapon createWeapon() {
    return new Weapon(this);
  }
}
