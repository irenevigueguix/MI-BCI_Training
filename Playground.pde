//////////////////////////////////////////////////////////////////////////
//
//		Playground Class
//		Created: 11/22/14 by Conor Russomanno
//                Edited: 05/04/16 by Irene Vigue Guix
//		An extra interface pane for additional GUI features
//
//////////////////////////////////////////////////////////////////////////


class Playground {

  //button for opening and closing
  float x, y, w, h;
  color boxBG;
  color strokeColor;
  color green;
  color red;
  color softgray;
  color darkgray;
  PFont myFont;

  float topMargin, bottomMargin;
  float expandLimit = width/2.5;
  boolean isOpen;
  boolean collapsing;

  // MI and ME Stuff
  int count = 1;
  int heart = 0;
  int TrailWindowWidth;
  int TrailWindowHeight; 
  int TrailWindowX;
  int TrailWindowY;
  color eggshell;
  int[] TrialY;      // HOLDS TRIAL DATA (holded pulse wave data)
  boolean OBCI_inited= false;

  OpenBCI_ADS1299 OBCI;

  // Button's stuff
  Button collapser;
  Button StartTrial;
  Button StopTrial;
  Button Trials;
  Button RestState;
  boolean StartTrialButtonPressed = false;
  boolean StopTrialButtonPressed = false;
  boolean TrialsButtonPressed = false;
  boolean RestStateButtonPressed = false;
  public String but_txt;
  boolean sendf = false;
  boolean sendg = false;
  boolean sendk = false;
  boolean sendl = false;

  boolean TestRunning = false;
  int startingTime;
  int seconds;
  int minutes;
  int onlysecs;

  // Trail stuff  
  int ThisTime;
  int bonusTime = 0;
  StringList task;
  PImage rightfinger;
  PImage leftfinger;

  //Send serial char
  char serialchar_f;
  char serialchar_g;
  char serialchar_k;
  char serialchar_l;

  // Margins
  Playground(int _topMargin) {

    topMargin = _topMargin;
    bottomMargin = helpWidget.h;

    isOpen = false;
    collapsing = true;

    boxBG = bgColor;
    strokeColor = color(138, 146, 153);
    collapser = new Button(0, 0, 20, 60, "<", 14);
    StartTrial = new Button(int(x+300), int(y+50), 60, 40, "Start", 12);
    StopTrial = new Button(int(x+370), int(y+50), 60, 40, "Stop", 12);
    Trials = new Button(int(x+300), int(y+100), 60, 40, "Trials", 12);
    RestState = new Button(int(x+370), int(y+100), 60, 40, "Rest State", 12);
    green = color(115, 220, 120);
    red = color(230, 120, 140);
    softgray =  color(240, 240, 240);
    darkgray = color(200, 200, 200);

    StartTrial.setColorPressed(darkgray);
    StartTrial.setColorNotPressed(green);
    StopTrial.setColorPressed(darkgray);
    StopTrial.setColorNotPressed(red);
    Trials.setColorPressed(darkgray);
    Trials.setColorNotPressed(softgray);
    RestState.setColorPressed(darkgray);
    RestState.setColorNotPressed(softgray);

    task = new StringList();
    task.append("Move Right Finger"); //(0)
    task.append("Move Left Finger"); //(1)
    task.append("Imagine moving Right Finger"); //(2)
    task.append("Imagine moving Left Finger"); //(3)

    rightfinger = loadImage("Finger_R.jpg");
    leftfinger = loadImage("Finger_L.jpg");

    serialchar_f = 'f';
    serialchar_g = 'g';
    serialchar_k = 'k';
    serialchar_l = 'l';

    keyPressed = false;

    x = width;
    y = topMargin;
    w = 0;
    h = (height - (topMargin+bottomMargin))/2;

    // Trail Stuff
    eggshell = color(255);
    TrailWindowWidth = 440;
    TrailWindowHeight = 183;
    TrailWindowX = int(x)+5;
    TrailWindowY = int(y)-10+int(h)/2;
    TrialY = new int[TrailWindowWidth];
  }

  public void initPlayground(OpenBCI_ADS1299 _OBCI) {
    OBCI = _OBCI;
    OBCI_inited = true;
  }

  public void update() {
    // verbosePrint("uh huh");
    if (collapsing) {
      collapse();
    } else {
      expand();
    }

    if (x > width) {
      x = width;
    }
  }  

