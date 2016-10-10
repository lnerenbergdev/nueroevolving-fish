Creature[] fish;
Creature[] newFish;
float[][][][] newWeight;

PVector[] Food = new PVector[5];
int F;

int k = 0;

boolean evolving = true;

PrintWriter output;
float Time;

float[][][] Ancestor = new float[4][4][4];
float[][][][] Parent = new float[4][2][4][4];
float[][][] Alive = new float[25][4][4];
int n = 0;

boolean displaying = true;

void setup(){

  background(0);

  size(700,700);
  Time = 0;
  //output = createWriter("evolution.txt");
  String[] initialP = loadStrings("brain.txt");
  float[] initialParent = new float[initialP.length];
  for(int i = 0; i < initialP.length; i++){
    initialParent[i] = float(initialP[i]);
  }
  newWeight = new float[25][2][4][4];
  newWeight = initializeWeights(25,2,4,4,initialParent);
  fish = new Creature[2];
  fish = NewFish(newWeight);
  newFish = new Creature[2];
  for(int i = 0; i < Food.length; i++){
    Food[i] = new PVector(random(width),random(height));
  }
  frameRate(60);
  
  Parent = initializeWeights(25,2,4,4,initialParent);
  
  float[][][] AncestorWeight = new float[25][4][4];
  
  for(int i = 0; i < Ancestor.length; i++){
    for(int j = 0; j < Ancestor[0].length; j++){
      for(int k = 0; k < Ancestor[0][0].length; k++){
        AncestorWeight[i][j][k] = initialParent[i+j+k];
      }
    }
  }
  for(int i = 0; i < fish.length; i++){
    fish[i].brain.setWeight(AncestorWeight);
  }
}

void draw(){
  if(displaying){
    background(0);
  }
  for(Creature F : fish){
    if(F.isLiving()){
      F.update();
      if(displaying){
       F.display();
      }
      
      F.Sense(Food, fish);
      F.Think();
      
      Alive = F.brain.getWeights();
      
     
      for(PVector f : Food){
        fill(255);
        if(displaying){
          ellipse(f.x, f.y, 5,5);
        } 
      }
      int i = F.Eat(Food);
      if(i!=0){
        Food[i-1].set(random(width),random(height));
      }
    }
  }
  if(numLiving(fish) < 7 && evolving == true){
    for(int i = 0; i < fish.length; i++){
      if(fish[i].isLiving()){
        Parent[n%5] = fish[i].brain.getWeights();
        n++;
      }
    }
  }
  if(numLiving(fish) < 2 && evolving == true){
    background(0);
    //output.println(Time);
    fish = NewFish(crossOver(Parent, 25));
    Time = 0;
  }
 Time++; 
}

Creature[] NewFish(float[][][][] weights){
  Creature[] newFish = new Creature[weights.length];
  for(int i = 0; i < weights.length; i++){
    newFish[i] = new Creature(int(random(width)),int(random(height)));
    newFish[i].brain.setWeight(weights[i]);
  }
  return newFish;
}

float[][][][] initializeWeights(int a, int b, int c, int d, float[] initialParent){
  float[][][][] newWeight = new float[a][b][c][d];
  for(int i = 0; i < a; i++){
    for(int j = 0; j < b; j++){
      for(int k = 0; k < c; k++){
        for(int l = 0; l < d; l++){
          if(i+j+k+l<initialParent.length){
            //newWeight[i][j][k][l] = initialParent[i+j+k+l];
          }
          else{
            newWeight[i][j][k][l] = random(-1,1);
          }
          newWeight[i][j][k][l] = random(-1,1);
        }
      }
    }
  }
  return newWeight;
}
          
int numLiving(Creature[] fish){
  int living = 0;
  for(Creature f : fish){
    if(f.isLiving()){
      living++;
    }
  }
  return living;
}

float[][][][] crossOver(float[][][][] parent, int n){
  float[][][][] child = new float[n+parent.length][parent[0].length][parent[0][0].length][parent[0][0][0].length];
  for(int i = 0; i < n; i++){
    for(int j = 0; j < parent[0].length; j ++){
      for(int k = 0; k < parent[0][0].length; k++){
        for(int l = 0; l < parent[0][0][0].length; l++){
          child[i][j][k][l] = parent[int(random(parent.length))][j][k][l];
        }
      }
    }
  }
  for(int i = n-1; i < n+parent.length-1; i++){
    child[i] = parent[i-(n-1)];
  }
  return child;
}


void keyPressed(){
  if(key == CODED){
    if(keyCode == LEFT){
      for(int i = 0; i < Alive.length; i++){
        output.println(i);
        for(int j = 0; j < Alive[0].length; j++){
          for(int k = 0; k < Alive[0][0].length; k++){                            
            output.println(Alive[i][j][k]);
          }
        }
      }
      output.flush();
      output.close();
    } 
    if(keyCode == DOWN){
      displaying = !displaying;
      background(0);
    }
  }
}

void mousePressed(){
  save("fish.jpg");
}

  