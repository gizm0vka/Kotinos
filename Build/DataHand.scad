/*USER INPUT*/
//input is in mm and degree 

/*Critical Parameters*/
  //pseudo metacarpal origin [x,y,z] translation in mm, extrapolate metacarpal to carpal wrist joint (set global origin as middle carpal base) 
  origin_thumb_carpal_base  =  [-25,-15,-15]; 
  origin_index_carpal_base  =  [-16,0,-2]; 
  origin_middle_carpal_base =  [0,0,0]; 
  origin_ring_carpal_base   =  [17,0,-3]; 
  origin_pinky_carpal_base  =  [31,0,-6];

  //Digit Lengths
  //Pseudo Metacarpal Length: Dorsal side base of wrist to knuckle, ignore carpals 
  length_thumb_metacarpal  = 53; //mm
  length_index_metacarpal  = 65; //mm
  length_middle_metacarpal = 70; //mm
  length_ring_metacarpal   = 68; //mm
  length_pinky_metacarpal  = 59; //mm

  //Proximal Phalanges Length: Dorsal side knuckle to proximal-middle interphalangeal joint  
  length_thumb_proximal  = 35; //mm
  length_index_proximal  = 47; //mm
  length_middle_proximal = 52; //mm
  length_ring_proximal   = 45; //mm
  length_pinky_proximal  = 36; //mm

  //Middle Phalanges Length: Dorsal side proximal to distal interphalangeal joint
  length_thumb_distal  = 29; //mm
  length_index_middle  = 28; //mm
  length_middle_middle = 31; //mm
  length_ring_middle   = 28; //mm
  length_pinky_middle  = 21; //mm

  //Proximal Phalanges Length: Dorsal side distal joint to the tip of finger 
  length_index_distal  = 23; //mm
  length_middle_distal = 24; //mm
  length_ring_distal   = 26; //mm
  length_pinky_distal  = 20; //mm

//Flexion Angles [pitch, roll, yaw] in degrees 
  //Thumb 
  thumb_metacarpal = [-14, -80, 42.75]; 
  thumb_proximal   = [-25, 0, 0];
  thumb_distal     = [-10, 0, 0];
  thumb_adduction  = [0,0,-22]; 

  //Index 
//  index_metacarpal = [ -1, 0, 3]; 
//  index_proximal   = [-24, 0, 6];
//  index_middle     = [-42, 0, 0];
//  index_distal     = [-25, 0, 0];
  index_metacarpal = [ -1, 0, 4]; 
  index_proximal   = [-37, 0, 6];
  index_middle     = [-25, 0, 0];
  index_distal     = [-16, 0, 0];
  //Middle 
  middle_metacarpal = [  0, 0, 0];
  middle_proximal   = [-40, 0, 0];
  middle_middle     = [-30, 5, 0];
  middle_distal     = [-13, 0, 0];
  //Ring
  ring_metacarpal = [ -2,  2,-5]; 
  ring_proximal   = [-30,  0, 1];
  ring_middle     = [-40,  5, 0];
  ring_distal     = [-15, 10, 0];
  //Pinky
  pinky_metacarpal = [ -6, 10,-10]; 
  pinky_proximal   = [-27,  0, -1];
  pinky_middle     = [-36,  5,  3];
  pinky_distal     = [-14, 10,  0];
  
/*END of Critical Parameters*/
         
// Cosmetic Params 
Finger_diam =  [ 
//meta, meta-prx joing, prx-mid, mid-dis //Finger thickness NOT WIDTH
    [39, 27, 16, 15, 0],//thumb
    [35, 25, 16, 11, 11],//ind
    [39, 26, 17, 12, 12],//mid
    [38, 25, 16, 12, 12],//ring
    [37, 21, 12, 9.5, 9.5],//pinkie
  ]/2;

Finger_width =  [ 
//meta, meta-prx joing, prx-mid, mid-dis tip //Finger thickness
    [27, 27, 16, 15, 0],//thumb
    [25, 25, 16, 11, 11],//ind
    [36, 20, 17, 12, 12],//mid
    [34, 21, 16, 12, 12],//ring
    [36, 17, 14, 12, 9.5],//pinkie
  ]/2;


Tip_thickness = [5,4,4,4,3]; //finger Tip thickness 
Tip_angle     = [60,60,55,50,60]; //finger tip face angle 
WebRatio=[.75, 0.6, 0.6, 0.5, 0.5];  //amount forward from meta prox joint used on finger webbing
fingerScale = 1.2; //Account for thickness to witch ratio, more for aethetics 


// Palmer blob  width  in mm
  pinkiePalmWid =32/2; 
  pinkiePalmHgt =28/2; 
  ringPalmWid = 10;
  ringPalmLen = 25; 
  midPalmWid = 10;
  midPalmLen = 17;

//Matrix struct for loopign  
Len_hand   =   [ // joint to joint lenght in mm  (NOTE: Dorsal side measurment)
                [length_thumb_metacarpal, length_thumb_proximal, length_thumb_distal,  0],//thumb
                [length_index_metacarpal, length_index_proximal, length_index_middle, length_index_distal],//ind
                [length_middle_metacarpal,length_middle_proximal,length_middle_middle,length_middle_distal],//mid
                [length_ring_metacarpal,  length_ring_proximal,  length_ring_middle,  length_ring_distal],//ring
                [length_pinky_metacarpal, length_pinky_proximal, length_pinky_middle, length_pinky_distal],//pinkie
               ];

NeutralHandFlexion = [
                      [ thumb_metacarpal,  thumb_proximal,  thumb_distal, thumb_adduction],  //last slot used as Thumb radial adduction data
                      [ index_metacarpal,  index_proximal,  index_middle,    index_distal], 
                      [middle_metacarpal, middle_proximal, middle_middle,   middle_distal], 
                      [  ring_metacarpal,   ring_proximal,   ring_middle,     ring_distal], 
                      [ pinky_metacarpal,  pinky_proximal,  pinky_middle,    pinky_distal]
                     ];

GripHandFlexion = [
                      [ thumb_metacarpal+[18,-3,0],  thumb_proximal-[22,0,0],  thumb_distal-[33,0,0], thumb_adduction+[0,0,-3]],  //last slot used as Thumb radial adduction data
                      [ index_metacarpal+[3,0,0],  index_proximal+[0,0,7],  index_middle-[25,0,0],    index_distal-[25/2,0,0]], 
                      [middle_metacarpal+[2,0,0], middle_proximal+[0,0,-2], middle_middle-[25,0,0],   middle_distal-[25/2,0,0]], 
                      [  ring_metacarpal+[2,0,0],   ring_proximal+[3,0, 1],   ring_middle-[29,0,0],     ring_distal-[29/2,0,0]], 
                      [ pinky_metacarpal+[3,0,0],  pinky_proximal-[1,0, 2],  pinky_middle-[30,0,0],    pinky_distal-[30/2,0,0]]
                     ];
                     
W_hand = [origin_thumb_carpal_base, 
          origin_index_carpal_base, 
          origin_middle_carpal_base, 
          origin_ring_carpal_base,
          origin_pinky_carpal_base
         ];  

/*---------------------------------- Builds check--------------------------*/
//include <BOSL2/std.scad>
//include <HandGenerator.scad>
//color("gold", alpha=.5)HandsOn(meat= false, GripHandFlexion);
//HandsOn(meat= false, NeutralHandFlexion);