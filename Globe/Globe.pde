float angleX;
float angleY;
float angleXSpeed;
float angleYSpeed;

Table latLonTable;
Table temperatureTable;

final String latLonTableSrc = "D:\\Downloads\\archive\\countries.csv";
final String temperatureTableSrc = "D:\\Downloads\\archive\\GlobalLandTemperaturesByCountry.csv";

// radius of the globel
float r = 200;

PImage earth;
PShape globe;

HashMap<String, Float[]> countriesLatLon;

// current year we are viewing
int YEAR = 2009;

Camera3D camera;

PFont font;

void setup() {
  size(600, 600, P3D);
  camera = new Camera3D();
  // retrieve the earth image
  earth = loadImage("earth.jpg");
  temperatureTable = loadTable(temperatureTableSrc, "header");
  latLonTable = loadTable(latLonTableSrc, "header");
  
  // create the counties lat lon hashmap
  countriesLatLon = new HashMap<String, Float[]>();
  
  for ( TableRow row : latLonTable.rows()) { 
    Float[] latLon = new Float[2];
    // retrieve lat
    latLon[0] = row.getFloat("latitude");
    latLon[1] = row.getFloat("longitude");
    
    countriesLatLon.put(row.getString("name"), latLon);
  }
  
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  
  angleX = 0;
  angleY = 0;
  angleXSpeed = 0;
  angleYSpeed = 0;
  font = createFont("Arial", 12);
}

void draw() {
  background(51);
  camera.update();
  translate(width*0.5, height*0.5);
  rotateX(angleX);
  rotateY(angleY);

  lights();
  fill(200);
  noStroke();
  //sphere(r);
  shape(globe);

  for (TableRow row : temperatureTable.rows()) {
    // check the year of the row
    if ( !Integer.toString(YEAR).equals(row.getString("dt").substring(0,4)) )
      continue;
      
    // check if a temperature was recorded
    if(row.getString("AverageTemperature").equals(""))
      continue;
    // retrieve the lat and lon of the current country 
    Float[] latLon = countriesLatLon.get(row.getString("Country"));
    
    // check if the country exist in the lat lon table
    if (latLon == null || latLon[0] == null || latLon[1] == null)
      continue;
    
    // retrieve the map of the average temperature 
    float mag = row.getFloat("AverageTemperature");
    
    // retrieve the angle of the lat and lon 
    float theta = radians(latLon[0]);
    float phi = radians(latLon[1]) + PI;

    // retrieve the three components 
    float x = r * cos(theta) * cos(phi);
    float y = -r * sin(theta);
    float z = -r * cos(theta) * sin(phi);

    PVector pos = new PVector(x, y, z);

    // Height and axis of the object
    float h = 20;
    PVector xaxis = new PVector(1, 0, 0);
    float angleb = PVector.angleBetween(xaxis, pos);
    PVector raxis = xaxis.cross(pos);
  
    // draw the entry on the map
    pushMatrix();
    translate(x, y, z);
    rotate(angleb, raxis.x, raxis.y, raxis.z);
    fill(getTemperatureColor(mag));
    box(h, 5, 5);
    popMatrix();
  }
  
  // dampen the angle speed
  angleXSpeed *= 0.99;
  angleYSpeed *= 0.99;
  
  if (keyCode == UP)
    angleXSpeed += 0.015;
  else if (keyCode == DOWN)
    angleXSpeed -= 0.015;
  else if (keyCode == LEFT)
     angleYSpeed -= 0.015;
  else if (keyCode == RIGHT)
    angleYSpeed += 0.015;
   
  angleX += angleXSpeed;
  angleY += angleYSpeed;
  
  
  // clear the key code used
  keyCode = -1;
  
  displayHUD();
  
  // display year
  textFont(font);
  translate(0, 0);
  pushMatrix();
  text(YEAR, 0, 0, -100);
  popMatrix();
}

void displayHUD() { 
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  
  // DISPLAY THE HUD
  
  hint(ENABLE_DEPTH_TEST);
}

/**
*  Increaments/decreaments the year when the 
*  mouse wheel is used.
*/
void mouseWheel(MouseEvent event) {
  float direction = event.getCount();
  
  if(direction == -1)
    YEAR++;
  else
    YEAR--;
}

/**
*  Returns the mapped color for the corresponding temperature
*/
color getTemperatureColor(float temp) {
    if(temp <= 2) {
      if(temp >= -38 && temp <= -34) 
       return #2359FA;
      else if(temp > -34 && temp <= -29)
        return #2F54EC;
      else if(temp > -29 && temp <= -26)
        return #3B4FDE;
      else if(temp > -26 && temp <= -22)
        return #484AD0;
      else if(temp > -22 && temp <= -18)
        return #5445C2;
      else if(temp > -18 && temp <= -14)
        return #6040B5;
      else if(temp > -14 && temp <= -10)
        return #6C3BA7;
      else if(temp > -10 && temp <= -6)
        return #793699;
      else if(temp > -6 && temp <= -2)
        return #85318B;
      else if(temp > -2 && temp <= 2)
        return #912D7D;
    }
    else if(temp > 2) {
       if(temp > 2 && temp <= 6)
        return #9D286F;
      else if(temp > 6 && temp <= 10)
        return #A92361;
      else if(temp > 10 && temp <= 14)
        return #B61E53;
      else if(temp > 14 && temp <= 18)
        return #C21945;  
      else if(temp > 18 && temp <= 22)
        return #CE1438; 
      else if(temp > 22 && temp <= 26)
        return #DA0F2A;
      else if(temp > 26 && temp <= 30)
        return #E70A1C;
      else if(temp > 30 && temp <= 34)
        return #F3050E;
      else if(temp > 34 && temp <= 39)
        return #FF0000; 
    }
    return 0;
}
