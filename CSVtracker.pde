import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Random;


class CSVTrack{
  FileWriter fw;
  PrintWriter writer;
   Date date = new Date();
  CSVTrack(String name){
   SimpleDateFormat sdf = new SimpleDateFormat("hh_mm_ss");    
    try {
        fw = new FileWriter(sketchPath(sdf.format(Calendar.getInstance().getTime())+"-"+name+".csv"));
        writer = new PrintWriter(fw);
      } catch (Exception e) {
      // TODO Auto-generated catch block
       println("File not found");
      }
  }
  
  void logResults(float fitness, int generation){
    if(writer != null){
      if(generation%50==0){//record every 50th result
        writer.println(generation + ","+fitness);
        writer.flush();
      }
      
    }
    
  }
  
  void closefiles(){
    if(writer!=null){
      
     writer.flush();
     writer.close(); 
     writer = null;
     try{
       fw.close();
       fw = null;
     }catch(Exception e){
       
     }
    }
    
  }
  
}
