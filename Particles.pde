
public class Particlenew
{
  Position position;
  Velocity velocity;
  Position pbest;
  
  Particlenew(int ncp, int k,PVector start,PVector end)
  {
    position=new Position(ncp,k,start,end);
    velocity= new Velocity(ncp,k);
    pbest=new Position(ncp,k,start,end);
  }
}


public class Position
{
  PVector [] cps;
  float [] knots;
  int n;
  int k;
  
  Position(int ncp, int k,PVector start, PVector end)
  {
    this.n=ncp;
    this.k=k;  
    cps= new PVector[n+1];
    knots = new float [n+k+1];
    cps[0]=start.get();
    cps[n]=end.get();
    initialize_position();
  }
  
  private void initialize_position()
  {
    for(int i=1;i<cps.length-1;i++)
    {
      cps[i]=new PVector(random(width),random(height),0);
    }
    
    for(int i=0;i<k;i++)
    {
      knots[i]=0;
      knots[n+k-i]=1;
    }
    for(int i=k;i<=n;i++)
    {
      float N=(float) n;
      float K=(float) k;
      float I=(float) i;
      knots[i]= (1/(N-K+2)) *(I-K+1);
        //knots[i]=random(0,1);
        //sort_knots();
    }
    //println(knots[k]);
   }
   
   public void update_position(Velocity velocity)
   {
      for(int i=1;i<cps.length-1;i++)
      {
         cps[i].x=cps[i].x+velocity.cpsv[i-1].x;
         cps[i].y=cps[i].y+velocity.cpsv[i-1].y;
      }
      
    //  for(int i=k;i<=n;i++)
     // {
     //    knots[i]=knots[i]+velocity.knotsv[i-k];
     // }
      
  //    sort_knots();
   }
   
   private void sort_knots()
   {
      for(int i=k;i<n;i++)
      for(int j=i+1;j<=n;j++)
      {
        if(knots[i]>knots[j])
        {
          float temp=knots[j];
          knots[j]=knots[i];
          knots[i]=temp;
        }
      }       
      rectify_knots();
    }
   private void rectify_knots()
   {
     for(int i=k;i<=n;i++)
     {
       if(knots[i]<0.500)
       knots[i]=0.5;
       else if(knots[i]>0.95)
       knots[i]=0.95;
     }
   }
   public void clone(Position pos)
   {
     for(int i=0;i<pos.cps.length;i++)
     this.cps[i]=pos.cps[i].get();
     for(int i=pos.k;i<=pos.n;i++)
     this.knots[i]=pos.knots[i];
   }
}



public class Velocity
{
  PVector [] cpsv;
  float [] knotsv;
  int n;
  int k;
  float maximumvel=1.6;
  Velocity(int ncp,int k)
  {
    this.n=ncp;
    this.k=k;
    cpsv=new PVector[n-1];
    knotsv=new float[n-k+1];
    initialize_velocity();
  }
  
  private void initialize_velocity()
  {
    for(int i=0;i<cpsv.length;i++)
    {
      cpsv[i]=new PVector(0,0,0);
    }
    for(int i=0;i<knotsv.length ;i++)
    {
      knotsv[i]=0;
    }
  }
  public void update_velocity(float omega,float c1,float c2,Position gbest, Position pbest, Position pos)
    {
      for(int i=0;i<cpsv.length;i++)
      {
        cpsv[i].x=omega*cpsv[i].x+c1*random(1)*(gbest.cps[i+1].x-pos.cps[i+1].x)+c2*random(1)*(pbest.cps[i+1].x-pos.cps[i+1].x);
        cpsv[i].y=omega*cpsv[i].y+c1*random(1)*(gbest.cps[i+1].y-pos.cps[i+1].y)+c2*random(1)*(pbest.cps[i+1].y-pos.cps[i+1].y);
        if(pow(cpsv[i].mag(),2)>pow(maximumvel,2))
        cpsv[i].mult((maximumvel/sqrt(pow(cpsv[i].x,2)+pow(cpsv[i].y,2))));
      }
    }
  }
