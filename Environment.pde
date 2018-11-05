/*
 * An Environment class that handles everything in the environment.
 */

class Environment {
  private Game game;
  private Box2DProcessing box2d;
  protected LinkedList<Entity> entities;
  protected LinkedList<TankEntity> enemies;
  private Queue<Entity> entityQueue;
  private TankEntity player;
  private Camera camera;
  protected int numEnemies;
  private TankEntityDef playerDef;
  protected TankEntityDef enemyDef;
  private EnvironmentDef environmentDef;
  private color killScreenColor;
  private float killScreenLoadingTime, killedTime, killScreenOpacity;
  private boolean killed, killScreenLoaded;
  private LinkedList<Widget> widgets;
  private Widget selectedWidget;
  private boolean transitioning, disableScoring;
  private float transitionBeginTime, transitionTime;
  private color transitionColor;
  private int highScore;
  private ScoreBoard scoreBoard;
  
  public Environment(EnvironmentDef environmentDef) {
    game = environmentDef.getGame();
    this.environmentDef = environmentDef;
    highScore = environmentDef.getHighScore();
    reset();
  }
  
  public void reset() {
    box2d = new Box2DProcessing(game.getSketch());
    box2d.createWorld(new Vec2(0, 0), true, true);
    box2d.listenForCollisions();
    entityQueue = new LinkedList<Entity>();
    killScreenColor = environmentDef.getKillScreenColor();
    killScreenColor = setAlpha(killScreenColor, 0);
    killScreenLoadingTime = environmentDef.getKillScreenLoadingTime();
    killScreenOpacity = environmentDef.getKillScreenOpacity();
    killedTime = Float.NEGATIVE_INFINITY;
    killed = false;
    killScreenLoaded = false;
    widgets = environmentDef.createWidgetList();
    selectedWidget = null;
    transitionTime = environmentDef.getTransitionTime();
    transitionColor = environmentDef.getTransitionColor();
    disableScoring = false;
    scoreBoard = environmentDef.createScoreBoard();
    
    playerDef = new TankEntityDef();
    playerDef.setMovingForceMagnitude(1000000);
    playerDef.setRotationValue(25);
    playerDef.setFullHealth(100);
    playerDef.setHealth(100);
    playerDef.setOverHealthDropRate(3);
    playerDef.setEnvironment(this);
    playerDef.setFadingTime(0.3);
    playerDef.setUsingHealthBar(true);
    playerDef.setHealthBarBackgroundColor(color(255, 0, 0));
    playerDef.setHealthBarForegroundColor(color(0, 255, 0));
    playerDef.setHealthBarStroke(color(0));
    playerDef.setHealthBarWidth(80f);
    playerDef.setHealthBarHeight(10f);
    playerDef.setHealthBarStrokeWeight(2f);
    playerDef.setHealthBarLocation(new Vec2(0, -80));
    
    enemyDef = new TankEntityDef();
    enemyDef.setMovingForceMagnitude(500000);
    enemyDef.setRotationValue(25);
    enemyDef.setFullHealth(100);
    enemyDef.setHealth(100);
    enemyDef.setOverHealthDropRate(3);
    enemyDef.setEnvironment(this);
    enemyDef.setFadingTime(0.3);
    enemyDef.setPromptingAngle(PI / 6f);
    enemyDef.setAI(true);
    enemyDef.setShootingOdds(1);
    enemyDef.setChangingOdds(0.1);
    enemyDef.setDestinationChangingOdds(0.01);
    enemyDef.setUsingHealthBar(true);
    enemyDef.setHealthBarBackgroundColor(color(255, 0, 0));
    enemyDef.setHealthBarForegroundColor(color(0, 255, 0));
    enemyDef.setHealthBarStroke(color(0));
    enemyDef.setHealthBarWidth(80f);
    enemyDef.setHealthBarHeight(10f);
    enemyDef.setHealthBarStrokeWeight(2f);
    enemyDef.setHealthBarLocation(new Vec2(0, -80));
    
    PolygonalWorldObjectDef polygonalWorldObjectDef = new PolygonalWorldObjectDef();
    polygonalWorldObjectDef.setWorld(box2d);
    LinkedList<Vec2> vertices = new LinkedList<Vec2>();
    vertices.add(new Vec2(45, -25));
    vertices.add(new Vec2(50, -21));
    vertices.add(new Vec2(50, 21));
    vertices.add(new Vec2(45, 25));
    vertices.add(new Vec2(-50, 25));
    vertices.add(new Vec2(-50, -25));
    polygonalWorldObjectDef.setVertices(vertices);
    polygonalWorldObjectDef.setLocation(new Vec2(0, 0));
    polygonalWorldObjectDef.setAngle(-PI / 2f);
    polygonalWorldObjectDef.setStyles(color(0), color(255, 0, 0), 3);
    polygonalWorldObjectDef.setType(BodyType.DYNAMIC);
    polygonalWorldObjectDef.setLinearDamping(3);
    polygonalWorldObjectDef.setAngularDamping(12.5);
    polygonalWorldObjectDef.setDensity(pow(box2d.scalarPixelsToWorld(1), 2));
    polygonalWorldObjectDef.setMaxLinearVelocityMagnitude(300);
    polygonalWorldObjectDef.setFriction(0.3);
    
    RectangularWorldObjectDef explosiveObjDef = new RectangularWorldObjectDef();
    explosiveObjDef.setWorld(box2d);
    explosiveObjDef.setLocation(new Vec2(0, 0));
    explosiveObjDef.setWidth(20);
    explosiveObjDef.setHeight(6);
    explosiveObjDef.setStyles(color(206, 179, 82), color(0), 1);
    explosiveObjDef.setType(BodyType.DYNAMIC);
    explosiveObjDef.setLinearDamping(3);
    explosiveObjDef.setAngularDamping(12.5);
    explosiveObjDef.setDensity(pow(box2d.scalarPixelsToWorld(10), 2));
    explosiveObjDef.setFriction(0.3);
    explosiveObjDef.setBullet(true);
    
    ParticleDef particleDef = new ParticleDef();
    particleDef.setLocation(new Vec2());
    particleDef.setLinearVelocity(new Vec2());
    particleDef.setAcceleration(new Vec2());
    particleDef.setLifeTime(0.5);
    particleDef.setStrokeWeight(0);
    particleDef.setMass(1);
    particleDef.setFading(true);
    
    ParticleSystemDef explosionDef = new ParticleSystemDef();
    color[] colors = {color(50), color(25), color(100), color(255, 208, 0), color(255, 170, 0), color(193, 0, 0), color(255, 119, 0)};
    explosionDef.setLifeTime(0.5);
    explosionDef.setColors(colors);
    explosionDef.setContinuous(false);
    explosionDef.setEnvironment(this);
    explosionDef.setNumParticles(8);
    explosionDef.setRadiusRange(20, 70);
    explosionDef.setSpeedRange(30, 60);
    explosionDef.setParticleDef(particleDef);
    
    ProjectileEntityDef he = new ProjectileEntityDef();
    he.setWorldObjectDef(explosiveObjDef);
    he.setAngularDamping(0);
    he.setDamage(70);
    he.setEnvironment(this);
    he.setExplosive(true);
    he.setLifeTime(3);
    he.setLinearDamping(0);
    he.setNumCollisionsBeforeDestruction(1);
    he.setRange(5000);
    he.setExplosionDef(explosionDef);
    
    WeaponDef heLauncher = new WeaponDef();
    heLauncher.setBarrelTipLocation(new Vec2(70, 0));
    heLauncher.setInitialProjectileSpeed(700);
    heLauncher.setMagazineCapacity(1);
    heLauncher.setMagazineClip(1);
    heLauncher.setProjectileEntityDef(he);
    heLauncher.setReloadTime(0.7);
    heLauncher.setShootingTime(0.5);
    heLauncher.setDeviation(0.01);
    heLauncher.setShotSoundFileSketchPath("artilleryshot.wav");
    heLauncher.setReloadSoundFileSketchPath("artilleryreload.wav");
    
    ParticleSystemDef smallExplosionDef = new ParticleSystemDef();
    smallExplosionDef.setLifeTime(0.5);
    smallExplosionDef.setColors(colors);
    smallExplosionDef.setContinuous(false);
    smallExplosionDef.setEnvironment(this);
    smallExplosionDef.setNumParticles(6);
    smallExplosionDef.setRadiusRange(5, 20);
    smallExplosionDef.setSpeedRange(30, 50);
    smallExplosionDef.setParticleDef(particleDef);
    
    RectangularWorldObjectDef bulletObjDef = new RectangularWorldObjectDef();
    bulletObjDef.setWorld(box2d);
    bulletObjDef.setLocation(new Vec2(0, 0));
    bulletObjDef.setWidth(10);
    bulletObjDef.setHeight(3);
    bulletObjDef.setStyles(color(206, 179, 82), color(0), 1);
    bulletObjDef.setType(BodyType.DYNAMIC);
    bulletObjDef.setLinearDamping(3);
    bulletObjDef.setAngularDamping(12.5);
    bulletObjDef.setDensity(pow(box2d.scalarPixelsToWorld(0.25), 2));
    bulletObjDef.setFriction(0.3);
    bulletObjDef.setBullet(true);
    
    ProjectileEntityDef se = new ProjectileEntityDef();
    se.setWorldObjectDef(bulletObjDef);
    se.setAngularDamping(0);
    se.setDamage(14);
    se.setEnvironment(this);
    se.setExplosive(true);
    se.setLifeTime(10);
    se.setLinearDamping(0);
    se.setNumCollisionsBeforeDestruction(1);
    se.setRange(5000);
    se.setExplosionDef(smallExplosionDef);
    
    WeaponDef machineGun = new WeaponDef();
    machineGun.setBarrelTipLocation(new Vec2(70, 0));
    machineGun.setInitialProjectileSpeed(1500);
    machineGun.setMagazineCapacity(100);
    machineGun.setMagazineClip(100);
    machineGun.setProjectileEntityDef(se);
    machineGun.setReloadTime(3);
    machineGun.setShootingTime(0.10);
    machineGun.setDeviation(PI / 12f);
    machineGun.setShotSoundFileSketchPath("gunshot.wav");
    machineGun.setReloadSoundFileSketchPath("gunreload.mp3");
    
    playerDef.setWorldObjectDef(polygonalWorldObjectDef);
    playerDef.addWeaponDef(heLauncher);
    playerDef.addWeaponDef(machineGun);
    player = new TankEntity(playerDef);
    
    CameraDef cameraDef = environmentDef.getCameraDef();
    cameraDef.setTarget(player);
    cameraDef.setLocation(player.getLocation());
    camera = cameraDef.createCamera();
    numEnemies = environmentDef.getNumEnemies();
    
    enemyDef.setWorldObjectDef(polygonalWorldObjectDef);
    heLauncher.setShotSoundFileSketchPath(null);
    heLauncher.setReloadSoundFileSketchPath(null);
    machineGun.setShotSoundFileSketchPath(null);
    machineGun.setReloadSoundFileSketchPath(null);
    enemyDef.addWeaponDef(heLauncher);
    enemyDef.addWeaponDef(machineGun);
    enemyDef.setTargetEntity(player);

    entities = new LinkedList<Entity>();
    enemies = new LinkedList<TankEntity>();
    
    for (int i = 0; i < numEnemies; i++) {
      createEnemy();
    }
  }
  
