class Interface {

  int previousLevel = 0; // level active when previously called
  int drawlvlupLifespan = 0; // lifespan of level up animation

  Interface() { // constructor
  // empty :)
  }

  void draw() { // draw UI
    drawLines(); // draw lines
    drawScore(); // draw score
    drawLevelup(); // draw level up notifications
  }

  void drawLines() { // draws lines
    stroke(255); // set stroke color
    line(50, width-50, height-50, height-50); // draw line at bottom of screen
  }

  void drawScore() { // draw score
    fill(255); // set fill
    textAlign(LEFT); // align text to left
    textSize(25); // set textsize
    text(score, 60, height-20); // draw text for score
    textSize(15); // set textsize
    textAlign(RIGHT); // align text to right

    String shieldStatus = "LIVES: "; // start of shield string

    for (int i = 0; i<lives; i++) { // execute once for every live available
      shieldStatus += "|"; // add | for every live
    }

    text(shieldStatus, width-60, height-20); // draw text for lives
  }

  void drawLevelup() { // draws level up notifications
    
    String levelupText; // init string for level up text
    
    if(level == bossLevel) { // if level is bosslevel
      levelupText = "GET READY"; // add 'GET READY' text instead of level number
    }else{ // if not boss level
      levelupText = str(level); // add level number
    }
    
    if (drawlvlupLifespan > 0) { // if leveluplifespan is higher than zero
      textAlign(CENTER, CENTER); // align text to center, both x and y axis
      textSize(drawlvlupLifespan + 15); // set textsize, increases as lifespan increases
      fill(255, 255-drawlvlupLifespan); // set fill. opacity decreases as lifespan increases
      text(levelupText, width/2, height/2); // draw text
      drawlvlupLifespan += 5; // add 5 to lifespan
      if (drawlvlupLifespan > 254) drawlvlupLifespan = 0; // if lifespan has reached 255, reset to zero
    } else { // if not currently drawing level up notifictation
      if (previousLevel != level) { // check if level has changed
        drawlvlupLifespan = 1; // set lifespan to one
        previousLevel = level; // reset previouslevel
      }
    }
  }
}
