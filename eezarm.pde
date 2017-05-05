#include <Servo.h>

/*
  servos indexed:
  gripperServo = 0
  rotationServo = 1
  shoulderServo = 2
  elbowServo = 3
*/
Servo servos[4];
int servoPins[] = {0,1,2,3};

// target angles for servos
int targets[] = {0,0,0,0};

// how many degrees per second to go towards target
int speed = 1;

void moveServos()
{
  int step, current, target;

  for(int i = 0; i < 4; i++)
    {
      current = servos[i].read();
      int target;

      if(current<target)
        {
          target = (current-target < speed)
            ? current-target
            : speed;
        }
      else
        {
          target = (target-current < speed)
            ? target-current
            : -speed;
        }
      servos[i].write(step);
    }
}

boolean done()
{
  for(int i = 0; i < 4; i++)
    {
      if(targets[i] != servos[i].read()) {return false;};
    }

  return true;
}

void setup() 
{
  for(int i = 0; i < 4; i++)
    {
      servos[i].attach(servoPins[i]);
    }
  
} 

void loop() 
{
  if(done())
    {
      for(int i = 0; i < 4; i++)
        {
          targets[i] = (targets[i] + 180) % 180;
        }
    }
  moveServos();
}