  /*
   * A method that creates an enemy with random attributes near the player outside the screen. 
   */
  
  public void createEnemy() {
    enemyDef.setLocation(getRandomInvisibleLocation(enemyDef.getWorldObjectDef().getLongestDistanceFromCenter()));
    enemyDef.setAngle(random(TAU));
    enemyDef.getWorldObjectDef().setFill(color(0));
    enemyDef.getWorldObjectDef().setStroke(color(random(255), random(255), random(255)));
    enemyDef.setSightAngle(random(TAU));
    enemyDef.setAimingDeviationRange(-PI / 12, PI / 12);
    enemyDef.setWeaponListPointer(floor(random(enemyDef.getWeaponCount())));
    enemies.add(new TankEntity(enemyDef));
  }
  
  /*
   * A method that adds the widgets, such as respawn button, or main menu button when the player dies. 
   */
  
  public void addKillScreenWidgets() {
    LabelDef killLabel = new LabelDef();
    killLabel.setFill(color(255));
    killLabel.setLocation(new Vec2(width / 2f, height / 4f));
    killLabel.setStrokeWeight(height / 10f);
    killLabel.setText("Game Over");
    
    LabelDef scoreLabel = new LabelDef();
    scoreLabel.setFill(color(255));
    scoreLabel.setLocation(new Vec2(width / 2f, 2 * height / 5f));
    scoreLabel.setStrokeWeight(height / 22f);
    scoreLabel.setText("Score: " + scoreBoard.getScore() + "\nHigh Score: " + highScore);
    
    ButtonDef respawnButton = new ButtonDef();
    respawnButton.setLocation(new Vec2(width / 2f, 5.5 * height / 10f));
    respawnButton.setActiveFill(color(150, 200));
    respawnButton.setEvent(new RestartEvent(this));
    respawnButton.setFill(color(255, 200));
    respawnButton.setStroke(color(0));
    respawnButton.setStrokeWeight(3);
    respawnButton.setText("Restart Game");
    respawnButton.setFontSize(height / 20f);
    respawnButton.setTextColor(color(0));
    respawnButton.setWidth(3 * width / 10f);
    respawnButton.setHeight(height / 10f);

    ButtonDef mainMenuButton = new ButtonDef();
    mainMenuButton.setLocation(new Vec2(width / 2f, 6.7 * height / 10f));
    mainMenuButton.setActiveFill(color(150, 200));
    mainMenuButton.setEvent(new GoToMainMenuEvent(game));
    mainMenuButton.setFill(color(255, 200));
    mainMenuButton.setStroke(color(0));
    mainMenuButton.setStrokeWeight(3);
    mainMenuButton.setText("Main Menu");
    mainMenuButton.setFontSize(height / 20f);
    mainMenuButton.setTextColor(color(0));
    mainMenuButton.setWidth(3 * width / 10f);
    mainMenuButton.setHeight(height / 10f);

    
    widgets.add(killLabel.createWidget());
    widgets.add(scoreLabel.createWidget());
    widgets.add(respawnButton.createWidget());
    widgets.add(mainMenuButton.createWidget());
  }
  
