/*
 * A game class which handles everything about the game.
 */

class Game {
  private Tank_Game_Offline sketch;
  private GUI guiStatus;
  private Environment env;
  private LinkedList<Widget> widgets;
  private Widget selectedWidget;
  private boolean transitioning;
  private float transitionBeginTime, transitionTime;
  private color transitionColor;
  private GUI transitionTo;
  private int highScore;
  private Minim minim;
  
  public Game(Tank_Game_Offline sketch) {
    this.sketch = sketch;
    minim = new Minim(sketch);
    transitionTime = 1f;
    transitionColor = color(255);
    changeGuiStatusTo(GUI.MAINMENU);
    
    File file = new File(sketchPath("settings.cfg"));
    
    if (file.exists()) {
      highScore = Integer.parseInt(loadStrings("settings.cfg")[0]); // Loading the previous high score
    } else {
      String[] buffer = {"0"};
      saveStrings("settings.cfg", buffer);
    }
  }
  
  /*
   * A method that sets teh high score of the game and stores it into a file. 
   */
  
  public void setHighScore(Integer highScore) {
    this.highScore = highScore;
    String[] buffer = {highScore.toString()};
    saveStrings("settings.cfg", buffer);
  }
  
  /*
   * These methods are getters and setters.
   */
  
  public Minim getMinim() {
    return minim;
  }
  
  public float getTransitionTime() {
    return transitionTime;
  }
  
  public void setTransitionTime(float transitionTime) {
    this.transitionTime = transitionTime;
  }
  
  public color getTransitionColor() {
    return transitionColor;
  }
  
  public void setTransitionColor(color transitionColor) {
    this.transitionColor = transitionColor;
  }
  
  public Tank_Game_Offline getSketch() {
    return sketch;
  }
  
  /*
   * A method that updates the game, such as updating the environment, main menu, etc. 
   */
  
  public void update() {
    if (transitioning) {
      if (seconds() - transitionBeginTime > transitionTime / 2f && guiStatus != transitionTo) {
        changeGuiStatusFrom();
        changeGuiStatusTo(transitionTo);
      }
      
      float alpha = seconds() - transitionBeginTime <= transitionTime / 2f ?
                  255 * (seconds() - transitionBeginTime) / (transitionTime / 2f) :
                  255 * (transitionTime / 2f - (seconds() - transitionBeginTime - transitionTime / 2f)) / (transitionTime / 2f);

      transitionColor = setAlpha(transitionColor, alpha);
    } else {
      switch (guiStatus) {
        case MAINMENU: {
          
        }
          break;
        case INGAME: {
          env.update();
        }
          break;
      }
    }
    
    if (transitioning && seconds() - transitionBeginTime > transitionTime) {
      transitioning = false;
    }
  }
  
  /*
   * A method that displays the game. 
   */
  
