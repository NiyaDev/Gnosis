
module gnosis;
import std::math;
import raylib5::rl;


/** Returns true when two floats are close to each by input amount
  @param f1
  @param f2
  @param amount "The amount to see if the difference is less than"
  @return "Whether the two floats are close enough"
  TODO: Move raylib over from Pleroma and add this to math functions
**/
fn bool close(float f1, float f2, float amount = 0.1) {
  return ((f1 + amount) > f2 && (f1 - amount) < f2);
}
/** Returns point rotated around self at distance
  @param self "Point to rotate around"
  @param dist "distance vector to point"
  @return "Distance rotated around point"
 **/
fn Vector3 Vector3.rotate(&self, Vector3 dist, float rot) {
  Vector3 position;

  position.x = dist.x * (float)math::cos(rot / 57.3) - dist.z * (float)math::sin(rot / 57.3);
  position.z = dist.x * (float)math::sin(rot / 57.3) + dist.z * (float)math::cos(rot / 57.3);

  position.x += self.x;
  position.y  = self.y + dist.y;
  position.z += self.z;

  return position;
}
/** Adds two Vector3s
 **/
fn Vector3 Vector3.add(&self, Vector3 v2) {
  self.x += v2.x;
  self.y += v2.y;
  self.z += v2.z;

  return *self;
}
/** Multiplies vector by float
 **/
fn Vector3 Vector3.mul_f(&self, float f1) {
  self.x *= f1;
  self.y *= f1;
  self.z *= f1;

  return *self;
}
/** Calculate length of Vector
 **/
fn float Vector3.length(&self) {
  return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
/** Normalize the Vector
 **/
fn Vector3 Vector3.normalize(&self) {
  float len = self.length();
  if (len != 0) {
    float ilen = self.length();

    return self.mul_f(ilen);
  } else { return *self; }
}
/** Clamp Vector to min and max values
 **/
fn Vector3 Vector3.clamp(&self, Vector3 max, Vector3 min) {
  return {
    .x = math::min(max.x, math::max(min.x, self.x)),
    .y = math::min(max.y, math::max(min.y, self.y)),
    .z = math::min(max.z, math::max(min.z, self.z)),
  };
}

