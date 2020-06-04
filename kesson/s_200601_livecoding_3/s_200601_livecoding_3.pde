import peasy.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput in;
PeasyCam cam;

int tot = 60;
int totm = tot-1;
PVector[][] points = new PVector[tot][tot];

void setup() {
  size(1080, 1080, P3D);
  surface.setLocation(0, 0);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
  cam = new PeasyCam(this, 500);
}

void update() {
  float m1 = 8;
  float n11 = abs(cos(frameCount*0.0025)) + 0.1;
  float n12 = abs(sin(frameCount*0.00025)) + 0.1;
  float n13 = abs(cos(frameCount*0.0005)) + 0.1;

  float m2 = noise(frameCount*0.001) * 12;
  float n21 = (abs(sin(frameCount*0.0025)) + 0.1) * 100;
  float n22 = (abs(cos(frameCount*0.00025)) + 0.1) * 100;
  float n23 = (abs(cos(frameCount*0.00025)) + 0.1) * 100;

  for (int i = 0; i < tot; i++) {
    float theta = map(i, 0, totm, -PI, PI);

    float t11 = abs(cos(m1 * theta/4));
    t11 = pow(t11, n12);

    float t12 = abs(sin(m1 * theta/4));
    t12 = pow(t12, n13);

    float t13 = t11 + t12;
    float r1 = pow(t13, -1/n11);

    for (int j = 0; j < tot; j++) {
      float phi = map(j, 0, totm, -PI, PI);

      float t21 = abs(cos(m2 * phi/4));
      t21 = pow(t21, n22);

      float t22 = abs(sin(m2 * phi/4));
      t22 = pow(t22, n23);

      float t23 = t21 + t22;
      float r2 = pow(t23, -1/n21);


      float r = 400;
      float x = r * r1 * r2 * sin(theta) * cos(phi);
      float y = r * r1 * r2 * sin(theta) * sin(phi);
      float z = r * r2 * cos(theta);
      points[i][j] = new PVector(x, y, z);
    }
  }
}

void draw() {
  thread("update");
  background(0);

  cam.setDistance(1000 + abs(sin(frameCount*0.001)) * 500);
  cam.rotateY(0.002);

  blendMode(ADD);

  stroke(222, 50, 50, in.mix.level() * 200);
  noFill();
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < totm; i++) {
    for (int j = 0; j < tot; j++) {
      PVector p = points[i+1][j];
      PVector pp = points[i][j];
      fill(in.mix.get(i%1024) * 200);
      vertex(p.x, p.y, p.z);
      vertex(pp.x, pp.y, pp.z);
    }
  }
  endShape();
}

// Thanks for watching!!
