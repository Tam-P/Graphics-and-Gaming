//CSCI 5611 - Graph Search & Planning
//PRM Sample Code [Proj 1]
//Instructor: Stephen J. Guy <sjguy@umn.edu>

//This is a test harness designed to help you test & debug your PRM.

//USAGE:
// On start-up your PRM will be tested on a random scene and the results printed
// Left clicking will set a red goal, right clicking the blue start
// The arrow keys will move the circular obstacle with the heavy outline
// Pressing 'r' will randomize the obstacles and re-run the tests

//Change the below parameters to change the scenario/roadmap size
PImage bg;
PImage cake;
PImage cake1;
PImage dedede;
int numObstacles = 20;
int numNodes  = 200;
KirbyAgent kirby;
WaddleAgent waddleDee;
Obstacles gordo;


  
//A list of circle obstacles
static int maxNumObstacles = 40; //change number of obstacles
Vec2 circlePos[] = new Vec2[maxNumObstacles]; //Circle positions
float circleRad[] = new float[maxNumObstacles];  //Circle radii
//Vec2 gordoPosition[] = new Vec2[maxNumObstacles]; //gordPos[]

Vec2 startPos = new Vec2(100,500);
Vec2 goalPos = new Vec2(500,200);
Vec2 w_startPos = new Vec2(500,100);
Vec2 w_goalPos = new Vec2(200,500);

static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];

//Generate non-colliding PRM nodes
void generateRandomNodes(int numNodes, Vec2[] circleCenters, float[] circleRadii){
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(random(width),random(height));
    boolean insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,2);
    //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    while (insideAnyCircle){
      randPos = new Vec2(random(width),random(height));
      insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,2);
      //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    }
    nodePos[i] = randPos;
  }
}

void placeRandomObstacles(int numObstacles){
  //king dee dee: 
  circleRad[0] = 100; //Make the first obstacle big
  circlePos[0] = new Vec2(random(50,950),random(50,700));
  //Initial obstacle position
  
  for (int i = 1; i < numObstacles-1; i++){
    Vec2 currPos = new Vec2(random(50,950),random(50,700)); 
    if (circlePos[i+1] == null) {
       circlePos[i] = currPos; }
     if (circlePos[i].distanceTo(circlePos[i-1]) > 2*circleRad[i]) {
       circlePos[i+1] = currPos;}
     //circlePos[i] = new Vec2(random(50,950),random(50,700));  
     //obstacle radius
     circleRad[i] = 102.5;
  }
  

}

ArrayList<Integer> curPath;
ArrayList<Integer> curPath1;

int strokeWidth = 2;
////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup(){
  size(1024,768);
  bg = loadImage("fountaindreams4.jpeg");
  cake = loadImage("cake.png");  
  cake1 = loadImage("cake.png");
  dedede = loadImage("kingDedede.png");
  //size(125,125);
  testPRM();
  //Vec2 k_start = new Vec2(startPos.x, startPos.y);
  //Vec2 w_start = new Vec2(startPos.x + 120, startPos.y + 120);
  kirby = new KirbyAgent( startPos , new Vec2(0, 0),startPos ,goalPos );
  waddleDee = new WaddleAgent(w_startPos , new Vec2(0,0),w_startPos , w_goalPos);

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////


int numCollisions;
float pathLength;
boolean reachedGoal;
void pathQuality(){
  Vec2 dir;
  hitInfo hit;
  float segmentLength;
  float segmentLength1;
  numCollisions = 9999; pathLength = 9999;
  if (curPath.size() == 1 && curPath.get(0) == -1) {
  return;} //No path found  
  
  if (curPath1.size() == 1 && curPath1.get(0) == -1) {
  return;} //No path found  
  
  pathLength = 0; numCollisions = 0;
  int pathLength1 = 0; int numCollisions1 = 0;


//Kirby Path with no nodes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (curPath.size() == 0 ){ //Path found with no nodes (direct start-to-goal path)
    kirby.vel = new Vec2(0,0);
    segmentLength = startPos.distanceTo(goalPos);
    pathLength += segmentLength;
    dir = goalPos.minus(startPos).normalized();
    hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, startPos, dir, segmentLength);
    if (hit.hit) numCollisions += 1;
    
    return;
  }

