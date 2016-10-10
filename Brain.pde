class Brain{
  Neuron[][] neuron;
  float[][][] weights;
  
  //a is inputs length, b is output length
  Brain(int a, int b){
    neuron = new Neuron[a][b];
    weights = new float[a][b][b];
    for(int i = 0; i < weights.length; i++){
      for(int j = 0; j < weights[i].length; j++){
        for(int k = 0; k < weights[i][j].length; k++){
          weights[i][j][k] = random(-1,1);
        }
      }
    }
    for(int i = 0; i < a; i++){
      for(int j = 0; j < b; j++){
        neuron[i][j] = new Neuron(-0.01,weights[i][j]);
      }
    }
  }
  void setWeight(float[][][] newWeight){
    for(int i = 0; i < neuron.length; i++){
      for(int j = 0; j < neuron[i].length; j++){
        neuron[i][j] = new Neuron(-0.01,newWeight[i][j]);
      }
    }
  }
  float[][][] getWeights(){
    return weights;
  }
  float[] feedForward(float[] input){
    float[] hiddenOut = new float[neuron[0].length];
    float[] action = new float[neuron[1].length];
    for(int i = 0; i < neuron[0].length; i++){
      hiddenOut[i] = neuron[0][i].feedForward(input);
    }
    for(int i = 0; i < neuron[1].length; i++){
      action[i] = neuron[1][i].feedForward(hiddenOut);
    }
    return action;
  }
}
    
    
    
    
  
  
  