  /*
   * A small number of getters.
   */
  
  public Game getGame() {
    return game;
  }
  
  public TankEntity getPlayer() {
    return player;
  }
  
  /*
   * A method that restarts the environment. 
   */
  
  public void restart() {
    transitioning = true;
    transitionBeginTime = seconds();
  }
  
  /*
   * A method that adds to the score of the environment.
   */
  
  public void addScore(int delta) {
    if (!disableScoring) scoreBoard.setScore(scoreBoard.getScore() + delta);
  }
  
  /*
   * A method that updates the environment, such as the entities, widgets, etc. 
   */
  
  public void update() {
    if (transitioning) {
      if (seconds() - transitionBeginTime > transitionTime / 2f && player == null) {
        reset();
      }
      
      float alpha = min(255, seconds() - transitionBeginTime <= transitionTime / 2f ?
                  255 * (seconds() - transitionBeginTime) / (transitionTime / 2f) :
                  255 * (transitionTime / 2f - (seconds() - transitionBeginTime - transitionTime / 2f)) / (transitionTime / 2f));

      transitionColor = setAlpha(transitionColor, alpha);
      
      if (transitioning && seconds() - transitionBeginTime > transitionTime) {
        transitioning = false;
      }
    } else {
      box2d.step(perSecond(), 10, 8);
      box2d.world.clearForces();
      
      updateEntities();
      updateEnemies();
      
      if (player != null && player.isMarkedForDestruction()) {
        player.destroy();
        player = null;
      }
      
      if (player != null) {
        player.update();
        player.setSightAngle(camera.coordScreenToPixels(new Vec2(mouseX, mouseY)));
      } else {
        if (!killed) {
          killed = true;
          killedTime = seconds();
          
          if (scoreBoard.getScore() > highScore) {
            disableScoring = true;
            highScore = scoreBoard.getScore();
            game.setHighScore(highScore);
          }
        }
        killScreenColor = setAlpha(killScreenColor, min(killScreenOpacity, killScreenOpacity * (seconds() - killedTime) / killScreenLoadingTime));
      }
      
      if (seconds() - killedTime > killScreenLoadingTime && !killScreenLoaded && killed) {
        killScreenLoaded = true;
        addKillScreenWidgets();
      }
      
      camera.update();
    }
    
    while (enemies.size() < numEnemies) {
      createEnemy();
    }
  }
  
