int noofparticles=22;
float omega=1.5;

PVector[] Data;
Bspline_class newbspline;

Position gbest;
float c1=1;
float c2=1.5;
int iter=1;
Particlenew[] particles;

int n=99;
int k=3;
int m=100;

int xx = 0;

void setup()
{
  size(500,400);
  smooth();
  frameRate(300);
  particles= new Particlenew[noofparticles];
 


  Data = new PVector[m];
  
 for(int i = 0;i<(m-1);++i)
    Data[i] = new PVector(random(width),random(height));
   
  Data[m-1] = Data[0];
    
    
   //Data[i] = new PVector(i*10,constrain((height/2)+30*((tan((i)))),0.0,(float)height));
 // for(int i = 0;i<m;++i)
  // Data[i] = new PVector(random(width),random(height));
  // Data[0] = new PVector(50,50);
  // Data[1] = new PVector(200,200);
  // Data[2] = new PVector(50,200);
  // Data[3] = new PVector(70,70);
  // Data[4] = new PVector(170,170);
  // Data[5] = new PVector(70,170);
  // Data[6] = new PVector(50,50);
   
   //initCirc(100,200,200);
   //initCirc(50,200,200);
   
  gbest =new Position(n,k,Data[0],Data[Data.length-1]);
   
  newbspline=new Bspline_class(n,k);  
  for(int i=0;i<noofparticles;i++)
    {
      particles[i]=new Particlenew(n,k,Data[0],Data[Data.length-1]);
    }
  for(int i=0;i<noofparticles;i++)
  {
    if(error(particles[i].pbest) <error(gbest))
    gbest.clone(particles[i].pbest);
  }

 
  
}

void initCirc(int radius, int centerx, int centery)
{
  int x, y;
  int zz = 0;


  for (x = -radius; x <= radius; x++) {
    y = (int) sqrt ((float) (radius * radius) - (x * x));
    if ((zz%10)==0){
      Data[xx] = new PVector(x+centerx,y+centery);
      ++xx;
      Data[xx] = new PVector(x+centerx,-y+centery);
      ++xx;
     
    }
    ++zz;

  }
  println(xx);
  Data[xx-1] = Data[0];
}


void draw()
{  
  background(255);
  
  
  
   if( iter<=200000)
  {
    
    newbspline.definewith_cp(gbest.cps);
    newbspline.change_knots(gbest.knots);
    drawparticles();
    
    for(int i=0;i<noofparticles;i++)
    {
      particles[i].velocity.update_velocity(omega,c1,c2,gbest,particles[i].pbest,particles[i].position);
      particles[i].position.update_position(particles[i].velocity);
    }
    
     for(int i=0;i<noofparticles;i++)
    {
      if(error(particles[i].position)<error(particles[i].pbest))
      particles[i].pbest.clone(particles[i].position);
      
      if(error(particles[i].pbest)<error(gbest))
      gbest.clone(particles[i].pbest);
      
    }
  //  println(gbest.knots);
 // println(error(gbest));
 fill(0);
    text("Fitness:"+error(gbest),10,10);
    text("iter:"+iter,150,10);
   
    if(gbest.knots[k]<0.1)
      gbest.cps[1]=gbest.cps[0];
    if(gbest.knots[n]>0.99)
      gbest.cps[gbest.cps.length-2]=gbest.cps[gbest.cps.length-1];
    iter++;
    
  }
 
}

void mousePressed() {

println(""+mouseX+","+mouseY);
}

void drawparticles()
{
  
  //CURVE  done via bspline
  stroke(0,0,0);
 // beginShape();
   for(float i=0;i<1-0.001;i=i+0.001)
   {
    PVector pnt1=newbspline.get_point(i);
    //curveVertex(pnt1.x,pnt1.y);
    point(pnt1.x,pnt1.y);
   }
  //endShape();
  
  //The Data points
  stroke(255,0,0);
  for(int i=0;i<m;i++)
  {
    ellipse(Data[i].x,Data[i].y,2,2);
  }
  //CTRL POINTS
  stroke(0,255,0);
  for(int i=0;i<gbest.cps.length;i++)
  {
    if(i==0||i==(gbest.cps.length-1)){
      stroke(0,0,0);
    }else{
      stroke(0,255,0);
    }
    ellipse(gbest.cps[i].x,gbest.cps[i].y,5,5);
  }
    
    
  


}

float error(Position pos)
{
  newbspline.definewith_cp(pos.cps);
  newbspline.change_knots(pos.knots);
  float Q=0; int count=0;
  for(float i=0; i<=1;i=i+(1/((float)m-1)))
  {
    PVector pt= newbspline.get_point(i);
    Q=Q+pow(Data[count].x-pt.x,2)+pow(Data[count].y-pt.y,2);
    count++;
  }
  Q=log(Q)/log(exp(1));
  Q=Q*m;
  Q=Q+(log(m)/log(exp(1)))*(k+n+1);
  return Q;
}