  public void display() {
    switch (guiStatus) {
      case MAINMENU: {
        background(255);
      }
        break;
      case INGAME: {
        env.display();
      }
        break;
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
   * A method that sets the current GUI Status. The types of status are at the bottom of this file, at GUI enum. 
   */
  
  public void setGui(GUI transitionTo) {
    transitioning = true;
    transitionBeginTime = seconds();
    this.transitionTo = transitionTo;
  }
  
  /*
   * A method that modifies the current Game instance to change the Gui status into something else. 
   */
  
  private void changeGuiStatusTo(GUI guiStatus) {
    this.guiStatus = guiStatus;
    
    switch (guiStatus) {
      case MAINMENU: {
        widgets = new LinkedList<Widget>();
      
        LabelDef title = new LabelDef();
        title.setFill(color(0));
        title.setLocation(new Vec2(width / 2f, height / 4f));
        title.setStrokeWeight(height / 10f);
        title.setText("Tank Game Offline");
        
        ButtonDef playButton = new ButtonDef();
        playButton.setLocation(new Vec2(width / 2f, 5.5 * height / 10f));
        playButton.setActiveFill(color(150, 200));
        playButton.setEvent(new StartGameEvent(this));
        playButton.setFill(color(255, 200));
        playButton.setStroke(color(0));
        playButton.setStrokeWeight(3);
        playButton.setText("Play Game");
        playButton.setFontSize(height / 20f);
        playButton.setTextColor(color(0));
        playButton.setWidth(3 * width / 10f);
        playButton.setHeight(height / 10f);
        
        widgets.add(title.createWidget());
        widgets.add(playButton.createWidget());
      }
        break;
      case INGAME: {
        EnvironmentDef environmentDef = new EnvironmentDef();
        CameraDef cameraDef = new CameraDef();
        cameraDef.setBackgroundFill(color(255));
        cameraDef.setBackgroundStroke(color(0));
        cameraDef.setBackgroundStrokeWeight(3);
        cameraDef.setCellStep(100);
        cameraDef.setLinearVelocity(new Vec2());
        cameraDef.setAcceleration(new Vec2());
        cameraDef.setAngle(0);
        cameraDef.setAngularAcceleration(0);
        cameraDef.setAngularVelocity(0);
        cameraDef.setMass(1);
        cameraDef.setMaxDistanceToTarget(sqrt(width * width + height * height) / 2f);
        ScoreBoardDef scoreBoardDef = new ScoreBoardDef();
        scoreBoardDef.setFill(color(0));
        scoreBoardDef.setStrokeWeight(height / 20f);
        scoreBoardDef.setLocation(new Vec2(9f * width / 10f, 9f * height / 10f));
        scoreBoardDef.setPrefix("Score: ");
        environmentDef.setGame(this);
        environmentDef.setTransitionTime(transitionTime);
        environmentDef.setTransitionColor(transitionColor);
        environmentDef.setCameraDef(cameraDef);
        environmentDef.setScoreBoardDef(scoreBoardDef);
        environmentDef.setNumEnemies(5);
        environmentDef.setSpawningEnemies(true);
        environmentDef.setKillScreenColor(color(196, 36, 0));
        environmentDef.setKillScreenLoadingTime(0.5f);
        environmentDef.setKillScreenOpacity(200);
        environmentDef.setHighScore(highScore);
        env = new Environment(environmentDef);
        widgets = new LinkedList<Widget>();
      }
        break;
    }
  }
  
  /*
   * A method that destroys or handles accordingly when changing to another Gui Status. 
   */

  private void changeGuiStatusFrom() {
    switch (guiStatus) {
      case MAINMENU: {
        widgets = null;
      }
        break;
      case INGAME: {
        widgets = null;
        env.destroy();
        env = null;
      }
        break;
    }
  }
  
  /*
   * A method that tests if coordinates are within a widget. 
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
   * Methods that handle keyboard or mouse events. 
   */
  
  public void keyPressed() {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.keyPressed();
      }
        break;
    }
  }
  
  public void keyReleased() {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.keyReleased();
      }
        break;
    }
  }
  
  public void keyTyped() {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.keyTyped();
      }
        break;
    }
  }
  
  public void mousePressed() {
    switch (guiStatus) {
      case MAINMENU: {
        testWidgets(mouseX, mouseY, false);
      }
        break;
      case INGAME: {
        env.mousePressed();
      }
        break;
    }
  }
  
  public void mouseReleased() {
    switch (guiStatus) {
      case MAINMENU: {
        testWidgets(mouseX, mouseY, true);
      }
        break;
      case INGAME: {
        env.mouseReleased();
      }
        break;
    }
  }
  
  public void mouseClicked() {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.mouseClicked();
      }
        break;
    }
  }
  
  public void mouseDragged(MouseEvent event) {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.mouseDragged(event);
      }
        break;
    }
  }
  
  public void mouseWheel(MouseEvent event) {
    switch (guiStatus) {
      case MAINMENU: {
        
      }
        break;
      case INGAME: {
        env.mouseWheel(event);
      }
        break;
    }
  }
}

/*
 * An enum that stores the types of GUI statuses. 
 */
   
static enum GUI { MAINMENU, INGAME }
