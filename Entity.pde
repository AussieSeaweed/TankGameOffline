/*
 * An Entity class which works as a template for other Entity implementations. These can be connected to IntangibleObject or WorldObject to have geometrical attributes.
 */

abstract class Entity {
  private Environment env;
  private boolean markedForDestruction;
  private float initialTime;
  protected RandomGenerator randomGen;
  
  public Entity(EntityDef entityDef) {
    this.env = entityDef.getEnvironment();
    initialTime = seconds();
    randomGen = new RandomGenerator();
  }
  
  /*
   * The implemented methods below are all getters and setters. 
   */
  
  public void markForDestruction() {
    markedForDestruction = true;
  }
  
  public boolean isMarkedForDestruction() {
    return markedForDestruction;
  }
  
  public float getInitialTime() {
    return initialTime;
  }
  
  public Environment getEnvironment() {
    return env;
  }
  
  public abstract Vec2 getLocation();
  public abstract float getAngle();
  public abstract float getLongestDistanceFromCenter();
  public abstract void update();
  public abstract void display();
  public abstract void destroy();
}

/*
 * A WorldEntity class that handles geometry related tasks using WorldObject
 */

abstract class WorldEntity extends Entity {
  WorldObject worldObject;
  
  public WorldEntity(WorldEntityDef worldEntityDef) {
    super(worldEntityDef);
    this.worldObject = worldEntityDef.createWorldObject();
    this.worldObject.setUserData(this);
  }
  
  /*
   * Again, getters and setters, mostly connecting to the underlying WorldObject instance. 
   */
  
  public Vec2 getLocation() {
    return worldObject.getLocation();
  }
  
  public float getAngle() {
    return worldObject.getAngle();
  }
  
  public float getLongestDistanceFromCenter() {
    return worldObject.getLongestDistanceFromCenter();
  }
  
  public void applyForceToCenter(Vec2 force) {
    worldObject.applyForceToCenter(force);
  }
  
  public void applyAngularForce(float angularForce) {
    worldObject.applyAngularForce(angularForce);
  }
  
  public void update() {
    worldObject.update();    
  }
  
  public void display() {
    worldObject.display();
  }
  
  public void destroy() {
    worldObject.destroy();
  }
  
  public Vec2 getInitialLocation() {
    return worldObject.getInitialLocation();
  }
  
  public float getInitialAngle() {
    return worldObject.getInitialAngle();
  }
  
  protected WorldObject getWorldObject() {
    return worldObject;
  }
  
  /*
   * A method that handles the collision. When this is implemented, it will reduce health, etc. 
   */
  
  public abstract void handleCollision(WorldEntity object);
}

/*
 * A method that implements the 'Kinematic' entities, capable of looking, moving, etc.
 */

abstract class KinematicEntity extends WorldEntity {
  public static final float zeroThreshold = 1e-6;
  private float movingForceMagnitude, rotationValue, sightAngle, fullHealth, health, overHealthDropRate, fadingStart, fadingTime, minAimingDeviation, maxAimingDeviation, 
                promptingAngle, shootingOdds, changingOdds, destinationChangingOdds, healthBarWidth, healthBarHeight, healthBarStrokeWeight;
  private boolean movingUp, movingDown, movingLeft, movingRight, rotatingCCW, rotatingCW, fading, AI, usingHealthBar;
  private Entity targetEntity;
  private Vec2 up = new Vec2(1, 0),
                down = new Vec2(-1, 0),
                left = new Vec2(0, -1),
                right = new Vec2(0, 1),
                destination, healthBarLocation;
  private ArrayList<Weapon> weaponList;
  private int weaponListPointer;
  private color healthBarBackgroundColor, healthBarForegroundColor, healthBarStroke;
  
