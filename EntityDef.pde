/*
 * A definition class of the Entity class.
 */

abstract class EntityDef {
  private Environment env;
  
  public Environment getEnvironment() {
    return env;
  }
  
  public void setEnvironment(Environment env) {
    this.env = env;
  }
  
  public abstract Entity createEntity();
}
