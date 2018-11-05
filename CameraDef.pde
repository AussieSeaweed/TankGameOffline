class CameraDef extends IntangibleObjectDef {
  private Entity target;
  private float maxDistanceToTarget, backgroundStrokeWeight, cellStep;
  private color backgroundFill, backgroundStroke;
  
  /*
   * All these methods are purely just getters and setters.
   */
  
  public Entity getTarget() {
    return target;
  }
  
  public void setTarget(Entity target) {
    this.target = target;
  }
  
  public float getMaxDistanceToTarget() {
    return maxDistanceToTarget;
  }
  
  public void setMaxDistanceToTarget(float maxDistanceToTarget) {
    this.maxDistanceToTarget = maxDistanceToTarget;
  }
  
  public color getBackgroundFill() {
    return backgroundFill;
  }
  
  public void setBackgroundFill(color backgroundFill) {
    this.backgroundFill = backgroundFill;
  }
  
  public color getBackgroundStroke() {
    return backgroundStroke;
  }
  
  public void setBackgroundStroke(color backgroundStroke) {
    this.backgroundStroke = backgroundStroke;
  }
  
  public float getBackgroundStrokeWeight() {
    return backgroundStrokeWeight;
  }
  
  public void setBackgroundStrokeWeight(float backgroundStrokeWeight) {
    this.backgroundStrokeWeight = backgroundStrokeWeight;
  }
      
  public float getCellStep() {
    return cellStep;
  }
  
  public void setCellStep(float cellStep) {
    this.cellStep = cellStep;
  }
  
  public Camera createCamera() {
    return new Camera(this);
  }
}