  public KinematicEntity(KinematicWorldEntityDef kinematicWorldEntityDef) {
    super(kinematicWorldEntityDef);
    
    movingForceMagnitude = kinematicWorldEntityDef.getMovingForceMagnitude();
    rotationValue = kinematicWorldEntityDef.getRotationValue();
    sightAngle = kinematicWorldEntityDef.getSightAngle();
    fullHealth = kinematicWorldEntityDef.getFullHealth();
    health = kinematicWorldEntityDef.getHealth();
    overHealthDropRate = kinematicWorldEntityDef.getOverHealthDropRate();
    movingUp = kinematicWorldEntityDef.isMovingUp();
    movingDown = kinematicWorldEntityDef.isMovingDown();
    movingLeft = kinematicWorldEntityDef.isMovingLeft();
    movingRight = kinematicWorldEntityDef.isMovingRight();
    rotatingCCW = kinematicWorldEntityDef.isRotatingCCW();
    rotatingCW = kinematicWorldEntityDef.isRotatingCW();
    fadingTime = kinematicWorldEntityDef.getFadingTime();
    weaponList = kinematicWorldEntityDef.createWeaponList();
    minAimingDeviation = kinematicWorldEntityDef.getMinAimingDeviation();
    maxAimingDeviation = kinematicWorldEntityDef.getMaxAimingDeviation();
    targetEntity = kinematicWorldEntityDef.getTargetEntity();
    promptingAngle = kinematicWorldEntityDef.getPromptingAngle();
    AI = kinematicWorldEntityDef.isAI();
    shootingOdds = kinematicWorldEntityDef.getShootingOdds();
    changingOdds = kinematicWorldEntityDef.getChangingOdds();
    destinationChangingOdds = kinematicWorldEntityDef.getDestinationChangingOdds();
    healthBarBackgroundColor = kinematicWorldEntityDef.getHealthBarBackgroundColor();
    healthBarForegroundColor = kinematicWorldEntityDef.getHealthBarForegroundColor();
    healthBarStroke = kinematicWorldEntityDef.getHealthBarStroke();
    healthBarWidth = kinematicWorldEntityDef.getHealthBarWidth();
    healthBarHeight = kinematicWorldEntityDef.getHealthBarHeight();
    healthBarStrokeWeight = kinematicWorldEntityDef.getHealthBarStrokeWeight();
    healthBarLocation = kinematicWorldEntityDef.getHealthBarLocation();
    usingHealthBar = kinematicWorldEntityDef.isUsingHealthBar();
    destination = getEnvironment().getRandomVisibleLocation();
    for (Weapon weapon : weaponList)
      weapon.setUser(this);
    weaponListPointer = weaponList.isEmpty() ? 0 : (kinematicWorldEntityDef.getWeaponListPointer() % weaponList.size() + weaponList.size()) % weaponList.size();
  }
  
  /*
   * These are all getters and setters. 
   */
  
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
  
  public float getDestinationChangingOdds() {
    return destinationChangingOdds;
  }
  