//waddledee path with no nodes
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  if (curPath1.size() == 0 ){ //Path found with no nodes (direct start-to-goal path)
    waddleDee.vel = new Vec2(0,0);
    segmentLength1 = w_startPos.distanceTo(w_goalPos);
    pathLength += segmentLength1;
    dir = w_goalPos.minus(w_startPos).normalized();
    hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, w_startPos, dir, segmentLength1);
    if (hit.hit) numCollisions += 1;
    
    return;
  }
  
//Kirby collision detection (path planning)   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

  segmentLength = startPos.distanceTo(nodePos[curPath.get(0)]);
  pathLength += segmentLength;
  dir = nodePos[curPath.get(0)].minus(startPos).normalized();
  hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, startPos, dir, segmentLength);
  if (hit.hit) numCollisions += 1;
  

//waddledee collision detection (path planning)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  segmentLength1 = w_startPos.distanceTo(nodePos[curPath1.get(0)]);
  pathLength1 += segmentLength1;
  dir = nodePos[curPath1.get(0)].minus(w_startPos).normalized();
  hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, w_startPos, dir, segmentLength1);
  if (hit.hit) numCollisions1 += 1;

  
  
//kirby node traversing  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  for (int i = 0; i < curPath.size()-1; i++){
    int curNode = curPath.get(i);
    int nextNode = curPath.get(i+1);
    segmentLength = nodePos[curNode].distanceTo(nodePos[nextNode]);
    pathLength += segmentLength;
    
    dir = nodePos[nextNode].minus(nodePos[curNode]).normalized();
    hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[curNode], dir, segmentLength);
    if (hit.hit) numCollisions += 1;
  }
  
  int lastNode = curPath.get(curPath.size()-1);
  segmentLength = nodePos[lastNode].distanceTo(goalPos);
  pathLength += segmentLength;
  dir = goalPos.minus(nodePos[lastNode]).normalized();
  hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[lastNode], dir, segmentLength);
  if (hit.hit) numCollisions += 1;

//waddledee node traversing  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  hitInfo hit1;
  for (int i = 0; i < curPath1.size()-1; i++){
    int curNode1 = curPath1.get(i);
    int nextNode1 = curPath1.get(i+1);
    segmentLength1 = nodePos[curNode1].distanceTo(nodePos[nextNode1]);
    pathLength1 += segmentLength1;
    
    dir = nodePos[nextNode1].minus(nodePos[curNode1]).normalized();
    hit1 = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[curNode1], dir, segmentLength1);
    if (hit1.hit) numCollisions += 1;
  }
  
  int lastNode1 = curPath1.get(curPath1.size()-1);
  segmentLength1 = nodePos[lastNode1].distanceTo(w_goalPos);
  pathLength1 += segmentLength1;
  Vec2 dir1 = goalPos.minus(nodePos[lastNode]).normalized();
  hit1 = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[lastNode1], dir1, segmentLength1);
  if (hit.hit) numCollisions1 += 1;
}


