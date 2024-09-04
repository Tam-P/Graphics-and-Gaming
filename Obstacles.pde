

public class Obstacles {
  
  private PImage gordo;
  //private PImage gordospike;
  private Vec2 pos;
  //private float x;
  //private float y;
  private float len;
  
  
  //constructor 
  Obstacles(Vec2 position) {
  //Setting properties in agent
    this.pos = position;
    this.len = 125;
    //this.gordo = new PImage[2];
    this.gordo = loadImage("gordo0.png");
    
  }
  
 public void render() { 
    //this.gordo[0] = loadImage("gordo0.png");
    //this.gordo[1] = loadImage("gordo1.png");
    //image(this.gordo[0],this.pos.x,this.pos.y,this.len,this.len);
    
}
}
   
