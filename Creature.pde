class Creature {
  Brain brain;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float R;
  float maxforce;
  float maxspeed;
  float oldHeading;
  float newHeading;
  float Hunger;
  float[] sense = new float[4]; 
  PVector[] Food;
  float fov = radians(30);
  float timeLiving;
  color Color = color(random(255),random(255),random(255));
  //color Color = color(255);

  boolean dead;

  float Contents;
  float Capacity;

  Creature(int x, int y) {
    brain = new Brain(2, 4);
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-10, 10), random(-10, 10));
    location = new PVector(x, y);
    R = 20.0;
    maxspeed = 4;
    maxforce = 0.1;
    oldHeading = velocity.heading() + PI/2;
    PVector[] Food = new PVector[10];
    Food[0] = new PVector(0, 0);

    dead = false;

    Contents = 30;
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }


  void update() {
    //checkEdges();



    if (Contents < 0) {
      dead = true;
    }

    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);

    if (!dead) {
      timeLiving++;
    }
    Contents-=0.05;
  }

  boolean isLiving() {
    return !dead;
  } 

  float getHunger() {
    return Hunger;
  }

  void ventral(float h) {
    if (h > 0) {
      acceleration = new PVector(cos(velocity.heading()), sin(velocity.heading()));
    } else if (h<0) {
      acceleration.setMag(acceleration.mag()-1);
    }
  } 

  void caudal(float a, float b) {
    velocity = new PVector(velocity.mag() * cos(velocity.heading()+a+b), velocity.mag() * sin(velocity.heading()+a+b));
  }

  float RightEye(PVector[] food) {
    float[] visability = new float[food.length];
    PVector distance;
    for (int i = 0; i < food.length; i++) {
      distance = PVector.sub(food[i], location);
      visability[i] = abs((velocity.heading() - (fov/2) - distance.heading()) * distance.mag());
    }
    stroke(100);
    //line(location.x, location.y, location.x + 10*cos(velocity.heading()), location.y + 10*sin(velocity.heading()));
    //line(location.x, location.y, location.x + 10*cos(velocity.heading()- radians(15)), location.y + 10*sin(velocity.heading() - radians(15)));
    return min(visability);
  }

  PVector getLocation() {
    return location;
  }

  float Ear(Creature[] fish) {
    float signal = 0;
    for (Creature f : fish) {
      PVector span = PVector.sub(f.getLocation(), location);
      if (span.mag() < 200) {
        signal += span.mag();
      }
    }
    return signal;
  }

  float LeftEye(PVector[] food) {
    float[] visability = new float[food.length];
    PVector distance;
    for (int i = 0; i < food.length; i++) {
      distance = PVector.sub(food[i], location);
      visability[i] = abs((velocity.heading() + (fov/2) - distance.heading() ) * distance.mag());
    }
    stroke(100);
    //line(location.x, location.y, location.x + 10*cos(velocity.heading() + radians(15)), location.y + 10*sin(velocity.heading() + radians(15)));
    return min(visability);
  }

  float Nose(PVector[] food) {
    float[] distance = new float[food.length];
    float scent = 0;
    for (int i = 0; i < food.length; i++) {
      distance[i] = pow((food[i].x - location.x), 2) + pow((food[i].y - location.y), 2);
      if (distance[i]<200) {
        scent++;
      }
    }
    return scent;
  }

  float Stomach() {
    return 1/(1+exp(-1*(Capacity-Contents))) - 0.5;
  }

  void Sense(PVector[] food, Creature[] fish) {
    sense[0] = LeftEye(food);
    sense[1] = RightEye(food);
    sense[2] = Nose(food);
    sense[3] = Ear(fish);

  }

  void Think() {
    float[] Action = brain.feedForward(sense);
    Act(Action);
  }

  void Act(float[] action) {
    ventral(action[3]);
    caudal(action[0],action[1]);
  }

  float getContents() {
    return Contents;
  }
 
  int Eat(PVector[] food) {
    PVector span;
    for (int i = 0; i < food.length; i++) {
      span = PVector.sub(food[i], location);
      if (span.mag() < r) {
        Contents+=5;
        return i+1;
      }
    }
    return 0;
  }

  void display() {
    if (!dead) {
      float theta = velocity.heading() - PI/2;
      if (dead) {
        fill(255, 0, 0);
      } else {
        fill(Color);
      }
      r = R;
      stroke(0);
      pushMatrix();
      translate(location.x, location.y);
      //text(Contents, 20, 20);
      rotate(theta);
      beginShape();
      vertex(0, r);
      vertex(r/2, 0);
      vertex(0, -r);
      vertex(r/3, -r-r/2);
      vertex(-r/3, -r-r/2);
      vertex(0, -r);
      vertex(-r/2, 0);
      endShape(CLOSE);
      popMatrix();
    }
  }
}