  public void setDestinationChangingOdds(float destinationChangingOdds) {
    this.destinationChangingOdds = destinationChangingOdds;
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
  
  public float getFadingTime() {
    return fadingTime;
  }
  
  public void setFadingTime(float fadingTime) {
    this.fadingTime = fadingTime;
  }
  
  public ArrayList<Weapon> getWeaponList() {
    return weaponList;
  }
  
  public void setWeaponList(ArrayList<Weapon> weaponList) {
    this.weaponList = weaponList;
  }
  
  public void addWeapon(WeaponDef weaponDef) {
    weaponList.add(weaponDef.createWeapon());
  }
  
  public int getWeaponListPointer() {
    return weaponListPointer;
  }
  
  public void setWeaponListPointer(int weaponListPointer) {
    weaponList.get(this.weaponListPointer).setActive(false);
    this.weaponListPointer = weaponList.isEmpty() ? 0 : (weaponListPointer % weaponList.size() + weaponList.size()) % weaponList.size();
  }
  
  public void getNextWeapon() {
    setWeaponListPointer(weaponListPointer + 1);
  }
  
  public void getPreviousWeapon() {
    setWeaponListPointer(weaponListPointer - 1);
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
  
  public boolean isDead() {
    return health <= zeroThreshold;
  }
  
  public boolean isAlive() {
    return health > zeroThreshold;
  }
  
  public float getSightAngle() {
    return sightAngle;
  }
  
  public void setSightAngle(float sightAngle) {
    this.sightAngle = sightAngle;
  }
  
  public void setSightAngle(Vec2 targetLocation) {
    this.sightAngle = getAngleOf(targetLocation.sub(getLocation()));
  }
  
  public float getHealth() {
    return health;
  }
  
  public void setHealth(float health) {
    this.health = max(0, health);
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
  
  public void setActive(boolean active) {
    if (!weaponList.isEmpty()) weaponList.get(weaponListPointer).setActive(active);
  }
  
  public boolean isActive() {
    return weaponList.isEmpty() ? false : weaponList.get(weaponListPointer).isActive();
  }
  
  /*
   * A method that updates the Kinematic Entity.
   * If it is an AI, it will look towards target and move independently.
   * Although random, the behaviors follow a trend, it goes to location visible to the screen and aims towards the general vicinity of the player, and shoots accordingly.
   */
  
  public void update() {
    handleMovements();
    
    if (isDead()) {
      if (alpha(getWorldObject().getFill()) > zeroThreshold) {
        if (!fading) {
          if (this != getEnvironment().getPlayer()) getEnvironment().addScore(1);
          fading = true;
          fadingStart = seconds();
        }
        
        float alpha = 255f * (fadingTime - (seconds() - fadingStart)) / fadingTime;
        getWorldObject().setStyles(setAlpha(getWorldObject().getFill(), alpha), setAlpha(getWorldObject().getStroke(), alpha), getWorldObject().getStrokeWeight());
      } else {
        markForDestruction();
      }
    } else if (health > fullHealth) {
      health = max(fullHealth, health - perSecond(overHealthDropRate));
    }
    
    if (!weaponList.isEmpty())
      weaponList.get(weaponListPointer).update();
    
    if (AI) {
      if (targetEntity != null) {
        aimTowardsTarget();
        
        if (getAngleBetween(getUnitVectorOf(getSightAngle()), getUnitVectorOf(deltaAngleTarget())) <= promptingAngle && !targetEntity.isMarkedForDestruction() &&
            random(1) < perSecond(shootingOdds) && getEnvironment().isVisible(this))
          setActive(true);
          
        
        if (getAngleBetween(getUnitVectorOf(getSightAngle()), getUnitVectorOf(deltaAngleTarget())) > promptingAngle || targetEntity.isMarkedForDestruction() || random(1) < perSecond(shootingOdds) || !getEnvironment().isVisible(this)) 
          setActive(false);
          
        if (random(1) < perSecond(changingOdds))
          getNextWeapon();
      }
      
      if (random(1) < perSecond(destinationChangingOdds) || !getEnvironment().isVisible(destination, getLongestDistanceFromCenter())) {
        destination = getEnvironment().getRandomVisibleLocation();
      }
      
      /* Handling movement to destination */
      Vec2 deltaDestination = destination.sub(getLocation());
      deltaDestination.mulLocal(getWorldObject().getMass());
      
      applyForceToCenter(deltaDestination);
    }
    
    super.update();
  }
  
  /*
   * A method that handles the movements of the kinematic entity.
   * AIs do not use this to move. Forces applied for AIs to move is not limited to 8 directions, while, for players, they are.
   */
  
  private void handleMovements() {
    Vec2 force = new Vec2();
    
    if (movingUp)
      force.addLocal(up);
    if (movingDown)
      force.addLocal(down);
    if (movingLeft)
      force.addLocal(left);
    if (movingRight)
      force.addLocal(right);
    
    if (abs(force.x) > zeroThreshold || abs(force.y) > zeroThreshold) {
      force.normalize();
      force.mulLocal(movingForceMagnitude);
      force = rotate(force, getAngle());
      
      applyForceToCenter(force);
    }
    
    float angularForce = 0;
    
    if (rotatingCW)
      angularForce += rotationValue;
    if (rotatingCCW)
      angularForce -= rotationValue;
      
    if (abs(angularForce) > zeroThreshold)
      applyAngularForce(angularForce);
  }
  
  /*
   * A method that handles the collision with other world entity. If it is a projectile, damage is taken accordingly. 
   */
  
  public void handleCollision(WorldEntity that) {
    if (that instanceof ProjectileEntity) {
      if (!((ProjectileEntity) that).isExcepted(this)) {
        setHealth(health - ((ProjectileEntity) that).getDamage());
        ((ProjectileEntity) that).addException(this);
      }
    }
  }
  
  /*
   * A method that finds out the angle the target and the entity. 
   */

  private float deltaAngleTarget() {
    return getAngleOf(targetEntity.getLocation().sub(getLocation()));
  }
  
  /*
   * A method that causes the entity to aim towards the target. 
   */
  
  public void aimTowardsTarget() {
    float angle = deltaAngleTarget();
    float direction = (angle - getSightAngle()) / TAU;
    direction -= round(direction);
    direction *= TAU;
    setSightAngle(getSightAngle() + perSecond(direction + map(randomGen.getNoise(seconds()), 0, 1, minAimingDeviation, maxAimingDeviation)));
  }
  
  /*
   * A method that reloads the currently holding weapon. 
   */
  
  public void reload() {
    if (!weaponList.isEmpty())
      weaponList.get(weaponListPointer).beginReload();
  }
  
  /*
   * A method that displays the kinematic
   */
  
  public void display() {
    super.display();
    
    if (usingHealthBar)
      displayHealthBar();
  }
  
  /*
   * A method that displays the health bar of the entity. 
   */
  
  public void displayHealthBar() {
    pushMatrix();
    pushStyle();
    translate(getLocation().x + healthBarLocation.x, getLocation().y + healthBarLocation.y);
    strokeWeight(healthBarStrokeWeight);
    stroke(healthBarStroke);
    fill(healthBarBackgroundColor);
    rect(0, 0, healthBarWidth, healthBarHeight);
    strokeWeight(0);
    stroke(healthBarForegroundColor);
    fill(healthBarForegroundColor);
    float innerWidth = healthBarWidth * getHealth() / getFullHealth();
    float xCoordOffset = (-healthBarWidth / 2f + innerWidth - healthBarWidth / 2f) / 2f; 
    translate(xCoordOffset, 0);
    rect(0, 0, innerWidth, healthBarHeight);
    popStyle();
    popMatrix();
  }
}

class TankEntity extends KinematicEntity {
  public TankEntity(TankEntityDef tankEntityDef) {
    super(tankEntityDef);
  }
  
  /*
   * Since KinematicEntity class does not know how an entity should be drawn, TankEntity defines that.
   */
  
  public void display() {
    super.display();
    
    pushMatrix();
    pushStyle();
    translate(getLocation().x, getLocation().y);
    rotate(getSightAngle());
    super.getWorldObject().applyStyles();
    quad(-15, -15, 15, -12, 15, 12, -15, 15);
    rect(35, 0, 40, 10);
    popStyle();
    popMatrix();
  }
}
