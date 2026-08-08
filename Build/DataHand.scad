/*USER INPUT*/
//input is in mm and degree 

/*Critical Parameters*/
  //pseudo metacarpal origin [x,y,z] translation in mm, extrapolate metacarpal to carpal wrist joint (set global origin as middle carpal base) 
  origin_thumb_carpal_base  =  [-50,-2,-23]; 
  origin_index_carpal_base  =  [-24,0,-2.7]; 
  origin_middle_carpal_base =  [0,0,0]; 
  origin_ring_carpal_base   =  [15,0,-3]; 
  origin_pinky_carpal_base  =  [25.17,0,-6];

  //Digit Lengths
  //Pseudo Metacarpal Length: Dorsal side base of wrist to knuckle, ignore carpals 
  length_thumb_metacarpal  = 54; //mm
  length_index_metacarpal  = 80.74; //mm
  length_middle_metacarpal = 84.51; //mm
  length_ring_metacarpal   = 83; //mm
  length_pinky_metacarpal  = 67; //mm

  //Proximal Phalanges Length: Dorsal side knuckle to proximal-middle interphalangeal joint  
  length_thumb_proximal  = 38.51; //mm
  length_index_proximal  = 56.04; //mm
  length_middle_proximal = 61.30; //mm
  length_ring_proximal   = 56.43; //mm
  length_pinky_proximal  = 46.66; //mm

  //Middle Phalanges Length: Dorsal side proximal to distal interphalangeal joint
  length_thumb_distal  = 33.33; //mm
  length_index_middle  = 34.11; //mm
  length_middle_middle = 37.92; //mm
  length_ring_middle   = 37.9; //mm
  length_pinky_middle  = 27.96; //mm

  //Proximal Phalanges Length: Dorsal side distal joint to the tip of finger 
  length_index_distal  = 23.69; //mm
  length_middle_distal = 29.02; //mm
  length_ring_distal   = 25.78; //mm
  length_pinky_distal  = 22.31; //mm

//Flexion Angles [pitch, roll, yaw] in degrees 
  //Thumb 
  thumb_metacarpal = [-14, -100, 42.75]; 
  thumb_proximal   = [-15, 0, 0];
  thumb_distal     = [-15, 0, 0];
  thumb_adduction  = [0,0,-30]; 

    adj = 10;
    roll_adj = -5;

  //Index 
//  index_metacarpal = [ -1, 0, 3]; 
//  index_proximal   = [-24, 0, 6];
//  index_middle     = [-35, 0, 0];
//  index_distal     = [-20, 0, 0];
  index_metacarpal = [ -2, 0, 6]; 
  index_proximal   = [-30, -8, 5];
  index_middle     = [-35+adj, 5+roll_adj, 0];
  index_distal     = [-25, 10, 0];
  //Middle 
  middle_metacarpal = [  0, 3, 1];
  middle_proximal   = [-40, 0, 2];
  middle_middle     = [-25+adj, 5+roll_adj, 0];
  middle_distal     = [-20, 10, 0];
  //Ring
  ring_metacarpal = [ -3,  5, -5]; 
  ring_proximal   = [-24,  3, 0];
  ring_middle     = [-35,  15-adj, 0];
  ring_distal     = [-40, 20-adj, 0];
  //Pinky
  pinky_metacarpal = [ -11, 0,-10]; 
  pinky_proximal   = [-18,  0, -1];
  pinky_middle     = [-10,  5,  3];
  pinky_distal     = [-5, 10,  0];
  
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