  public void draw() {
    // verbosePrint("yeaaa");
    if (OBCI_inited) {

      pushStyle();
      fill(boxBG);
      stroke(strokeColor);
      rect(width - w, topMargin, w, h);

      textFont(f4, 24);
      textAlign(LEFT, TOP);
      fill(eggshell);
      text("Motor Imagery vs Motor Execution", x + 10, y + 10);
      textFont(f4, 50);

      //TRAIL WINDOW
      fill(eggshell);  // pulse window background
      stroke(eggshell);
      rect(TrailWindowX, TrailWindowY, TrailWindowWidth, TrailWindowHeight);

      //TRIAL STUFF
      ThisTime = (millis() - startingTime)+ bonusTime;

      if (TestRunning) {            
        // Move Right Hand

        seconds = ThisTime / 1000;
        minutes = seconds / 60;
        fill(255);
        onlysecs = seconds - 60*minutes;

        if (onlysecs < 10) {
          text("Time " + " " + ((minutes) + ":" + "0" + (onlysecs)), x+10, y+40);
        } else {
          text("Time " + " " + ((minutes) + ":" + (onlysecs)), x+10, y+40);
        }

        if ((TrialsButtonPressed) && (!RestStateButtonPressed)) {

          if (count < 10) {
            text("Trial" + " " + "0" + (count) + "/" + "20", x+10, y+100);
          } else {
            text("Trial" + " " + (count) + "/" + "20", x+10, y+100);
          }

          //if ((TrialsButtonPressed) && (!RestStateButtonPressed)) {
          if (ThisTime < 1000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(green);
            text("READY", TrailWindowX+140, TrailWindowY+70);
          }

          if (ThisTime > 1000 && ThisTime < 2000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("3", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 2000 && ThisTime < 3000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("2", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 3000 && ThisTime < 4000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("1", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 4000 && ThisTime < 8000) {
            textFont(f4, 24);
            textAlign(LEFT, TOP);
            fill(0);
            String item = task.get(0);
            text(item, TrailWindowX+120, TrailWindowY+80);
            if (sendf) {
              openBCI.sendChar('f');
              sendf = false;
            }
          }

          if (ThisTime > 8000 && ThisTime < 10000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(darkgray);
            text("REST", TrailWindowX+150, TrailWindowY+70);
          } 

          // Move Left Finger

          if (ThisTime > 10000 && ThisTime < 11000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(green);
            text("READY", TrailWindowX+140, TrailWindowY+70);
          }

          if (ThisTime > 11000 && ThisTime < 12000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("3", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 12000 && ThisTime < 13000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("2", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 13000 && ThisTime < 14000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("1", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 14000 && ThisTime < 18000) {
            textFont(f4, 24);
            textAlign(LEFT, TOP);
            fill(0);
            String item = task.get(1);
            text(item, TrailWindowX+120, TrailWindowY+80);
            if (sendg) {
              openBCI.sendChar('g');
              sendg = false;
            }
          }

          if (ThisTime > 18000 && ThisTime < 20000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(darkgray);
            text("REST", TrailWindowX+150, TrailWindowY+70);
          } 

          // Imagine moving Right Finger

          if (ThisTime > 20000 && ThisTime < 21000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(green);
            text("READY", TrailWindowX+140, TrailWindowY+70);
          }

          if (ThisTime > 21000 && ThisTime < 22000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("3", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 22000 && ThisTime < 23000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("2", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 23000 && ThisTime < 24000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("1", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 24000 && ThisTime < 28000) {
            textFont(f4, 20);
            textAlign(LEFT, TOP);
            fill(0);
            String item = task.get(2);
            text(item, TrailWindowX+20, TrailWindowY+80);
            image(rightfinger, TrailWindowX+310, TrailWindowY+10);
            if (sendk) {
              openBCI.sendChar('k');
              sendk = false;
            }
          }

          if (ThisTime > 28000 && ThisTime < 30000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(darkgray);
            text("REST", TrailWindowX+150, TrailWindowY+70);
          } 

          // Imagine moving Left Finger

          if (ThisTime > 30000 && ThisTime < 31000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(green);
            text("READY", TrailWindowX+140, TrailWindowY+70);
          }

          if (ThisTime > 31000 && ThisTime < 32000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("3", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 32000 && ThisTime < 33000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("2", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 33000 && ThisTime < 34000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("1", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 34000 && ThisTime < 38000) {
            textFont(f4, 20);
            textAlign(LEFT, TOP);
            fill(0);
            String item = task.get(3);
            text(item, TrailWindowX+150, TrailWindowY+80);
            image(leftfinger, TrailWindowX+10, TrailWindowY+10);
            if (sendl) {
              openBCI.sendChar('l');
              sendl = false;
            }
          }

          if (ThisTime > 38000 && ThisTime < 40000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(darkgray);
            text("REST", TrailWindowX+150, TrailWindowY+70);
          } 

          if (ThisTime > 40000) {
            count ++;
            bonusTime = 0;

            if (count < 20) {
              startingTime = millis();
              sendf = true;
              sendg = true;
              sendk = true;
              sendl = true;

              println("Back to beginning...");
            } else {
              TestRunning = false;
              println("Final trial finished...");
            }
          }
        } else {
          if ((!TrialsButtonPressed) && (RestStateButtonPressed)) {
            if (ThisTime < 800000) {
              textFont(f4, 50);
              textAlign(LEFT, TOP);
              fill(darkgray);
              text("REST STATE", TrailWindowX+70, TrailWindowY+70);
            }
          }
        }
      }

      fill(255, 0, 0);
      collapser.draw(int(x - collapser.but_dx), int(topMargin + (h-collapser.but_dy)/2));

      fill(255, 0, 0);
      StartTrial.draw(int(x+300), int(y+50));

      fill(255, 0, 0);
      StopTrial.draw(int(x+370), int(y+50));

      fill(255, 0, 0);
      Trials.draw(int(x+300), int(y+100));

      fill(255, 0, 0);
      RestState.draw(int(x+370), int(y+100));

      popStyle();
    }
  }


  boolean isMouseHere() {
    if (mouseX >= x && mouseX <= width && mouseY >= y && mouseY <= height - bottomMargin) {
      return true;
    } else {
      return false;
    }
  }

  boolean isMouseInButton() {
    verbosePrint("Playground: isMouseInButton: attempting");
    if (mouseX >= collapser.but_x && mouseX <= collapser.but_x+collapser.but_dx && mouseY >= collapser.but_y && mouseY <= collapser.but_y + collapser.but_dy) {
      return true;
    } else {
      return false;
    }
  }

  public void toggleWindow() {
    if (isOpen) {//if open
      verbosePrint("close");
      collapsing = true;//collapsing = true;
      isOpen = false;
      collapser.but_txt = "<";
    } else {//if closed
      verbosePrint("open");
      collapsing = false;//expanding = true;
      isOpen = true;
      collapser.but_txt = ">";
    }
  }

  void keyPressed() {
  }

  public void mousePressed() {
    verbosePrint("Playground >> mousePressed()");

    if (StartTrial.isMouseHere()) {
      if (((TrialsButtonPressed) && (!RestStateButtonPressed)) || ((!TrialsButtonPressed) && (RestStateButtonPressed))) {
        StartTrial.setIsActive(true);
        StartTrialButtonPressed = true;
        StopTrial.setIsActive(false);
        if (!TestRunning) {
          TestRunning = true;
          startingTime = millis();
        }
      }
    }

    if (StopTrial.isMouseHere()) {
      if (((TrialsButtonPressed) && (!RestStateButtonPressed)) || ((!TrialsButtonPressed) && (RestStateButtonPressed))) {
        StopTrial.setIsActive(true);
        StopTrialButtonPressed = true;
        StartTrial.setIsActive(false);
        if (TestRunning) {
          TestRunning = false;
          startingTime = millis();
        }
      }
    }

    if (Trials.isMouseHere()) {
      Trials.setIsActive(true);
      TrialsButtonPressed = true;
      RestState.setIsActive(false);
      RestStateButtonPressed = false;
      sendf = true;
      sendg = true;
      sendk = true;
      sendl = true;
    }

    if (RestState.isMouseHere()) {
      RestState.setIsActive(true);
      RestStateButtonPressed = true;
      Trials.setIsActive(false);
      TrialsButtonPressed = false;
    }

    //buttons[0].press(mouseX,mouseY);
    //buttons[1].press(mouseX,mouseY);
  }

  public void mouseReleased() {
    verbosePrint("Playground >> mouseReleased()");
  }

  public void expand() {
    if (w <= expandLimit) {
      w = w + 50;
      x = width - w;
      TrailWindowX = int(x)+5;
    }
  }

  public void collapse() {
    if (w >= 0) {
      w = w - 50;
      x = width - w;
      TrailWindowX = int(x)+5;
    }
  }

  public void plus1000() {
    println("+1 sec");
    println("ThisTime: " + ThisTime);
    bonusTime += 1000;
  }
};