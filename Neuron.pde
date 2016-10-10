class Neuron{
  float c = 0;
  float[] weights;
  Neuron(float _c, float[] _weights){
    weights = _weights;
    c = _c;
  }
  float feedForward(float[] inputs){
    float sum = 0;
    for(int i = 0; i < inputs.length; i++){
      inputs[i] *= weights[i];
      sum += inputs[i];
    }
    sum += c;
    return activate(sum);
  }
  float activate(float sum){
    return 1/(1+exp(-1*sum)) - 0.5;
  }
}