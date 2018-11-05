/*
 * A ParticleSystem class that creates and manages particles.  
 */

class ParticleSystem extends Entity {
  private float minRadius, maxRadius, minSpeed, maxSpeed, lifeTime;
  private boolean continuous;
  private int numParticles;
  private Vec2 location;
  private LinkedList<Particle> particles;
  private ParticleDef particleDef;
  private color[] colors;
  
  public ParticleSystem(ParticleSystemDef particleSystemDef) {
    super(particleSystemDef);
    minRadius = particleSystemDef.getMinRadius();
    maxRadius = particleSystemDef.getMaxRadius();
    minSpeed = particleSystemDef.getMinSpeed();
    maxSpeed = particleSystemDef.getMaxSpeed();
    continuous = particleSystemDef.isContinuous();
    numParticles = particleSystemDef.getNumParticles();
    location = particleSystemDef.getLocation();
    colors = particleSystemDef.getColors();
    particleDef = particleSystemDef.getParticleDef();
    lifeTime = particleSystemDef.getLifeTime();
    
    particles = new LinkedList<Particle>();

    for (int i = 0; i < numParticles; i++) {
      addParticle();
    }
  }
  
  /*
   * These methods are getters and setters.  
   */
  
  public float getLifeTime() {
    return lifeTime;
  }
  
  public void setLifeTime(float lifeTime) {
    this.lifeTime = lifeTime;
  }
  
  public float getAngle() {
    return 0;
  }
  
  public void addParticle() {
    color c = colors[floor(random(colors.length))];
    particleDef.setFill(c);
    particleDef.setStroke(c);
    particleDef.setRadius(random(minRadius, maxRadius));
    particleDef.setLinearVelocity(getRandomUnitVector().mulLocal(random(minSpeed, maxSpeed)));
    particles.push(particleDef.createParticle());
  }
  
  public boolean isContinuous() {
    return continuous;
  }
  
  public void setContinuous(boolean continuous) {
    this.continuous = continuous;
  }
  
  public Vec2 getLocation() {
    return location;
  }
  
  public void setLocation(Vec2 location) {
    this.location = location;
  }
  
  public ParticleDef getParticleDef() {
    return particleDef;
  }
  
  public void setParticleDef(ParticleDef particleDef) {
    this.particleDef = particleDef;
  }
  
  public color[] getColors() {
    return colors;
  }
  
  public void setColors(color[] colors) {
    this.colors = colors;
  }
  
  public int getNumParticles() {
    return numParticles;
  }
  
  public void setNumParticles(int numParticles) {
    this.numParticles = numParticles;
  }
  
  public float getMinRadius() {
    return minRadius;
  }
  
  public void setMinRadius(float minRadius) {
    this.minRadius = minRadius;
  }
  
  public float getMaxRadius() {
    return maxRadius;
  }
  
  public void setMaxRadius(float maxRadius) {
    this.maxRadius = maxRadius;
  }
  
  public void setRadiusRange(float minRadius, float maxRadius) {
    this.minRadius = minRadius;
    this.maxRadius = maxRadius;
  }
  
  public float getMinSpeed() {
    return minSpeed;
  }
  
  public void setMinSpeed(float minSpeed) {
    this.minSpeed = minSpeed;
  }
  
  public float getMaxSpeed() {
    return maxSpeed;
  }
  
  public void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
  }
  
  public void setSpeedRange(float minSpeed, float maxSpeed) {
    this.minSpeed = minSpeed;
    this.maxSpeed = maxSpeed;
  }
  
  public float getLongestDistanceFromCenter() {
    return particleDef.getLifeTime() * maxSpeed + maxRadius + particleDef.getStrokeWeight();
  }
  
  /*
   * A method that updates particle system, by updating all particles, etc. Particle instances are managed by IntangibleObject class.  
   */
  
  public void update() {
    if (seconds() - getInitialTime() > lifeTime)
      markForDestruction();
    
    for (Iterator<Particle> it = particles.iterator(); it.hasNext();) {
      Particle particle = it.next();
      particle.update();
            
      if (particle.isMarkedForDestruction()) {
        it.remove();
      }
    }

    while (continuous && particles.size() < numParticles) {
      addParticle();
    }
  }
  
  /*
   * A method that displays the particle system, by displaying all individual particles.  
   */
  
  public void display() {
    for (Particle particle : particles) {
      particle.display(getLocation()); // DEBUG
    }
  }
  
  public void destroy() {}
}

class ParticleSystemDef extends EntityDef {
  private float minRadius, maxRadius, minSpeed, maxSpeed, lifeTime;
  private boolean continuous;
  private int numParticles;
  private Vec2 location;
  private ParticleDef particleDef;
  private color[] colors;
  
  public float getLifeTime() {
    return lifeTime;
  }
  
  public void setLifeTime(float lifeTime) {
    this.lifeTime = lifeTime;
  }
  
  public boolean isContinuous() {
    return continuous;
  }
  
  public void setContinuous(boolean continuous) {
    this.continuous = continuous;
  }
  
