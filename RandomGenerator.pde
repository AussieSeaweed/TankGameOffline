/*
 * A RandomGenerator class that generates random numbers.
 * The purpose of this class is so that I can create distinct perlin noise pseudo random numbers using offsets.
 */

class RandomGenerator {
  float noiseOffset;
  
  public RandomGenerator() {
    noiseOffset = random(1000000f);
  }
  
  public float getNoise(float arg) {
    return noise(arg + noiseOffset);
  }
}
