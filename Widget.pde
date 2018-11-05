/*
 * Widgets include: buttons and labels.
 * A Widget class provides a template for widget specializations to follow.
 */

abstract class Widget {
  protected Vec2 location;
  protected boolean active;
  protected boolean disabled;
  protected color fill, stroke, disabledFill, activeFill;
  protected float strokeWeight;
  
  public Widget(WidgetDef widgetDef) {
    location = widgetDef.getLocation();
    active = widgetDef.isActive();
    disabled = widgetDef.isDisabled();
    fill = widgetDef.getFill();
    stroke = widgetDef.getStroke();
    strokeWeight = widgetDef.getStrokeWeight();
    disabledFill = widgetDef.getDisabledFill();
    activeFill = widgetDef.getActiveFill();
  }
  
  /*
   * These methods are getters and setters. 
   */
  
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
  
  /*
   * A method that determines whether if the given coordinates are on the widget and returns the result.s
   */
  
  public abstract boolean contains(float targetX, float targetY);
  
  /*
   * A method that displays the widget.
   */
  
  abstract public void display();
  
  /*
   * A method that calls an action of the widget. 
   */
  
  abstract public void action();
}

/*
 * Widget specializations.
 */
 
class Label extends Widget {
  private String text;
  
  public Label(LabelDef labelDef) {
    super(labelDef);
    
    text = labelDef.getText();
  }
  
  public String getText() {
    return text;
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public void display() {
    pushStyle();
    if (disabled) {
      fill(disabledFill);
    } else if (contains(mouseX, mouseY) || active) {
      fill(activeFill);
    } else {
      fill(fill);
    }
    textSize(strokeWeight);
    text(text, location.x, location.y);
    popStyle();
  }
  
  public boolean contains(float targetX, float targetY) {
    return false;
  }
  
  public void action() {}
}

class ScoreBoard extends Widget {
  private int score;
  private String prefix;
  
  public ScoreBoard(ScoreBoardDef scoreBoardDef) {
    super(scoreBoardDef);
    
    score = scoreBoardDef.getScore();
    prefix = scoreBoardDef.getPrefix();
  }
  
  public String getText() {
    return prefix + score;
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
  
  public void display() {
    pushStyle();
    if (disabled) {
      fill(disabledFill);
    } else if (contains(mouseX, mouseY) || active) {
      fill(activeFill);
    } else {
      fill(fill);
    }
    textSize(strokeWeight);
    text(getText(), location.x, location.y);
    popStyle();
  }
  
  public boolean contains(float targetX, float targetY) {
    return false;
  }
  
  public void action() {}
}

class Button extends Widget {
  private String text;
  private Event event;
  private color textColor;
  private float fontSize, width, height;
  
  public Button(ButtonDef buttonDef) {
    super(buttonDef);
    
    width = buttonDef.getWidth();
    height = buttonDef.getHeight();
    text = buttonDef.getText();
    textColor = buttonDef.getTextColor();
    fontSize = buttonDef.getFontSize();
    event = buttonDef.getEvent();
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
  
  public void display() {
    pushStyle();
    if (disabled) {
      fill(disabledFill);
    } else if (contains(mouseX, mouseY) || active) {
      fill(activeFill);
    } else {
      fill(fill);
    }
    stroke(stroke);
    strokeWeight(strokeWeight);
    rect(location.x, location.y, width, height);
    
    fill(textColor);
    textSize(fontSize);
    text(text, location.x, location.y);
    popStyle();
  }
  
  public void action() {
    event.call();
  }
  
  public boolean contains(float targetX, float targetY) {
    return location.x - 0.5 * width <= targetX && targetX <= location.x + 0.5 * width && 
            location.y - 0.5 * height <= targetY && targetY <= location.y + 0.5 * height;
  }
}
