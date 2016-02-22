/*
  By Stewart Bracken, 2016
  See LICENCE.txt or LICENSE.md for licensing information
*/
float smoothstep(float v, float low, float high){
  if (v < low ){
    return 0f;
  }if (v > high){
    return 1f;
  }
  return map (v, low, high, 0f, 1f);
}

PVector[] vectorBuffer(int n){
  PVector[] buffer = new PVector[n];
  for (int i=0;i<n;++i){
    buffer[i] = new PVector();
  }
  return buffer;
}
float clamp (float v, float lo, float hi){
  return min(max(v,lo),hi);
}