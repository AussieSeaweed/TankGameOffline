abstract class WorldObjectDef {
  private Box2DProcessing box2d;
  private BodyDef bodyDef;
  private FixtureDef fixtureDef;
  private float maxLinearVelocityMagnitude, maxAngularVelocityValue;
  
  private color fill, stroke;
  private float strokeWeight;
  
  public WorldObjectDef() {
    bodyDef = new BodyDef();
    fixtureDef = new FixtureDef();
    
    maxLinearVelocityMagnitude = Float.POSITIVE_INFINITY;
    maxAngularVelocityValue = Float.POSITIVE_INFINITY;
  }
  
  public Body createBody() {
    Body body = box2d.createBody(bodyDef);
    fixtureDef.setShape(getShape());
    body.createFixture(fixtureDef);
    return body;
  }
  
  public Box2DProcessing getWorld() {
    return box2d;
  }
  
  public void setWorld(Box2DProcessing box2d) {
    this.box2d = box2d;
  }
  
  public color getFill() {
    return fill;
  }
  
  public void setFill(color fill) {
    this.fill = fill;
  }
  
  public color getStroke() {
    return stroke;
  }
  
  public void setStroke(color stroke) {
    this.stroke = stroke;
  }
  
  public float getStrokeWeight() {
    return strokeWeight;
  }
  
  public void setStrokeWeight(float strokeWeight) {
    this.strokeWeight = strokeWeight;
  }
  
  public void setStyles(color fill, color stroke, float strokeWeight) {
    setFill(fill);
    setStroke(stroke);
    setStrokeWeight(strokeWeight);
  }
  
  public void setUserData(Object userData) {
    bodyDef.setUserData(userData);
  }
  
  public Object getUserData() {
    return bodyDef.getUserData();
  }

  public BodyType getType() {
    return bodyDef.type;
  }
  
  public void setType(BodyType type) {
    bodyDef.type = type;
  }
  
  public float getDensity() {
    return pow(box2d.scalarPixelsToWorld(1), 2) * fixtureDef.getDensity();
  }
  
  public void setDensity(float density) {
    fixtureDef.setDensity(pow(box2d.scalarWorldToPixels(1), 2) * density);
  }
  
  public Filter getFilter() {
    return fixtureDef.getFilter();
  }

  public void setFilter(Filter filter) {
    fixtureDef.setFilter(filter);
  }

  public float getRestitution() {
    return fixtureDef.getRestitution();
  }

  public void setRestitution(float restitution) {
    fixtureDef.setRestitution(restitution);
  }

  public float getFriction() {
    return fixtureDef.getFriction();
  }

  public void setFriction(float friction) {
    fixtureDef.setFriction(friction);
  }

  public void setSensor(boolean sensor) {
    fixtureDef.setSensor(sensor);
  }
  
  public float getAngle() {
    return -bodyDef.getAngle();
  }
  
  public void setAngle(float angle) {
    bodyDef.setAngle(-angle);
  }
  
  public float getAngularDamping() {
    return bodyDef.getAngularDamping();
  }
  
  public void setAngularDamping(float angularDamping) {
    bodyDef.setAngularDamping(angularDamping);
  }
  
  public float getAngularVelocity() {
    return bodyDef.getAngularVelocity();
  }
  
  public void setAngularVelocity(float angularVelocity) {
    bodyDef.setAngularVelocity(-angularVelocity);
  }
  
  public float getGravityScale() {
    return bodyDef.getGravityScale();
  }
  
  public void setGravityScale(float gravityScale) {
    bodyDef.setGravityScale(gravityScale);
  }
  
  public float getLinearDamping() {
    return bodyDef.getLinearDamping();
  }
  
  public void setLinearDamping(float linearDamping) {
    bodyDef.setLinearDamping(linearDamping);
  }
  
  public Vec2 getLinearVelocity() {
    return box2d.vectorWorldToPixels(bodyDef.getLinearVelocity());
  }
  
  public void setLinearVelocity(Vec2 linearVelocity) {
    bodyDef.setLinearVelocity(box2d.vectorPixelsToWorld(linearVelocity));
  }
  
  public Vec2 getLocation() {
    return box2d.coordWorldToPixels(bodyDef.getPosition());
  }
  
  public void setLocation(Vec2 location) {
    bodyDef.setPosition(box2d.coordPixelsToWorld(location));
  }
  
  public boolean isBullet() {
    return bodyDef.isBullet();
  }
  
  public void setBullet(boolean bullet) {
    bodyDef.setBullet(bullet);
  }
  
  public boolean isFixedRotation() {
    return bodyDef.isFixedRotation();
  }
  
  public void setFixedRotation(boolean fixedRotation) {
    bodyDef.setFixedRotation(fixedRotation);
  }
  
  public float getMaxLinearVelocityMagnitude() {
    return maxLinearVelocityMagnitude;
  }
  
  public void setMaxLinearVelocityMagnitude(float maxLinearVelocityMagnitude) {
    this.maxLinearVelocityMagnitude = maxLinearVelocityMagnitude;
  }
  
  public float getMaxAngularVelocityValue() {
    return maxAngularVelocityValue;
  }
  
  public void setMaxAngularVelocityValue(float maxAngularVelocityValue) {
    this.maxAngularVelocityValue = maxAngularVelocityValue;
  }
  
  protected abstract Shape getShape();
  public abstract WorldObject createWorldObject();
  public abstract float getLongestDistanceFromCenter();
  
  /*
  Not implemented
  bodyDef.isAllowSleep();
  bodyDef.isActive();
  bodyDef.isAwake();
  */
}

