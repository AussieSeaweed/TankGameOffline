class EnvironmentDef {
  private Game game;
  private int numEnemies, highScore;
  private boolean spawningEnemies;
  private color killScreenColor, transitionColor;
  private float killScreenLoadingTime, killScreenOpacity, transitionTime;
  private CameraDef cameraDef;
  private LinkedList<WidgetDef> widgetDefList;
  private ScoreBoardDef scoreBoardDef;
  
  public EnvironmentDef() {
    widgetDefList = new LinkedList<WidgetDef>();
  }
  
  public ScoreBoard createScoreBoard() {
    return new ScoreBoard(scoreBoardDef);
  }
  
  public void setScoreBoardDef(ScoreBoardDef scoreBoardDef) {
    this.scoreBoardDef = scoreBoardDef;
  }
  
  public float getTransitionTime() {
    return transitionTime;
  }
  
  public void setTransitionTime(float transitionTime) {
    this.transitionTime = transitionTime;
  }
  
  public int getHighScore() {
    return highScore;
  }
  
  public void setHighScore(int highScore) {
    this.highScore = highScore;
  }
  
  public color getTransitionColor() {
    return transitionColor;
  }
  
  public void setTransitionColor(color transitionColor) {
    this.transitionColor = transitionColor;
  }
  
  public float getKillScreenOpacity() {
    return killScreenOpacity;
  }
  
  public void setKillScreenOpacity(float killScreenOpacity) {
    this.killScreenOpacity = killScreenOpacity;
  }
  
  public Game getGame() {
    return game;
  }
  
  public void setGame(Game game) {
    this.game = game;
  }
  
  public int getNumEnemies() {
    return numEnemies;
  }
  
  public void setNumEnemies(int numEnemies) {
    this.numEnemies = numEnemies;
  }
  
  public boolean isSpawningEnemies() {
    return spawningEnemies;
  }
  
  public void setSpawningEnemies(boolean spawningEnemies) {
    this.spawningEnemies = spawningEnemies;
  }
  
  public CameraDef getCameraDef() {
    return cameraDef;    
  }
  
  public void setCameraDef(CameraDef cameraDef) {
    this.cameraDef = cameraDef;
  }
  
  public color getKillScreenColor() {
    return killScreenColor;
  }
  
  public void setKillScreenColor(color killScreenColor) {
    this.killScreenColor = killScreenColor;
  }
  
  public float getKillScreenLoadingTime() {
    return killScreenLoadingTime;
  }
  
  public void setKillScreenLoadingTime(float killScreenLoadingTime) {
    this.killScreenLoadingTime = killScreenLoadingTime;
  }
  
  public void addWidgetDef(WidgetDef widgetDef) {
    widgetDefList.add(widgetDef);
  }
  
  public LinkedList<Widget> createWidgetList() {
    LinkedList<Widget> widgetList = new LinkedList<Widget>();
    for (WidgetDef widgetDef : widgetDefList) {
      widgetList.add(widgetDef.createWidget());
    }
    return widgetList;
  }
  
  public void setWidgetDefList(LinkedList<WidgetDef> widgetDefList) {
    this.widgetDefList = widgetDefList;
  }
}
