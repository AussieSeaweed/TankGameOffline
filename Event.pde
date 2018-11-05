/*
 * Event classes can be passed into buttons as their action when they are clicked.
 */

abstract class Event {
  abstract void call();
}

class RestartEvent extends Event {
  Environment env;
  
  public RestartEvent(Environment env) {
    this.env = env;
  }
  
  void call() {
    env.restart();
  }
}

class GoToMainMenuEvent extends Event {
  Game game;
  
  public GoToMainMenuEvent(Game game) {
    this.game = game;
  }
  
  void call() {
    game.setGui(GUI.MAINMENU);
  }
}

class StartGameEvent extends Event {
  Game game;
  
  public StartGameEvent(Game game) {
    this.game = game;
  }
  
  void call() {
    game.setGui(GUI.INGAME);
  }
}
