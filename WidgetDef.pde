abstract class WidgetDef {
  private Vec2 location;
  private boolean active;
  private boolean disabled;
  private color fill, stroke, disabledFill, activeFill;
  private float strokeWeight;
  
  public Vec2 getLocation() {
    return location;
  }
  
  public void setLocation(Vec2 location) {
    this.location = location;
  }

  public boolean isActive() {
    return active;
  }
  
  public void setActive(boolean active) {
    this.active = active;
  }
  
  public boolean isDisabled() {
    return disabled;
  }
  
  public void setDisabled(boolean disabled) {
    this.disabled = disabled;
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
  
  public color getDisabledFill() {
    return disabledFill;
  }
  
  public void setDisabledFill(color disabledFill) {
    this.disabledFill = disabledFill;
  }
  
  public color getActiveFill() {
    return activeFill;
  }
  
  public void setActiveFill(color activeFill) {
    this.activeFill = activeFill;
  }
  
  public abstract Widget createWidget();
}

class LabelDef extends WidgetDef {
  private String text;
  
  public String getText() {
    return text;
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public Widget createWidget() {
    return new Label(this);
  }
}

class ScoreBoardDef extends WidgetDef {
  private int score;
  private String prefix;
  
  public String getText() {
    return score + prefix;
  }
  
  public String getPrefix() {
    return prefix;
  }
  
  public void setPrefix(String prefix) {
    this.prefix = prefix;
  }
  
  public int getScore() {
    return score;
  }
  
  public void setScore(int score) {
    this.score = score;
  }
  
  public Widget createWidget() {
    return new ScoreBoard(this);
  }
}

class ButtonDef extends WidgetDef {
  private String text;
  private Event event;
  private color textColor;
  private float fontSize, width, height;
  
  public String getText() {
    return text;
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public Event getEvent() {
    return event;
  }
  
  public void setEvent(Event event) {
    this.event = event;
  }
  
  public color getTextColor() {
    return textColor;
  }
  
  public void setTextColor(color textColor) {
    this.textColor = textColor;
  }
  
  public float getFontSize() {
    return fontSize;
  }
  
  public void setFontSize(float fontSize) {
    this.fontSize = fontSize;
  }
  
  public Widget createWidget() {
    return new Button(this);
  }
  
  public float getWidth() {
    return width;
  }
  
  public void setWidth(float width) {
    this.width = width;
  }
  
  public float getHeight() {
    return height;
  }
  
  public void setHeight(float height) {
    this.height = height;
  }
}