class CircularWorldObjectDef extends WorldObjectDef {
  private CircleShape circleShape;
  
  public CircularWorldObjectDef() {
    circleShape = new CircleShape();
  }
  
  public float getRadius() {
    return getWorld().scalarWorldToPixels(circleShape.getRadius());
  }
  
  public void setRadius(float radius) {
    circleShape.setRadius(getWorld().scalarPixelsToWorld(radius));
  }
  
  public float getDiameter() {
    return getWorld().scalarWorldToPixels(circleShape.getRadius() * 2f);
  }
  
  public void setDiamter(float diameter) {
    circleShape.setRadius(getWorld().scalarPixelsToWorld(diameter / 2f));
  }
  
  protected Shape getShape() {
    return circleShape;
  }
  
  public WorldObject createWorldObject() {
    return new CircularWorldObject(this);
  }
  
  public float getLongestDistanceFromCenter() {
    return circleShape.m_radius;
  }
}

class RectangularWorldObjectDef extends WorldObjectDef {
  private float width, height;
  private PolygonShape polygonShape;
 
  public RectangularWorldObjectDef() {
    polygonShape = new PolygonShape();
  }
  
  public float getWidth() {
    return width;
  }
  
  public void setWidth(float width) {
    this.width = width;
    polygonShape.setAsBox(getWorld().scalarPixelsToWorld(width / 2f), getWorld().scalarPixelsToWorld(height / 2f));
  }
  
  public float getHeight() {
    return height;
  }
  
  public void setHeight(float height) {
    this.height = height;
    polygonShape.setAsBox(getWorld().scalarPixelsToWorld(width / 2f), getWorld().scalarPixelsToWorld(height / 2f));
  }
  
  protected Shape getShape() {
    return polygonShape;
  }
  
  public WorldObject createWorldObject() {
    return new RectangularWorldObject(this);
  }
  
  public float getLongestDistanceFromCenter() {
    return sqrt(width * width + height * height);
  }
}

class PolygonalWorldObjectDef extends WorldObjectDef {
  private LinkedList<Vec2> vertices;
  private float maxDistanceFromCenter;
  private PolygonShape polygonShape;
 
  public PolygonalWorldObjectDef() {
    polygonShape = new PolygonShape();
  }
  
  public LinkedList<Vec2> getVertices() {
    return vertices;
  }
  
  public void setVertices(LinkedList<Vec2> vertices) {
    this.vertices = vertices;
    Vec2[] worldVertices = new Vec2[vertices.size()];
    
    int i;
    Iterator<Vec2> it;
    for (i = 0, it = vertices.iterator(); it.hasNext(); i++) {
      Vec2 vertex = it.next();
      worldVertices[i] = getWorld().vectorPixelsToWorld(vertex);
      maxDistanceFromCenter = max(maxDistanceFromCenter, vertex.length());
    }
    
    polygonShape.set(worldVertices, worldVertices.length);
  }
  
  protected Shape getShape() {
    return polygonShape;
  }
  
  public WorldObject createWorldObject() {
    return new PolygonalWorldObject(this);
  }
  
  public float getLongestDistanceFromCenter() {
    return maxDistanceFromCenter;
  }
}
