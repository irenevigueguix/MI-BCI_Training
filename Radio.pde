
////////////////////
//
// This class creates and manages a button for use on the screen to trigger actions.
//
// Created: Irene Vigue Guix, May 2016.
// 
// Based on Processing's "Radio" example code
//
////////////////////

class Radio {

  int x, y;
  int size, dotSize;
  color baseGray, dotGray;
  boolean checked = false;
  int me;
  Radio[] others;

  Radio (int xp, int yp, int s, color b, color d, int m, Radio[] o) {
    x = xp;
    y = yp;
    size = s;
    dotSize = size - size/3;
    baseGray = b;
    dotGray = d;
    others = o;
    me = m;
  }

  boolean press (float mx, float my) {
    if (dist(x, y, mx, my)< size/2) {
      checked = true;
      for (int i=0; i< others.length; i++) {
        if (i!=me) {
          others[i].checked = false;
        }
      }
      return true;
    } else { 
      return false;
    }
  }
  void display() {
    noStroke();
    fill(baseGray);
    ellipse(x, y, size, size);
    if (checked == true) {
      fill(dotGray);
      ellipse(x, y, dotSize, dotSize);
    }
  }
}