///scrUpdateBeeVelocity(beeInstance)

var beeInstance = argument0;

var targetMultiplier = 1.0;
var ballMultiplier = 4.0;
var avoidTeammateMultiplier = 10.0;
var avoidOpponentMultiplier = 1.0;
var randomMultiplier = 0.5;
var excitementMultiplier = 500.0;

var avoidTeammateDistance = 70;
var chaseBallDistance = 225;

with(beeInstance) {

  var beeX = x;
  var beeY = y;
  // Move current bee off screen so instance_nearest works correctly
  x = -10000;
  y = -10000;
  
  // Create temporary object to add motion info to
  var calculator = instance_create(x, y, objEmpty);
  
  // Add a little random velocity to keep it jiggling
  if(random(100) < 100) {
    with(calculator) {
      var randomDirection = irandom(360);
      var randomV = 1 * randomMultiplier;
      motion_add(randomDirection, randomV);
    }
  }
  
  // objTarget
  var target = instance_find(objTarget, 0);
  if(target != noone && point_distance(beeX, beeY, target.x, target.y) > 100){
    with(calculator) {
      var targetDirection = point_direction(beeX, beeY, target.x, target.y);
      var targetDistance = point_distance(beeX, beeY, target.x, target.y);
      var targetV = targetDistance * targetMultiplier;
      motion_add(targetDirection, targetV);
    }
  }
  
  // Nearest objBall 
  var nearestBall = instance_nearest(beeX, beeY, objBall);
  if(nearestBall != noone && point_distance(beeX, beeY, nearestBall.x, nearestBall.y) < chaseBallDistance) {
    with(calculator) {
      var nearestBallDirection = point_direction(beeX, beeY, nearestBall.x, nearestBall.y);
      var nearestBallDistance = point_distance(beeX, beeY, nearestBall.x, nearestBall.y);
      var nearestBallV = (chaseBallDistance - nearestBallDistance) * ballMultiplier + (beeInstance.excitement * excitementMultiplier);
      motion_add(nearestBallDirection, nearestBallV);
    }
  }
  
  // Avoid other bees
  var nearestBee = instance_nearest(beeX, beeY, objBee);
  if(nearestBee != self.id && point_distance(beeX, beeY, nearestBee.x, nearestBee.y) < avoidTeammateDistance) {
    with(calculator) {
      // Direction is reversed to get them moving away
      var nearestBeeDirection = point_direction(nearestBee.x, nearestBee.y, beeX, beeY);
      var nearestBeeDistance = point_distance(beeX, beeY, nearestBee.x, nearestBee.y);
      var nearestBeeV = (avoidTeammateDistance - nearestBeeDistance) * avoidTeammateMultiplier;
      motion_add(nearestBeeDirection, nearestBeeV);
    }
  }

  // Clamp delta
  calculator.speed = clamp(calculator.speed, 0, maxDeltaVelocity);
  
  // Add to current velocity
  motion_add(calculator.direction, calculator.speed);
  // Clean up temp velocity calculator
  with(calculator) {
    instance_destroy();
  }
  
  // Clamp velocity
  speed = clamp(speed, 0, maxVelocity);
  
  // Move bee back to original location
  x = beeX;
  y = beeY;
}
