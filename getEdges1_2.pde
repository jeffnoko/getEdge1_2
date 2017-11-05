import java.util.Vector;
import processing.video.*;
import blobDetection.*;

Capture video;
PImage lastFrame;

BlobDetection blobDetection;
int threshold2 = 128;

void setup() {
  size(640, 480);
  
  video = new Capture(this, width, height);
  video.start();
  
  blobDetection = new BlobDetection(video.width, video.height);
  blobDetection.setPosDiscrimination(false);
  
  background(0);

}

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    lastFrame = video;
    
    // Show a little preview in the lower right corner
    image(video, 3 * width / 4, 3 * height / 4, width / 4, height / 4);
  }
}

void keyPressed() {
  Vector<Edge> edges = getEdges(lastFrame);
  
  background(0);
  
  image(lastFrame, 0, 0);
  
  stroke(255, 0, 0);
  for (Edge edge : edges) {
    line(edge.x1, edge.y1, edge.x2, edge.y2);
  }
  
   switch(keyCode) {
  
    case 32:  // this is the KeyCode for 'spacebar'
     // display();
    break;
   
    case UP:   // keyCode for up is 38, but processing has this already defined as 'UP' for us 
      threshold2++; 
    break;  // if the up arrow
    
    case DOWN:   // keyCode for up is 40, but processing has this already defined as 'DOWN' for us 
      threshold2--; 
    break;  // if the up arrow
  
    default: 
    break;
  }
  
  // let's print the latest value of our threshold
  println("threshold: " + threshold2);
}

Vector<Edge> getEdges(PImage image, int threshold) {
  Vector<Edge> edges = new Vector<Edge>();
  
  blobDetection.setThreshold(map(threshold, 0, 255, 0, 1));
   // blobDetection.setThreshold(threshold);
  blobDetection.computeBlobs(image.pixels);
  
  for (int n = 0; n < blobDetection.getBlobNb(); n++) {
    Blob blob = blobDetection.getBlob(n);
    
    if (blob != null) {
      for (int m = 0; m < blob.getEdgeNb(); m++) {
        EdgeVertex vertA = blob.getEdgeVertexA(m);
        EdgeVertex vertB = blob.getEdgeVertexB(m);
        
        if (vertA != null && vertB != null) {
          edges.add(new Edge(vertA.x * image.width, vertA.y * image.height, vertB.x * image.width, vertB.y * image.height));
        }
      }
    }
  }
  
  return edges;
}

Vector<Edge> getEdges(PImage image) {
 
   return getEdges(image, threshold2 );
}

class Edge {
  public final float x1, x2, y1, y2;
  
  public Edge(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
}