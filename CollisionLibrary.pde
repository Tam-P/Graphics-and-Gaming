import java.lang.Boolean; 
import java.lang.Math; 
/////////
// Point Intersection Tests
/////////

//Returns true iff the point, pointPos, is inside the box defined by boxTopLeft, boxW, and boxH
boolean pointInBox(Vec2 boxTopLeft, float boxW, float boxH, Vec2 pointPos){
  float x = boxTopLeft.x;
  float y = boxTopLeft.y;  
  
  float pt_x = pointPos.x;
  float pt_y = pointPos.y;
  
  if((pt_x >= x)&&( pt_x <= boxW+x)&&(pt_y >= y)&&(pt_y <= boxH+y)){
    return true;}
  else {
    return false;}
}

//Returns true iff the point, pointPos, is inside a circle defined by center and radius r
// If eps is non-zero, count the point as "inside" the circle if the point is outside, but within the distance eps of the edge
boolean pointInCircle(Vec2 center, float r, Vec2 pointPos, float eps){
  float pt_x = pointPos.x;
  float pt_y = pointPos.y;
  float cent_x = center.x;
  float cent_y = center.y;
  double d = Math.pow(pt_x - cent_x,2) + Math.pow(pt_y - cent_y,2); 
  d = Math.pow(d,0.5);
  float dist = (float)d;
 // println(dist);
  if ((eps != 0.0)&&( dist <= r+eps )){
  return true;}  
  
  else if (dist <= r){
    return true;}

   else {
    return false;}
}
//Returns true if the point is inside any of the circles defined by the list of centers,"centers", and corisponding radii, "radii".
// As above, count point within "eps" of the circle as inside the circle
//Only check the first "numObstacles" circles.
boolean pointInCircleList(Vec2[] centers, float[] radii, int numObstacles, Vec2 pointPos, float eps){
  
  for (int i = 0; i < numObstacles; i++){
  //  println("bool:",pointInCircle(centers[i],radii[i], pointPos, eps));
  //  println("i is:", i);
  //  println(radii[i]);
  //  println(radii[i]+ eps);
    
    if (pointInCircle(centers[i],radii[i], pointPos, eps)){
      return true;   }
    
  }
    return false;
  
}


/////////
// Ray Intersection Tests
/////////

//This struct is used for ray-obstaclce intersection.
//It store both if there is a collision, and how far away it is (int terms of distance allong the ray)
class hitInfo{
  public boolean hit = false;
  public float t = 9999999;//distance from ray to the circle
}

hitInfo rayCircleIntersect(Vec2 center, float r, Vec2 l_start, Vec2 l_dir, float max_t){
  hitInfo hit = new hitInfo();
  
  //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
    Vec2 toCircle = center.minus(l_start);
    
    //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
    float a = 1;  //Length of l_dir (we normalized it)
    float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
    float c = toCircle.lengthSqr() - (r+strokeWidth)*(r+strokeWidth); //different of squared distances
    
    float d = b*b - 4*a*c; //discriminant 
    
    if (d >=0 ){ 
      //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
      //  ... this means t will be between 0 and the length of the line segment
      float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only need the first collision
      float t2 = (-b + sqrt(d))/(2*a); //Optimization: we only need the first collision
      //println(hit.t,t1,t2);
      if (t1 > 0 && t1 < max_t){
        hit.hit = true;
        hit.t = t1;
      }
      else if (t1 < 0 && t2 > 0){
        hit.hit = true;
        hit.t = -1;
      }
      
    }
    
  return hit;
}

//takes in 6 parameters : vec2[],float[],int,vec2,vec2,float
hitInfo rayCircleListIntersect(Vec2[]centers, float[] radii, int numObstacles, Vec2 l_start, Vec2 l_dir, float max_t){
  hitInfo hit = new hitInfo();
  hit.t = max_t;
  for (int i = 0; i < numObstacles; i++){
    Vec2 center = centers[i];
    float r = radii[i];
    
    hitInfo circleHit = rayCircleIntersect(center, r, l_start, l_dir, hit.t);
    if (circleHit.t > 0 && circleHit.t < hit.t){
      hit.hit = true;
      hit.t = circleHit.t;
    }
    else if (circleHit.hit && circleHit.t < 0){
      hit.hit = true;
      hit.t = -1;
    }
  }
  return hit;
}
