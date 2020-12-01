/**
* 3D camera controls that lets you zoom in/out and move
* around the canvas.
* 
* Controls:
* E - move up
* Q - move down
* W - move forward
* S - move back
* A - move left
* D - move right
*
* @Author: Elvin Torres
*/
class Camera3D {
  float scale = 1;
  float xPan = -700;
  float yPan = -480;
  float zPan = 0;


  void update() {
    checkControls();
    //update screen
    translate(width/2, height/2, 0);
    scale(scale);
    translate(xPan, yPan, zPan);
  }

  void checkControls() {
    if (keyPressed) {
      if (key == 'w')
        zPan += 10;
      else if (key == 's')
        zPan -= 10;
      else if (key == 'a')
         xPan += 10;
      else if (key == 'd')
        xPan -= 10;
      else if (key == 'e')
        yPan += 10;
      else if (key == 'q')
        yPan -= 10;
    }
  }
}