  public Vec2 getLocation() {
    return location;
  }
  
  public void setLocation(Vec2 location) {
    this.location = location;
  }
  
  public ParticleDef getParticleDef() {
    return particleDef;
  }
  
  public void setParticleDef(ParticleDef particleDef) {
    this.particleDef = particleDef;
  }
  
  public color[] getColors() {
    return colors;
  }
  
  public void setColors(color[] colors) {
    this.colors = colors;
  }
  
  public int getNumParticles() {
    return numParticles;
  }
  
  public void setNumParticles(int numParticles) {
    this.numParticles = numParticles;
  }
  
  public float getMinRadius() {
    return minRadius;
  }
  
  public void setMinRadius(float minRadius) {
    this.minRadius = minRadius;
  }
  
  public float getMaxRadius() {
    return maxRadius;
  }
  
  public void setMaxRadius(float maxRadius) {
    this.maxRadius = maxRadius;
  }
  
  public void setRadiusRange(float minRadius, float maxRadius) {
    this.minRadius = minRadius;
    this.maxRadius = maxRadius;
  }
  
  public float getMinSpeed() {
    return minSpeed;
  }
  
  public void setMinSpeed(float minSpeed) {
    this.minSpeed = minSpeed;
  }
  
  public float getMaxSpeed() {
    return maxSpeed;
  }
  
  public void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
  }
  
  public void setSpeedRange(float minSpeed, float maxSpeed) {
    this.minSpeed = minSpeed;
    this.maxSpeed = maxSpeed;
  }
  
  public Entity createEntity() {
    return new ParticleSystem(this);
  }
}

/*
 * A Particle class, which builds upon IntangibleObject for geometrical management.
 */

class Particle extends IntangibleObject {
  private float radius, diameter, initialTime, lifeTime, strokeWeight;
  private boolean markedForDestruction, fading;
  private color fill, stroke;
  
  public Particle(ParticleDef particleDef) {
    super(particleDef);
    
    initialTime = seconds();
    radius = particleDef.getRadius();
    diameter = particleDef.getDiameter();
    lifeTime = particleDef.getLifeTime();
    fill = particleDef.getFill();
    stroke = particleDef.getStroke();
    strokeWeight = particleDef.getStrokeWeight();
    fading = particleDef.isFading();
  }
  
  /*
   * These methods are getters and setters.
   */
  
  public float getLifeTime() {
    return lifeTime;
  }
  
  public void setLifeTime(float lifeTime) {
    this.lifeTime = lifeTime;
  }
  
  public boolean isFading() {
    return fading;
  }
  
  public void setFading(boolean fading) {
    this.fading = fading;
  }
  
  public float getRadius() {
    return radius;
  }
  
  public void setRadius(float radius) {
    this.radius = radius;
    this.diameter = radius * 2;
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  public void setDiameter(float diameter) {
    this.radius = diameter / 2f;
    this.diameter = diameter;
  }
  
  public boolean isMarkedForDestruction() {
    return markedForDestruction;
  }

  public void markForDestruction() {
    markedForDestruction = true;
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
  
  /*
   * A method that updates the particle.  
   */
  
  public void update() {
    super.update();

    if (seconds() - initialTime > lifeTime)
      markForDestruction();
    
    if (fading && !markedForDestruction) {
      fill = color(red(fill), green(fill), blue(fill), 255 * (lifeTime - (seconds() - initialTime)) / lifeTime);
      stroke = color(red(stroke), green(stroke), blue(stroke), 255 * (lifeTime - (seconds() - initialTime)) / lifeTime);
    }
  }
  
  /*
   * A method that applies the styles of the particle.  
   */
  
  public void applyStyles() {
    fill(fill);
    stroke(stroke);
    strokeWeight(strokeWeight);
  }
  
  /*
   * A method that displays the particle.  
   */
  
  public void display(Vec2 origin) {
    Vec2 location = getLocation().add(origin);
    pushStyle();
    applyStyles();
    ellipse(location.x, location.y, diameter, diameter);
    popStyle();
  }
}

class ParticleDef extends IntangibleObjectDef {
  private float radius, diameter, lifeTime, strokeWeight;
  private boolean markedForDestruction, fading;
  private color fill, stroke;
  
  public float getLifeTime() {
    return lifeTime;
  }
  
  public void setLifeTime(float lifeTime) {
    this.lifeTime = lifeTime;
  }
  
  public boolean isFading() {
    return fading;
  }
  
  public void setFading(boolean fading) {
    this.fading = fading;
  }
  
  public float getRadius() {
    return radius;
  }
  
  public void setRadius(float radius) {
    this.radius = radius;
    this.diameter = radius * 2;
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  public void setDiameter(float diameter) {
    this.diameter = diameter;
  }
  
  public boolean isMarkedForDestruction() {
    return markedForDestruction;
  }

  public void markForDestruction() {
    markedForDestruction = true;
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
  
  public Particle createParticle() {
    return new Particle(this);
  }
}
