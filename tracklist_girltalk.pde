
import controlP5.*;

import de.bezier.data.*;

import java.util.Map;

import java.util.*;

import java.util.HashMap;


XlsReader reader;


ControlP5 cp5;


int myColorBackground = color(128);

int sliderValue = 100;

int currentTab = 0; //what tab the user is currently clicked on. tab corresponds to track num

/// Note the HashMap's "key" is a Integer specifying its tracknum/ tab
//  which corresponse to a value that is a map. The value Map has a key of floats which
//  represent the position in seconds that a song appears on a track and mapts to  the corresponding artist/song string
HashMap<Integer,Map<Float,String>> hm = new HashMap<Integer,Map<Float,String>>();

String nextTrackName;
public void setup() {
  size(700,400);
  noStroke();
  reader = new XlsReader( this, "girltalk-samples.xls" );
    cp5 = new ControlP5(this);

  reader.firstRow(); //contains column labels
  int track = 0; // initialize to a track num that doesnt exist

while(reader.hasMoreRows()){
  reader.nextRow();
  int nextRowTrackNum = reader.getInt();
  if( nextRowTrackNum != track){ //if new track num, create new tab
  track = nextRowTrackNum;
    reader.nextCell();
    nextTrackName = reader.getString(); 
        cp5.addTab("T"+Integer.toString(track)) // track num used to name
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
     
     cp5.getTab("T"+Integer.toString(track))
     .activateEvent(true)
     .setLabel(Integer.toString(track) + ") " + nextTrackName) // label shows track name
     .setId(track) //id is also by track num
     ;
     
     reader.nextCell(); //duration of song in seconds 
     
    float duration = reader.getFloat(); // int? or float?
    println(duration);

        
     cp5.addSlider("S"+Integer.toString(track)) //create slider for tab with tracknum as name
     .setBroadcast(false)
     .setRange(0,duration)
     .setValue(1)
     .setPosition(100,200)
     .setSize(200,20)
     .setBroadcast(true)
     ;
     
     //move slider to tab
     cp5.getController("S"+Integer.toString(track)).moveTo("T"+Integer.toString(track));

    
   }
  else{ //if a tag and slider have already been made for a track,
      //skip to entering their samples
      reader.nextCell();
      reader.nextCell();
  }
  //HashMap<Integer,Map<Float,String>> hm = new HashMap<Integer,Map<Float,String>>();
  reader.nextCell();
  String sampleTitleandArtist = reader.getString();
  println(sampleTitleandArtist);
  reader.nextCell();

  sampleTitleandArtist += (" " + reader.getString());
        println(sampleTitleandArtist);
  
        // retr
        reader.nextCell();
        reader.nextCell();
        float samplePosition =reader.getFloat(); //sample position in seconds
        
        Map<Float,String> sample = new HashMap<Float,String>();
        sample.put(samplePosition, sampleTitleandArtist);
        
        hm.put(track,sample);  
  }
 

}

public void draw() {
  background(myColorBackground);
  fill(sliderValue);
  rect(0,0,width,100);
 // cp5.getController("sliderValue"+track);
 if(currentTab != 0){
   Map<Float, String> timedSamples = hm.get(currentTab);
   String sampledSongs = timedSamples.get(cp5.getController("S"+Integer.toString(currentTab)).getValue());
   cp5.getController("S"+Integer.toString(currentTab)).setCaptionLabel(sampledSongs);
 }
  
  
}

public void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
    currentTab = theControlEvent.getTab().getId();
  }

}

void slider(int theColor) {
  myColorBackground = color(theColor);
  println("a slider event. setting background to "+theColor);
}




