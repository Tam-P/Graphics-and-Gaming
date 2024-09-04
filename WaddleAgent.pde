public class WaddleAgent {

  //Declare properties of an agent
  public Vec2 pos;
  public Vec2 vel;
  public Vec2 start;
  public Vec2 goal;
  public float speed;
  private PImage img; 
  private boolean kirbyGetsCake;
  private float agentlen;
  
  private int currentNodeIndex = 0;
  
  public void reset(){
  this.currentNodeIndex = 0;
  this.kirbyGetsCake = false;
  }
  
  //constructor
  WaddleAgent(Vec2 position, Vec2 velocity, Vec2 start, Vec2 goal) {
  //Setting properties in agent
    this.pos = position;
    this.vel = velocity;
    this.start = start;
    this.goal = goal;
    this.speed = 6;
    this.kirbyGetsCake = false;
    this.agentlen = 161;
  }
  
  //where we draw png at x & y
  private void render() {
    //fill(255,100,100);
    //circle(this.pos.x,this.pos.y,50);
    this.img = loadImage("WaddleDee.png");
    image(img,this.pos.x - 80.5, this.pos.y - 80.5, 161,161);
      
    }
    
  
  private void update() {
    //position = position + velocity 
     Vec2 vel1 = new Vec2 (this.vel.x * speed, this.vel.y * speed);   
     this.pos.add(vel1);
     //this.pos.add(this.vel);
     
  }
  
  //public boolean reachGoal(Vec2 goalPos){
  
  //  if(this.pos.distanceTo(goalPos) < this.speed) {return true;}
    
  //  return false;
  
  //}

  public void faceToward(Vec2 point) {
    // gives direction of velocity
    // shallow copy helps prevent changes to point, returns a new obj of all of the value of old
    // objects point and goal do not share the same reference
      Vec2 goal = point.shallowCopy();
      goal.subtract(this.pos);
      goal.normalize();
      this.vel = goal;
  }
  
  
  
  void followPath(ArrayList<Integer> pathIndexes, Vec2[] nodes, Vec2 finalGoal) {

    append(nodes, finalGoal);


    if (currentNodeIndex >= pathIndexes.size()) {     
      if (pathIndexes.contains(-1)) { //collision blocks path
        //println("worked");
        this.img = loadImage("WaddleDeeKing.png");
        //image(img,this.pos.x - (this.agentlen/2), this.pos.y - (this.agentlen/2), this.agentlen, this.agentlen);
        this.vel = new Vec2(0,0);
        
        return;
      }
      else {
        faceToward(finalGoal);}
      
      if (this.pos.distanceTo(finalGoal) < this.speed) {
        
       // this.img = loadImage("WaddleDeeKirby.png");
        image(img,this.pos.x - (this.agentlen/2), this.pos.y - (this.agentlen/2), this.agentlen, this.agentlen);
        this.kirbyGetsCake = true;
        this.vel = new Vec2(0, 0);
        }
        return;
    }

    Vec2 goal = nodes[pathIndexes.get(currentNodeIndex)];
    
    faceToward(goal);
    if ( this.pos.distanceTo(goal) < this.speed) {
    this.currentNodeIndex += 1; }
    //println("current Path Index", pathIndexes.get(currentNodeIndex));
    
    

  }
public void updateImage(String newpic){
  this.img = loadImage(newpic);
  image(img,this.pos.x - 80.5, this.pos.y - 80.5, 161,161);

}

public void flipImage(PImage img2) {

image(img2,this.pos.x + 80.5, this.pos.y + 80.5, -161,161);

}



public boolean setImage(String newpic1){
if (this.img == loadImage(newpic1)){
return true;
}
return false;
}


}
