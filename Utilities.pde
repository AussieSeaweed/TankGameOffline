/*
 * Implementations of functions that can be used handily.
 */

/*
 * functions that return the sign of a scalar.
 */

float sign(float scalar) {
  return scalar < 0 ? -1f : 1f;
}

int sign(int scalar) {
  return scalar < 0 ? -1 : 1;
}

/*
 * functions that scales a scalar or a vector based on framerate.   
 */

float perSecond() {
  return 1 / frameRate;
}

float perSecond(float scalar) {
  return scalar / frameRate;
}

Vec2 perSecond(Vec2 vector) {
  return vector.mul(perSecond(1f));
}

float perSecondSquared(float scalar) {
  return scalar / frameRate / frameRate;
}

/*
 * A function that rotates a vector by an angle.   
 */

Vec2 rotate(Vec2 vector, float angle) {
  float x = vector.x * cos(angle) - vector.y * sin(angle);
  float y = vector.x * sin(angle) + vector.y * cos(angle);
  return new Vec2(x, y);
}

/*
 * A function that limits a magnitude of a vector.   
 */

void limit(Vec2 vector, float magnitude) {
  if (vector.length() > magnitude)
    vector.mulLocal(magnitude / vector.length());
}

/*
 * A function that determines the angle of a vector.   
 */

float getAngleOf(Vec2 vector) {
  return atan2(vector.y, vector.x);
}

/*
 * A function that returns a unit vector pointing at specified direction.   
 */

Vec2 getUnitVectorOf(float angle) {
  return rotate(new Vec2(1, 0), angle);
}

/*
 * A function that returns a unit vector pointing towards a random direction.   
 */

Vec2 getRandomUnitVector() {
  return getUnitVectorOf(random(0, TAU));
}

/*
 * A function that determines the angle between two vectors.   
 */

float getAngleBetween(Vec2 v1, Vec2 v2) {
  return acos(Vec2.dot(v1, v2) / (v1.length() * v2.length()));
}

/*
 * A function that gets the distance between two vectors.   
 */

float getDistanceBetween(Vec2 v1, Vec2 v2) {
  float dx = v1.x - v2.x;
  float dy = v1.y - v2.y;
  return sqrt(dx * dx + dy * dy);
}

/*
 * A function that returns the number of seconds passed since the beginning of the program.   
 */

float seconds() {
  return millis() / 1000f;
}

/*
 * A function that returns a copy of a vector.   
 */

Vec2 getVectorCopy(Vec2 vector) {
  return new Vec2(vector.x, vector.y);
}

/*
 * A function that returns the color with supplied alpha value.   
 */

color setAlpha(color c, float alpha) {
  return color(red(c), green(c), blue(c), alpha);  
}
