public class Bspline_class
{ 
   private int n=4;  //no of control points= n
   private int k=3;  //order of BSpline=k  NOTE: Degree p=k-1
   PVector[] cpal;     //arraylist of control points
   float[] knots;
    Bspline_class(int ncp,int ord)
   {
     n=ncp;
     k=ord;
     knots=new float[n+k+1];
     cpal= new PVector[n+1];
     // Knots definition
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
     }
     //
     
   } 
   
   
   public void definewith_cp(PVector [] arr)
   {
     
     for(int i=0;i<arr.length;i++)
     {
       
       cpal[i]= arr[i].get();
     }
     
   }
   
   public PVector get_point(float val)
   {
     int knotnode=0;
     for(int i=k;i<=n+1;i++)
     if(val< knots[i] && val>=knots[i-1])
     knotnode=i-1;
     if(val==1)
     knotnode=n;
     
     PVector [][] P= new PVector [n+1][k];
     for(int i=0;i<n+1;i++)
     {
       P[i][0]=cpal[i].get();//??????????
     
     }
     
     for(int j=1;j<k;j++)
     for(int i=knotnode-k+j+1;i<=knotnode;i++)
     {
       float rij=(val - knots[i])/(knots[i+k-j]-knots[i]);
       PVector temp1,temp2;
       temp1=P[i-1][j-1].get();
       temp2=P[i][j-1].get();
       temp1.mult(1-rij);
       temp2.mult(rij);
       temp1.add(temp2);
       P[i][j]=temp1.get();
       
     
     }
    
     return P[knotnode][k-1];
   }
   
   void change_knots(float[] arr)
   {
     for(int i=k;i<=n;i++)
     knots[i]=arr[i];
   }
  
}