  /*
   * A method that displays the environment. It basically displays background, entities, enemies, the player, and, if necessary, the killscreen.
   */
  
  public void display() {
    pushMatrix();
    
    camera.translateToBody();
    camera.displayBackground();
    displayEntities();
    displayEnemies();
    if (player != null) 
      player.display();
    
    popMatrix();
    
    if (killed) {
      pushStyle();
      fill(killScreenColor);
      stroke(killScreenColor);
      strokeWeight(0);
      rect(width / 2f, height / 2f, width, height);
      popStyle();
    } else {
      scoreBoard.display();
    }
    
    for (Widget widget : widgets) {
      widget.display();
    }
    
    if (transitioning) {
      pushStyle();
      fill(transitionColor);
      stroke(transitionColor);
      strokeWeight(0);
      rect(width / 2f, height / 2f, width, height);
      popStyle();
    }
  }
  
  /*
   * A method that updates the individual enemies. 
   */
  
  private void updateEnemies() {
    for (Iterator<TankEntity> it = enemies.iterator(); it.hasNext();) {
      TankEntity enemy = it.next();
      enemy.update();
      
      if (enemy.isMarkedForDestruction()) {
        enemy.destroy();
        it.remove();
      }
    }
  }
  
  /*
   * A method that displays the individual enemies. 
   */
  
