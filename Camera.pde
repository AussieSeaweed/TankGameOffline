/*
 * A Camera Class that handles the translation of the screen towards the player.
 * Also, it handles some geometric tasks, such as figuring out if an entity is inside or outside the screen, etc.
 */

private class Camera extends IntangibleObject {
  private Entity target;
  private color backgroundFill, backgroundStroke;
  private float maxDistanceToTarget, cellStep, backgroundStrokeWeight;
  
  public Camera(CameraDef cameraDef) {
    super(cameraDef);
    this.target = cameraDef.getTarget();
    this.maxDistanceToTarget = cameraDef.getMaxDistanceToTarget();
    this.backgroundFill = cameraDef.getBackgroundFill();
    this.backgroundStroke = cameraDef.getBackgroundStroke();
    this.backgroundStrokeWeight = cameraDef.getBackgroundStrokeWeight();
    this.cellStep = cameraDef.getCellStep();
  }
  
  /*
   * A method that gets a random location outside the screen. 
   */
  
  public Vec2 getRandomInvisibleLocation(float offset) {
    return getLocation().add(getRandomUnitVector().mulLocal(offset + getDiagonal() / 2f));
  }
  
  /*
   * A method that gets a random location inside the screen. 
   */
  
  public Vec2 getRandomVisibleLocation() {
    return getLocation().add(new Vec2(random(-width / 2f, width / 2f), random(-height / 2f, height / 2f)));
  }
  
  /*
   * A method that updates the location of the camera based on its target's location.
   */
  
  public void update() {
    Vec2 delta = target.getLocation().sub(getLocation());
    applyForceToCenter(delta.mul(frameRate * frameRate).sub(getLinearVelocity().mul(frameRate)));
    
    super.update();
  }
  
  /*
   * A method that translates so that the camera's target will be centered.
   */
  
  @Override
  public void translateToBody() {
    translate(-getLocation().x + width / 2f, -getLocation().y + height / 2f);
  }
  
  /*
   * A method that determines if an entity is visible or not.
   */
  
  public boolean isVisible(Entity entity) {
    return isVisible(entity.getLocation(), entity.getLongestDistanceFromCenter());
  }
  
  /*
   * A method that determines if something is visible or not, based on the location, and longest distance from the supplied location.
   */
  
  public boolean isVisible(Vec2 target, float distance) {
    float x = getLocation().x, y = getLocation().y;
    return (x - width / 2f <= target.x + distance && target.x - distance <= x + width / 2f) &&
            (y - height / 2f <= target.y + distance && target.y - distance <= y + height / 2f);
  }
  
  /*
   * A method that gets the diagonal length of the screen.
   */
  
  public float getDiagonal() {
    return sqrt(width * width + height * height);
  }
  
  /*
   * A method that gets the top left location of the screen with regards to the target.
   */
  
  public Vec2 getTopLeft() {
    return getLocation().sub(new Vec2(width / 2f, height / 2f));
  }
  
  /*
   * A method that gets the bottom right location of the screen with regards to the target.
   */
  
  public Vec2 getBottomRight() {
    return getLocation().add(new Vec2(width / 2f, height / 2f));
  }
  
  /*
   * A method that displays the background, with cells, to create an illusion that the screen is moving.
   */
  
  public void displayBackground() {
    pushStyle();
    background(backgroundFill);
    stroke(backgroundStroke);
    strokeWeight(backgroundStrokeWeight);
    
    Vec2 topLeft = getTopLeft();
    Vec2 bottomRight = getBottomRight();
    
    for (float x = (topLeft.x - topLeft.x % cellStep) - cellStep; x <= bottomRight.x; x += cellStep)
      line(x, topLeft.y, x, bottomRight.y);
    
    for (float y = (topLeft.y - topLeft.y % cellStep) - cellStep; y <= bottomRight.y; y += cellStep)
      line(topLeft.x, y, bottomRight.x, y);
    
    popStyle();
  }
  
  /*
   * A method that translates the actual screen coordinates to the coordinates with regards to the target.
   */
  
  public Vec2 coordScreenToPixels(Vec2 coord) {
    return getTopLeft().add(coord);
  }
  
  /*
   * Getter and Setter Functions 
   */
  
  public void setTarget(Entity target) {
    this.target = target;
  }
  
  public float getMaxDistanceToTarget() {
    return maxDistanceToTarget;
  }
  
  public void setMaxDistanceToTarget(float maxDistanceToTarget) {
    this.maxDistanceToTarget = maxDistanceToTarget;
  }
}
