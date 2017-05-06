#include <Servo.h>

/*
  servos indexed:
  gripperServo = 0
  rotationServo = 1
  shoulderServo = 2
  elbowServo = 3
*/
Servo servos[4];
int servoPins[] = {3,5,6,9};

// target angles for servos
int targets[] = {0,0,0,0};

// current servo state
int state[] = {0,0,0,0};

// how many degrees per second to go towards target
int speed = 5;

int joyPins[] = {5,4,3,2};
int instructions[] = {0,0,0,0};
int joyThreshold = 200;

void goTo(int a, int b, int c, int d)
{
  targets[0] = a;
  targets[1] = b;
  targets[2] = c;
  targets[3] = d;

  readState();
  while(!done())
    {
      readState();
      moveServos();
      delay(20);
    }
}

void typeChar(char c) {
  Serial.write("Typing char: ");
  Serial.print(c);
  Serial.write("\n");
  
  switch(c) {
  case 'h':
    goTo(71, 36, 44, 160);
    break;
  case 'e':
    goTo(49, 30, 42, 160);
    break;
  case 'l': goTo(98, 38, 44, 170);
    break;
  case 'o': goTo(94, 32, 42, 180);
    break;
  case '~': goTo(81, 46, 14, 168);
    break;
  }

  delay(500);
}


void gamepad()
{
  int val;
  for(int i; i < 4; i++)
    {
      val = analogRead(joyPins[i]);
      if(val-512 < -joyThreshold) { instructions[i] = -1; }
      else if(val-512 > joyThreshold) { instructions[i] = 1; }
      else { instructions[i] = 0; }

      /* Serial.print(i); */
      /* Serial.write(": "); */
      /* Serial.print(instructions[i]); */
      /* Serial.write(" "); */
      /* Serial.print(val); */
    }
   /* Serial.write("\n"); */
}




void moveServos()
{
  int step, current, target;

  for(int i = 0; i < 4; i++)
    {
      current = servos[i].read();
      target = targets[i];

      if(current<target)
        {
          step = (target-current < speed)
            ? target-current
            : speed;
        }
      else
        {
          step = (current-target < speed)
            ? current-target
            : -speed;
        }
      Serial.write("current: ");
      Serial.print(current);
      Serial.write(" target: ");
      Serial.print(target);
      Serial.write(" moving: ");
      Serial.print(step);
      Serial.write("\n");
      servos[i].write(current+step);
    }
}

void readState()
{
  for(int i = 0; i < 4; i++)
    {
      state[i] = servos[i].read();
    }
}

boolean done()
{
  for(int i = 0; i < 4; i++)
    {
      if(targets[i] != state[i]) {return false;};
    }
  Serial.write("done!\n");

  return true;
}

void setup() 
{
  for(int i = 0; i < 4; i++)
    {
      servos[i].attach(servoPins[i]);
    }
  Serial.begin(9600);

  delay(1000);
  
  typeChar('~');
  typeChar('h');
  typeChar('~');
  typeChar('e');
  typeChar('~');
  typeChar('l');
  typeChar('~');
  typeChar('l');
  typeChar('~');
  typeChar('o');
  typeChar('~');
  
} 

void loop() 
{
  readState();
  gamepad();

  /* Serial.print(state[1]); */
  /* Serial.write("\n"); */

  for(int i = 0; i < 4; i++)
    {
      if(instructions[i] != 0)
        {
          /* Serial.write("\n"); */
          /* Serial.print(i); */
          /* Serial.write(": "); */
          /* Serial.print(servos[i].read()); */
          
          servos[i].write(servos[i].read()+2*instructions[i]);
          delay(25);
        }
    }

  /* for(int i = 0; i < 4; i++) */
  /*   { */
  /*     Serial.write(" "); */
  /*     Serial.print(i); */
  /*     Serial.write(": "); */
  /*     Serial.print(servos[i].read()); */
  /*   } */
  /* Serial.write("\n"); */

  delay(10);
  

  /* readState(); */
  
  /* //Serial.write("\ndone: "); */
  /* //Serial.print(done()); */
  

  /* if(done()) */
  /*   { */
  /*     /\* for(int i = 0; i < 4; i++) *\/ */
  /*     /\*   { *\/ */
  /*     /\*     targets[i] = (targets[i] + 5) % 180; *\/ */
  /*     /\*   } *\/ */
  /*   } */
  /* moveServos(); */
}