  private void displayEnemies() {
    for (Iterator<TankEntity> it = enemies.iterator(); it.hasNext();) {
      TankEntity enemy = it.next();
      
      if (camera.isVisible(enemy)) {
        enemy.display();
      }
    }
  }
  
  /*
   * A method that updates the individual entities, and adds new ones. 
   */
  
  private void updateEntities() {
    for (Iterator<Entity> it = entities.iterator(); it.hasNext();) {
      Entity entity = it.next();
      entity.update();
      
      if (entity.isMarkedForDestruction()) {
        entity.destroy();
        it.remove();
      }
    }
    
    while (!entityQueue.isEmpty()) {
      entities.add(entityQueue.remove());
    }
  }
  
  /*
   * A method that displays the individual entities. 
   */
  
  private void displayEntities() {
    for (Iterator<Entity> it = entities.iterator(); it.hasNext();) {
      Entity entity = it.next();
      
      if (camera.isVisible(entity)) {
        entity.display();
      }
    }
  }
  
  /*
   * A method that destroys the environment. 
   */
  
  public void destroy() {
    for (Entity entity : entities)
      entity.destroy();
    
    if (player != null)
      player.destroy();
  }
  
  /*
   * A method that adds the entity into the queue of insertion. 
   */
  
  public void addEntity(Entity entity) {
    entityQueue.add(entity);
  }
  
