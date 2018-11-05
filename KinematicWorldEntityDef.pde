abstract class KinematicWorldEntityDef extends WorldEntityDef {
  private float movingForceMagnitude, rotationValue, sightAngle, fullHealth, health, overHealthDropRate, fadingTime, minAimingDeviation, maxAimingDeviation, 
                promptingAngle, shootingOdds, changingOdds, destinationChangingOdds, healthBarWidth, healthBarHeight, healthBarStrokeWeight;
  private boolean movingUp, movingDown, movingLeft, movingRight, rotatingCCW, rotatingCW, AI, usingHealthBar;
  private ArrayList<WeaponDef> weaponDefList;
  private int weaponListPointer;
  private Entity targetEntity;
  private color healthBarBackgroundColor, healthBarForegroundColor, healthBarStroke;
  private Vec2 healthBarLocation;
  
  public KinematicWorldEntityDef() {
    weaponDefList = new ArrayList<WeaponDef>();
  }
  
  public color getHealthBarBackgroundColor() {
    return healthBarBackgroundColor;
  }
  
  public void setHealthBarBackgroundColor(color healthBarBackgroundColor) {
    this.healthBarBackgroundColor = healthBarBackgroundColor;
  }
  
  public color getHealthBarForegroundColor() {
    return healthBarForegroundColor;
  }
  
  public void setHealthBarForegroundColor(color healthBarForegroundColor) {
    this.healthBarForegroundColor = healthBarForegroundColor;
  }
  
  public color getHealthBarStroke() {
    return healthBarStroke;
  }
  
  public void setHealthBarStroke(color healthBarStroke) {
    this.healthBarStroke = healthBarStroke;
  }
  
  public float getHealthBarWidth() {
    return healthBarWidth;
  }
  
  public void setHealthBarWidth(float healthBarWidth) {
    this.healthBarWidth = healthBarWidth;
  }
  
  public float getHealthBarStrokeWeight() {
    return healthBarStrokeWeight;
  }
  
  public void setHealthBarStrokeWeight(float healthBarStrokeWeight) {
    this.healthBarStrokeWeight = healthBarStrokeWeight;
  }
  
  public float getHealthBarHeight() {
    return healthBarHeight;
  }
  
  public void setHealthBarHeight(float healthBarHeight) {
    this.healthBarHeight = healthBarHeight;
  }
  
  public Vec2 getHealthBarLocation() {
    return healthBarLocation;
  }
  
  public void setHealthBarLocation(Vec2 healthBarLocation) {
    this.healthBarLocation = healthBarLocation;
  }
  
  public boolean isUsingHealthBar() {
    return usingHealthBar;
  }
  
  public void setUsingHealthBar(boolean usingHealthBar) {
    this.usingHealthBar = usingHealthBar;
  }
  
  public float getFadingTime() {
    return fadingTime;
  }
  
  public void setFadingTime(float fadingTime) {
    this.fadingTime = fadingTime;
  }
  
  public float getRotationValue() {
    return rotationValue;
  }
  
  public void setRotationValue(float rotationValue) {
    this.rotationValue = rotationValue;
  }
  
  public boolean isMovingUp() {
    return movingUp;
  }
  
  public void moveUp(boolean movingUp) {
    this.movingUp = movingUp;
  }
  
  public boolean isMovingDown() {
    return movingDown;
  }
  
  public void moveDown(boolean movingDown) {
    this.movingDown = movingDown;
  }
  
  public boolean isMovingLeft() {
    return movingLeft;
  }
  
  public void moveLeft(boolean movingLeft) {
    this.movingLeft = movingLeft;
  }
  
  public boolean isMovingRight() {
    return movingRight;
  }
  
  public void moveRight(boolean movingRight) {
    this.movingRight = movingRight;
  }
  
  public boolean isRotatingCCW() {
    return rotatingCCW;
  }
  
  public void rotateCCW(boolean rotatingCCW) {
    this.rotatingCCW = rotatingCCW;
  }
  
  public boolean isRotatingCW() {
    return rotatingCW;
  }
  
  public void rotateCW(boolean rotatingCW) {
    this.rotatingCW = rotatingCW;
  }
  
  public float getSightAngle() {
    return sightAngle;
  }
  
  public void setSightAngle(float sightAngle) {
    this.sightAngle = sightAngle;
  }
  
  public float getHealth() {
    return health;
  }
  
  public void setHealth(float health) {
    this.health = health;
  }
  
  public float getOverHealthDropRate() {
    return overHealthDropRate;
  }
  
  public void setOverHealthDropRate(float overHealthDropRate) {
    this.overHealthDropRate = overHealthDropRate;
  }
  
  public float getFullHealth() {
    return fullHealth;
  }
  
  public void setFullHealth(float fullHealth) {
    this.fullHealth = fullHealth;
  }
  
  public float getMovingForceMagnitude() {
    return movingForceMagnitude;
  }
  
  public void setMovingForceMagnitude(float movingForceMagnitude) {
    this.movingForceMagnitude = movingForceMagnitude;
  }
  
  public ArrayList<WeaponDef> getWeaponDefList() {
    return weaponDefList;
  }
  
  public void setWeaponDefList(ArrayList<WeaponDef> weaponDefList) {
    this.weaponDefList = weaponDefList;
  }
  
  public void addWeaponDef(WeaponDef weaponDef) {
    weaponDefList.add(weaponDef);
  }
  
  public ArrayList<Weapon> createWeaponList() {
    ArrayList<Weapon> weaponList = new ArrayList<Weapon>(weaponDefList.size());
    for (WeaponDef weaponDef : weaponDefList) {
      weaponList.add(weaponDef.createWeapon());
    }
    return weaponList;
  }
  
  public int getWeaponListPointer() {
    return weaponListPointer;
  }
  
  public void setWeaponListPointer(int weaponListPointer) {
    this.weaponListPointer = weaponListPointer;
  }
  
  public float getMinAimingDeviation() {
    return minAimingDeviation;
  }
  
  public void setMinAimingDeviation(float minAimingDeviation) {
    this.minAimingDeviation = minAimingDeviation;
  }
  
  public float getMaxAimingDeviation() {
    return maxAimingDeviation;
  }
  
  public void setMaxAimingDeviation(float maxAimingDeviation) {
    this.maxAimingDeviation = maxAimingDeviation;
  }
  
  public void setAimingDeviationRange(float minAimingDeviation, float maxAimingDeviation) {
    this.minAimingDeviation = minAimingDeviation;
    this.maxAimingDeviation = maxAimingDeviation;
  }
  
  public Entity getTargetEntity() {
    return targetEntity;
  }
  
  public void setTargetEntity(Entity targetEntity) {
    this.targetEntity = targetEntity;
  }
  
  public float getPromptingAngle() {
    return promptingAngle;
  }
  
  public void setPromptingAngle(float promptingAngle) {
    this.promptingAngle = promptingAngle;
  }
  
  public float getShootingOdds() {
    return shootingOdds;
  }
  
  public void setShootingOdds(float shootingOdds) {
    this.shootingOdds = shootingOdds;
  }
  
  public float getChangingOdds() {
    return changingOdds;
  }
  
  public void setChangingOdds(float changingOdds) {
    this.changingOdds = changingOdds;
  }
  
  public boolean isAI() {
    return AI;
  }
  
  public void setAI(boolean AI) {
    this.AI = AI;
  }
  
  public float getDestinationChangingOdds() {
    return destinationChangingOdds;
  }
  
  public void setDestinationChangingOdds(float destinationChangingOdds) {
    this.destinationChangingOdds = destinationChangingOdds;
  }
  
  public int getWeaponCount() {
    return weaponDefList.size();
  }
}

class TankEntityDef extends KinematicWorldEntityDef {
  public Entity createEntity() {
    return createTankEntity();
  }
  
  public TankEntity createTankEntity() {
    return new TankEntity(this);
  }
}