//Sample Random Positions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Vec2 sampleFreePos(){
  Vec2 randPos = new Vec2(random(width),random(height));
  boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
  while (insideAnyCircle){
    randPos = new Vec2(random(width),random(height));
    insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
  }
  return randPos;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void testPRM(){
  long startTime, endTime;
  
  placeRandomObstacles(numObstacles);
  
  w_startPos = sampleFreePos();
  w_goalPos = sampleFreePos();
  startPos = sampleFreePos();
  goalPos = sampleFreePos();

  generateRandomNodes(numNodes, circlePos, circleRad);
  connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);
  
  startTime = System.nanoTime();
  curPath = planPath(startPos, goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  curPath1 = planPath(w_startPos, w_goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  endTime = System.nanoTime();
  pathQuality();
  
  println("Nodes:", numNodes," Obstacles:", numObstacles," Time (us):", int((endTime-startTime)/1000),
          " Path Len:", pathLength, " Path Segment:", curPath.size()+1,  " Num Collisions:", numCollisions);
}



void update() {
  //gordo.render();
  kirby.render();
  kirby.update();
  waddleDee.render();
  waddleDee.update();
  
  //waddleDee.render();
  //waddleDee.update();
 
  boolean dedeGetsCake = pointInCircle(circlePos[0],100,goalPos,0);
  boolean gordoGetsCake = pointInCircleList(circlePos,circleRad, numObstacles, goalPos, 0);
  float kingToCake = circlePos[0].distanceTo(goalPos);
  float kirbyToCake = kirby.pos.distanceTo(goalPos);
  for (int i = 1 ; i < numObstacles - 1; i++) {
    float gordoToCake = circlePos[i].distanceTo(goalPos); }
    
  
  //Vec2 center, float r, Vec2 l_start, Vec2 l_dir, float max_t
    float kirCakeDist = startPos.distanceTo(goalPos);
    Vec2 kirDir = startPos.minus(goalPos).normalized(); 
    
    float dedeCakeDist = circlePos[0].distanceTo(goalPos);
    Vec2 dedeDir = circlePos[0].minus(goalPos).normalized(); 
    
    float kirDedeDist = circlePos[0].distanceTo(kirby.pos);
    Vec2 kirDedeDir = circlePos[0].minus(kirby.pos).normalized();
  
    boolean cakeInKirby = pointInCircle(kirby.pos, 80.5 , goalPos, 1);
    boolean cakeInDede = pointInCircle(circlePos[0],circleRad[0],goalPos, 1);
  
  
  try {
    waddleDee.followPath(curPath1,nodePos,w_goalPos);
    kirby.followPath(curPath,nodePos,goalPos);
  } catch(ArrayIndexOutOfBoundsException e){
    
    //println("error followPath");
    //kirby.reset();
    //kirby.vel = new Vec2(0,0);
    
    if(cakeInKirby){//println("kirby hit cake"); 
      //println("kirby");
      kirby.reset(); kirby.vel = new Vec2(0,0);
      kirby.updateImage("kirbyforks.png");
      kirby.kirbyGetsCake = true;}
    
    else if(cakeInDede || dedeCakeDist < kirCakeDist && (kirDedeDist < 80.5+circleRad[0])){//println("dede"); kirby.reset(); 
      //println("dede");
      kirby.vel = new Vec2(0,0);
      kirby.updateImage("KirbySeesKingdeedee.png");}
    
    else {//println("gordo"); 
      kirby.reset(); kirby.vel = new Vec2(0,0);
      kirby.updateImage("KirbySeesGordo.png");}              
    }
  
}
    


void draw(){
  background(bg);
  update();

  
 
  //Draw the circle obstacles
  strokeWeight(1);
  stroke(0,0,0);
  fill(255,255,255);
  noFill();
  for (int i = 1; i < numObstacles; i++){
    
    
    //float sqL = circleRad[i]*2;
    //float sqX = circlePos[i].x - circleRad[i]; 
    //float sqY = circlePos[i].y - circleRad[i];
    
    Vec2 c = circlePos[i];
    float r = circleRad[i];
    
    if(hitCircleToggle){   
    circle(c.x,c.y,r*2);}
    //stroke(0,0,0);
    //square(sqX,sqY,sqL);
    
    //gordo.render();
    //gordoPosition[i] = gordPos;
    //if(i%2 == 0) {
    ;
    gordo = new Obstacles(new Vec2(0,0)); 
    image(gordo.gordo,c.x - 50,c.y - 50,100,100);
    //else{
    //image(gordospike,sqX,sqY,sqL,sqL);}
  
    }

  
  
  
  
//Draw the first circle a little special b/c the user controls it
//King Dee Dee , Kingdedede
///////////////////////////////////////////////////////////////////////////////////////////

  circleRad[0] = 150;
  //noFill();
  //square(circlePos[0].x - circleRad[0] ,circlePos[0].y - circleRad[0] , circleRad[0]*2);
  image(dedede,circlePos[0].x - 100 ,circlePos[0].y - 100 , 200, 200);
  noFill();
  //fill(200,100,255);
  strokeWeight(1);
  stroke(255,0,0);
  if(hitCircleToggle){
  circle(circlePos[0].x,circlePos[0].y,circleRad[0]*2);}
  strokeWeight(1);

//draw planning circle (path)
/////////////////////////////////////////////////////////////////////////////////////////
  
  if(planningCircleToggle){ 
     noFill();
     stroke(255); 
  }
  else {noFill(); noStroke();}
    //Draw PRM Nodes
    //fill(0);
    for (int i = 0; i < numNodes; i++){
      circle(nodePos[i].x,nodePos[i].y,161);
    }
  
  
  //Draw graph
/////////////////////////////////////////////////////////////////////////////////////////  
  
  //stroke(100,100,100);
  //strokeWeight(1);
  //for (int i = 0; i < numNodes; i++){
  //  for (int j : neighbors[i]){
  //    line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
  //  }
  //}
  
  
  
  //Draw Start and Goal
/////////////////////////////////////////////////////////////////////////////////////////    
  if(hitCircleToggle){
  stroke(0,0,255);
  noFill();
  //fill(20,60,250);
  //4circle(nodePos[startNode].x,nodePos[startNode].y,20);
  circle(startPos.x,startPos.y,161);
  //fill(250,30,50);
  //noFill();
  //stroke(255,0,0);
  
  
  //circle(nodePos[goalNode].x,nodePos[goalNode].y,20);
  //goal circle
  //circle(goalPos.x,goalPos.y,50);
  }  
  
//Remove Cake image on goalPos when kirby gets cake
//////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (!(kirby.kirbyGetsCake)){
    cake = loadImage("cake.png");
    image(cake,goalPos.x - 35,goalPos.y - 35 ,70,70);}
  else if (kirby.kirbyGetsCake) {cake = loadImage("empty.png");
    image(cake,goalPos.x - 35,goalPos.y - 35 ,70,70);}
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
image(cake1,w_goalPos.x - 35,w_goalPos.y - 35 ,70,70);
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  if (curPath.size() >0 && curPath.get(0) == -1) return; //No path found
  if (curPath1.size() >0 && curPath1.get(0) == -1) return; //No path found
 //Button to turn on path
/////////////////////////////////////////////////////////////////////////////////////////////////////////
  if(pathToggle == true) {
      //Draw Planned Path
      stroke(20,255,40);
      strokeWeight(5);
      if (curPath.size() == 0){
        line(startPos.x,startPos.y,goalPos.x,goalPos.y);
        return;
      }     
      //line from start to curr
      line(startPos.x,startPos.y,nodePos[curPath.get(0)].x,nodePos[curPath.get(0)].y);
     
     for (int i = 0; i < curPath.size()-1; i++){
        int curNode = curPath.get(i);
        int nextNode = curPath.get(i+1);
        //mid lines between start and goal
        line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
      }

      //line from end to curr
      line(goalPos.x,goalPos.y,nodePos[curPath.get(curPath.size()-1)].x,nodePos[curPath.get(curPath.size()-1)].y);
  } //end of current path drawing


//waddledee path drawing
/////////////////////////////////////////////////////////////////////////////////////////////////////////
  if(pathToggle == true) {
      //Draw Planned Path
      stroke(20,255,40);
      strokeWeight(5);
      if (curPath1.size() == 0){
        line(w_startPos.x,w_startPos.y,w_goalPos.x,w_goalPos.y);
        return;
      }     
      //line from start to curr
      line(w_startPos.x,w_startPos.y,nodePos[curPath1.get(0)].x,nodePos[curPath1.get(0)].y);
          
      for (int i = 0; i < curPath1.size()-1; i++){
        int curNode1 = curPath1.get(i);
        int nextNode1 = curPath1.get(i+1);
        //mid lines between start and goal
        line(nodePos[curNode1].x,nodePos[curNode1].y,nodePos[nextNode1].x,nodePos[nextNode1].y);
      }
      //line from end to curr
      line(w_goalPos.x,w_goalPos.y,nodePos[curPath1.get(curPath1.size()-1)].x,nodePos[curPath1.get(curPath1.size()-1)].y);
  } //end of current path drawing





///////////////////////////////////////////////////////////////////////////////////////////////////////////
//  if(pathToggle == true) {
//      //Draw Planned Path
//      stroke(20,255,40);
//      strokeWeight(5);
//      if (curPath1.size() == 0){
//        line(w_startPos.x,w_startPos.y,w_goalPos.x,w_goalPos.y);
//        return;
//      }     
//      //line from start to curr
//      line(w_startPos.x,w_startPos.y,nodePos[curPath1.get(0)].x,nodePos[curPath1.get(0)].y);
//      for (int i = 0; i < curPath.size()-1; i++){
//        int curNode = curPath1.get(i);
//        int nextNode = curPath1.get(i+1);
//        //mid lines between start and goal
//        line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
//      }
//      //line from end to curr
//      line(w_goalPos.x,w_goalPos.y,nodePos[curPath1.get(curPath1.size()-1)].x,nodePos[curPath1.get(curPath1.size()-1)].y);
//  } //end of current path drawing
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


} //end of draw
///////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  