  /*
   * A method that sees if coordinates are contained by a widget.
   */
  
  public boolean testWidgets(float x, float y, boolean enable) {
    for (Widget widget : widgets) {
      if (widget.contains(x, y)) {
        if (!enable) {
          selectedWidget = widget;
        } else {
          if (selectedWidget == widget) {
            widget.action();
          }
          
          selectedWidget = null;
        }
        
        return true;
      }
    }
    
    selectedWidget = null;
    return false;
  }
  
  /*
   * For 4 methods below, look at the Camera.pde file. 
   */
  
  public boolean isVisible(Entity entity) {
    return camera.isVisible(entity);
  }
  
  public boolean isVisible(Vec2 location, float longestDistanceFromCenter) {
    return camera.isVisible(location, longestDistanceFromCenter);
  }
  
  public Vec2 getRandomInvisibleLocation(float offset) {
    return camera == null ? new Vec2() : camera.getRandomInvisibleLocation(offset);
  }
  
  public Vec2 getRandomVisibleLocation() {
    return camera == null ? new Vec2() : camera.getRandomVisibleLocation();
  }
  
  /*
   * Methods below handles the keyboard or mouse events as necessary.
   */
  
  public void keyPressed() {
    if (key == CODED) {
      switch (keyCode) {
      }
    } else {
      switch (key) {
        case 'w': case 'W': {
          if (player != null && player.isAlive()) player.moveUp(true);
        }
          break;
        case 's': case 'S': {
          if (player != null && player.isAlive()) player.moveDown(true);
        }
          break;
        case 'a': case 'A': {
          if (player != null && player.isAlive()) player.rotateCCW(true);
        }
          break;
        case 'd': case 'D': {
          if (player != null && player.isAlive()) player.rotateCW(true);
        }
          break;
        case 'r': case 'R': {
          if (player != null && player.isAlive()) player.reload();
        }
          break;
      }
    }
  }
  
  public void keyReleased() {
    if (key == CODED) {
      switch (keyCode) {
      }
    } else {
      switch (key) {
        case 'w': case 'W': {
          if (player != null && player.isAlive()) player.moveUp(false);
        }
          break;
        case 's': case 'S': {
          if (player != null && player.isAlive()) player.moveDown(false);
        }
          break;
        case 'a': case 'A': {
          if (player != null && player.isAlive()) player.rotateCCW(false);
        }
          break;
        case 'd': case 'D': {
          if (player != null && player.isAlive()) player.rotateCW(false);
        }
          break;
      }
    }
  }
  
  public void keyTyped() {
    
  }
  
  public void mousePressed() {
    if (!testWidgets(mouseX, mouseY, false) && player != null && player.isAlive()) player.setActive(true);
  }
  
  public void mouseReleased() {
    if (!testWidgets(mouseX, mouseY, true) && player != null && player.isAlive()) player.setActive(false);
  }
  
  public void mouseClicked() {
    
  }
  
  public void mouseDragged(MouseEvent event) {
    
  }
  
  public void mouseWheel(MouseEvent event) {
    if (player != null && player.isAlive()) player.setWeaponListPointer(player.getWeaponListPointer() - event.getCount());
  }
} //<>//

/*
 * These two functions are called when there are contacts within the 'world' between WorldObjects 
 */

void beginContact(Contact cp) {
  WorldEntity a = (WorldEntity) cp.getFixtureA().getBody().getUserData(), b = (WorldEntity) cp.getFixtureB().getBody().getUserData();
  a.handleCollision(b);
  b.handleCollision(a);
}

void endContact(Contact cp) {
  
}