boolean planningCircleToggle = false;
boolean hitCircleToggle = false;
boolean pathToggle = false;
boolean shiftDown = false;

void keyPressed(){

  if (key == 'h') { 
    if (hitCircleToggle == false) {
      hitCircleToggle = true;}
    else {hitCircleToggle = false;}  
  }
    
  if (key == 'c') { 
   if (planningCircleToggle == false) {
     planningCircleToggle = true;}
   else {planningCircleToggle = false;}
  }
  
  if (key == 'p') { 
    if (pathToggle == false) {
      pathToggle = true;}
    else {pathToggle = false;}
      }
      
  if (key == 'r'){

    testPRM();
    waddleDee.reset();
    waddleDee.pos = w_startPos;
    kirby.reset();
    kirby.pos = startPos;
    
    return;
  }
  
  if (keyCode == SHIFT){
    shiftDown = true;
  }
  
  float speed = 10;
  if (shiftDown) speed = 30;
  if (keyCode == RIGHT){
    circlePos[0].x += speed;
  }
  if (keyCode == LEFT){
    circlePos[0].x -= speed;
  }
  if (keyCode == UP){
    circlePos[0].y -= speed;
  }
  if (keyCode == DOWN){
    circlePos[0].y += speed;
  }
  connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);
  curPath = planPath(startPos, goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  curPath1 = planPath(w_startPos, w_goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
}

void keyReleased(){
  if (keyCode == SHIFT){
    shiftDown = false;
  }
}


//bookmark
void mousePressed(){

  
  if (mouseButton == RIGHT){
    Vec2 mouseclick = new Vec2(mouseX, mouseY);
    //if(hit.hit) {  
      kirby.pos = mouseclick;
      startPos = kirby.pos;
      kirby.reset();
    //}
    }
  else{
    goalPos = new Vec2(mouseX, mouseY);
    kirby.reset();
    startPos = kirby.pos;
  }
  curPath = planPath(startPos, goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
  curPath1 = planPath(w_startPos, w_goalPos, circlePos, circleRad, numObstacles, nodePos, numNodes);
}
