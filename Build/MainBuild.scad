/*  
  Kotinos
*/ 
include <HSK_PCB.scad>
include <HandGenerator.scad>
include <PaddleSurfaceGenerator.scad>

include <DataHand.scad>
include <DataPinkyPaddle.scad>
include <DataRingPaddle.scad>
include <DataThumbPaddle.scad>
include <DataIndexPaddle.scad>

/*---------------------------------- Variables --------------------------*/
// hand orientation and placement 
wrist_tent = 21; //angle wrist pronation  
wrist_tilt = 23; //angle wrist flexion 
wrist_height =15.0; // wrist height 
hand_origin = mean([PinkieBlobVec (res*.5, 0, NeutralHandFlexion),PinkieBlobVec (res*.5, 180, NeutralHandFlexion, buffer=0)]); //define origin ulna joint (or there-about)

//Sensor PCB placement 
sensor_origin= [-48, 90, 6.5]; //mm
sensor_angle= 4; //in deg

//index PCB placement
index_origin = [11,-12.25,-11.75]; //mm
index_angle = [37,3,7.0]; //deg
index_adjust = [0,0,-3]; //height adjustment in mm
module indexOrigin (shift=[0,0,0]) {rot(index_angle)move(index_origin+shift)children();}

//thumb PCB placement 
module thumbButtonUpper () {xrot(19)zrot(2)down(15.5)back(-8)left(-4.)children();} //thumb bottoms for upper placement 
module thumbButtonLower () {yrot(35)xrot(15)zrot(2)down(17.)back(-8)left(-.75)zrot(190)children();} //thumb bottom for lower placement 

//Paddle joint placement 
joint_radius= 1.1;  //mm

//joint placement on paddles param: fraction of x and y of bezier surface coordinates and depth adjustment in mm
module thumbPaddleSupportFront () PaddleMountPlacer(0.55, 0.05, 1.25, thu, mid, thumb_patch)sphere(joint_radius);
module thumbPaddleSupportBack ()  PaddleMountPlacer(0.40, 0.90, 1.25, thu, mid, thumb_patch)sphere(joint_radius);
module thumbPaddleSupportTop ()   PaddleMountPlacer(0.05, 0.50, 1., thu, mid, thumb_patch)sphere(joint_radius);

module ringPaddleSupportBack ()   PaddleMountPlacer(0.1, 0.95, 1.75, rng, dis, RingPatch)sphere(joint_radius);
module ringPaddleSupportTop ()    PaddleMountPlacer(0.75, 0.80, 1.75, rng, dis, RingPatch)sphere(joint_radius);
module ringPaddleSupportCen ()    PaddleMountPlacer(0.5, 0.5, 1.5, rng, dis, RingPatch)sphere(joint_radius);
module ringPaddleSupportFront ()  PaddleMountPlacer(0.9, 0.1, 1.8, rng, dis, RingPatch)sphere(joint_radius);

module pinkyPaddleSupportTop ()    PaddleMountPlacer(0.70, 0.80, 1.75, pnk, dis, PinkyPatch)sphere(joint_radius);  
module pinkyPaddleSupportCen ()    PaddleMountPlacer(0.5, 0.5, 1.75, pnk, dis, PinkyPatch)sphere(joint_radius);  
module pinkyPaddleSupportBack ()   PaddleMountPlacer(0.4, 0.95, 1.75, pnk, dis, PinkyPatch)sphere(joint_radius);  
module pinkyPaddleSupportBottom () PaddleMountPlacer(.98, 0.05, 2.75, pnk, dis, PinkyPatch)sphere(joint_radius);

//Position of Sensor PCB mount
module indexPaddleMount ()   indexOrigin(index_adjust+[0,0,-2.5])move([-15.5,-20,10.6])sphere(joint_radius);
module middlePaddleMount ()     indexOrigin(index_adjust+[0,0,-4.5])move([13.5,-20,10.])sphere(joint_radius);

// skate placement (mm)
thumb_skate  = [-72,49,joint_radius+.5];
indthumb_skate  = [-82,78,joint_radius+.5];
index_stake = [-72,99,joint_radius+.5];
middle_skate = [-45,107,joint_radius+.5];
palm_skate = [-(72-7.2)/2,50,joint_radius+.5];

vector_to_ring_tip = let(i=rng)PlaceOnVec(finger=i, phalange = dis, A_hand= NeutralHandFlexion, vec = [-5,-5,-Finger_diam[i][dis]*2-.2]);
vector_to_pinky_tip = let(i=pnk)PlaceOnVec(finger=i, phalange = dis, A_hand= NeutralHandFlexion, vec = [-4,-4,-Finger_diam[i][dis]*2+.15]);
function vector_to_origin(v) = move([0,0,wrist_height], p= rot([wrist_tilt,wrist_tent,0], p= -hand_origin+v)); 

function ring_skate (v=[0,0,0]) =[vector_to_origin(vector_to_ring_tip)[0],vector_to_origin(vector_to_ring_tip)[1],0]+v+[1.5,-2.25,0];
function pinky_skate (v=[0,0,0]) =[vector_to_origin(vector_to_pinky_tip)[0],vector_to_origin(vector_to_pinky_tip)[1],0]+v+[8.5,-4.,0];

 /*---------------------------------- Builds --------------------------*/
$fn=32; //number of segments on curves, set lower for faster render, higher for more res

BuildSupport();
BuildThumb(cut= ($preview ? false : true));
BuildRing(cut= ($preview ? false : true));
BuildPinky(cut= ($preview ? false : true));
%HSK_PCBS();
%BuildIndexPaddles();
//%back(23)down(0)right(1)mouseOrigin()color("gold", alpha=.5)let(A_hand = GripHandFlexion)HandsOn(meat= true, A_hand); //hand reference at flexed position 
//%mouseOrigin()let(A_hand = NeutralHandFlexion)HandsOn(meat= true, A_hand = A_hand); //hand reference at neutral 

module BuildSupport () {
   color("blue", alpha=1)SupportJointThumb();
   color("teal", alpha=1)SupportJointIndexPCB();
   color("red", alpha=1)SupportJointIndexPaddle();
   color("snow", alpha=1)SupportJointSensorMount();
   color("gold", alpha=.5)SupportJointGround();
   color("Green", alpha=1)SupportJointRingPinky();
}

/*---------------------------------- Modules --------------------------*/

module mouseOrigin () {translate([0,0,wrist_height])rotate([wrist_tilt,wrist_tent,0]) //Set hand orientation 
translate(-hand_origin+[0,0,0])children();} 

module v_ind () { let(i=ind)PlaceOn(finger=i, phalange = dis, A_hand = NeutralHandFlexion)children();}

//PCB mounting and placements
module HSK_PCBS () { //place HSK PCBs 
  mouseOrigin(){
     PlaceOn(finger= ind, phalange = dis, A_hand = NeutralHandFlexion)indexOrigin(index_adjust+[0,0,1])hsk_index();
     PlaceOn(finger= thu, phalange = mid, A_hand = NeutralHandFlexion)thumbButtonLower()hsk_thumb_PCB();
  }
  move(sensor_origin)zrot(sensor_angle)hsk_main();
}

function sensorPCBMountRight (h=0) = move(sensor_origin, p= zrot(sensor_angle, p=[-39/2+22.25+1.25,   -26/2, 3+h]));
function sensorPCBMountLeft (h=0) = move(sensor_origin, p= zrot(sensor_angle, p=[   -39/2+2.5/2+1, 18.5-13, 3+h]));  

 module thumbPCBMount () { 
    move([6.35,-4.75,4.0])prismoid(size1=[2,3], size2=[2,3], shift=[0,0], h=1.75);
//    #move([6.35,-4.75,5.75])prismoid(size1=[2,3], size2=[1,3], shift=[.5,0], h=1.2);
    move([3.75,5.25,4.0])prismoid(size1=[2,3], size2=[2,3], shift=[0,0], h=1.); 
    
    move([-5.25,-7.25+2.25,3.25])cube([2,4,7.5],center=true);
    difference(){
      color("yellow"){
        move([-12.5/2+2.5,  18.5/2-2, 2.55+1.6/2])cyl(r=1.5, rounding2=0, 4.1+1.6);
        move([  -12.5/2+4, -18.5/2+4, 2.375+1.6/2])cyl(r=1.5, rounding2=0, 3.75+1.6);
      }
      move([-12.5/2+2.5,  18.5/2-2, 2.6])cyl(r=.75, 4.2);
      move([  -12.5/2+4, -18.5/2+4, 2.5])cyl(r=.75, 4);
      move([-12.5/2+4.75+3.25,5.25,2])xrot(-90)yrot(90)cube([4.5,3,9.25],center=true);
    }    
    difference(){
      move([6.75,.25,4.0]){ 
        color("yellow")left(4.125)up(.5)prismoid(size1=[10.75,1], size2=[1.75,1], shift=[-4.5,0], h=.75);
        left(3.5)down(2)prismoid(size1=[9.75,3.], size2=[9.75,1], shift=[0,0], h=2.5); 
        left(3.5)down(3.5)prismoid(size1=[9.75,3], size2=[9.75,3], shift=[-0,0], h=1.5); 
        
        color("red")left(8.5)back(-1.75)down(-.5)prismoid(size1=[2.,4.5], size2=[2.,4.5], shift=[0,-0], h=1); 
        color("blue")left(8.5)down(2)prismoid(size1=[2,3.], size2=[2,1], shift=[0,0], h=2.5); 
        color("blue")left(8)down(3.5)prismoid(size1=[1.,3.], size2=[2,3], shift=[-.5,0], h=1.5); 
      }
      move([6.5,.2,2])cyl(r=.75, 3);
    }
}

// Paddle Design   
module BuildThumb (cut=false, orientation="lower") {
  difference(){
    let(i=thu)mouseOrigin()PlaceOn(finger= thu, phalange = mid, A_hand = NeutralHandFlexion)down(Finger_diam[i][dis]*2)back(-5)
        PatchPaddle(Patch = thumb_patch, debug=false);
    if(cut == true){
      if(orientation == "lower"){
        mouseOrigin()let(i=thu)
          PlaceOn(finger= i, phalange = mid, A_hand = NeutralHandFlexion)down(Finger_diam[i][dis]*2){
            rot([20, 0, 2.25]){
              move([-10,-12,5])down(5)yrot(30)linear_extrude(11)right(1.90)zrot(0)rect([.75,16.],rounding=[0.25,0.25,-3.25,-4.25]);
              move([-11.75,5.7,5])down(5)yrot(30)linear_extrude(11)right(1.90)zrot(0)rect([.75,16.],rounding=[-4.25,-3.25,.25,.25]);
              
              down(5)yrot(30)move([-17.25,-1.75,2])linear_extrude(11){
                fwd(2.25)right(4.45)zrot(90)rect([2,1],rounding=[-1,0,0,.0]);
                fwd(2.5)right(.85+.35-.25-.125)zrot(90)rect([2.5,7+2.75],rounding=[0,-1.5,.75,.75]);
//                right(.85+.35)fwd(.25)zrot(90)rect([2.,5.5],rounding=[-2,-0,0,.75]);
                right(.85+.35-1.25)fwd(.25)zrot(90)rect([2.,5.5+2.5],rounding=[-1,-0,0,.75]);
//              #down(5)yrot(30)move([-17.25,-1.75,2])linear_extrude(11){
//                fwd(2.25)right(4.45)zrot(90)rect([2,1],rounding=[-1,0,0,.0]);
//                fwd(2.5)right(.85+.35+1.)zrot(90)rect([2.5,7],rounding=[0,-4,.75,.75]);
//                right(.85+.35)fwd(.25)zrot(90)rect([2.,5.5],rounding=[-2,-0,0,.75]);
            }
          }
        }
      }
      else {    //for upper switch orientation           
        rot([20,0,2.25]){
          move([3.25,-12,5])down(5)linear_extrude(11)right(1.90)zrot(-0)rect([.75,16.],rounding=[0.25,0.25,-3.25,-4.25]);
          move([1.75,5.7,5])down(5)linear_extrude(11)right(1.90)zrot(-0)rect([.75,16.],rounding=[-4.25,-3.25,.25,.25]);

          move([4.75,-1,5])down(5)linear_extrude(11)right(1.90)zrot(-90)rect([3,1.5],rounding=[-1,0,.5,.5]);
          move([8.7,-1,5])down(5)linear_extrude(11)right(1.90)zrot(-90)rect([3,6.5],rounding=[0,-2,0,0]);
          move([8.75,-3.5,5])down(5)linear_extrude(11)right(1.90)zrot(-90)rect([3,6.5],rounding=[-2,0,.0,.75]);
        }
      }
    }
  }
  mouseOrigin()PlaceOn(finger= thu, phalange = mid, A_hand = NeutralHandFlexion)thumbButtonLower()thumbPCBMount();
}

module BuildRing (cut=false, rend=false, debug=false) {
  clearance = 1; //mm

  difference(){
    let(i=rng)mouseOrigin()PlaceOn(finger= i, phalange = dis, A_hand = NeutralHandFlexion)down(Finger_diam[i][dis]*2)back(-5)
        PatchPaddle(Patch = RingPatch, debug=debug);
    if(cut == true)
      down(5-clearance)cube([200,250,10],center=true);
  }
}

module BuildPinky (cut=false, rend=false, debug= false) {
  clearance = 1; //mm

  difference(){
    let(i=pnk)mouseOrigin()PlaceOn(finger= i, phalange = dis, A_hand = NeutralHandFlexion)down(Finger_diam[i][dis]*2)back(-5)
      PatchPaddle(PinkyPatch, debug=debug);
    if(cut == true)
      down(10-clearance)cube([200,250,20],center=true);
  }
}

module BuildIndexPaddles () {
//  index = [-15.5,1,10.6];
//  middle = [13.5,1,10.6]; 
  mouseOrigin(){
    let(i=ind)PlaceOn(finger= i, phalange = dis,  A_hand = NeutralHandFlexion){
      indexOrigin(index_adjust+[0,0,.5])left(0)fwd(0)IndexDeepPaddle(cut = ($preview ? false : true)); //mid 
      indexOrigin(index_adjust)left(2)fwd(0)xflip()MidPaddle(); //mid;
    }
  }
}

// skeleton joints 

module SupportJointThumb () {

  module thumbBottom() {
    mouseOrigin()PlaceOn(finger= thu, phalange = mid, A_hand = NeutralHandFlexion)thumbButtonLower()
      move([8.25+joint_radius,.25,4.-5])children();
  }
  module thumbBottom2() {
    mouseOrigin()PlaceOn(finger= thu, phalange = mid, A_hand = NeutralHandFlexion)thumbButtonLower()right(joint_radius)children();
  } 

  let(h=-4.5){
    hull(){move(index_stake)sphere(joint_radius); thumbPaddleSupportFront();}
    hull(){move(indthumb_skate)sphere(joint_radius); thumbPaddleSupportFront();}
    hull(){move(thumb_skate)sphere(joint_radius);thumbBottom()sphere(joint_radius);}
    hull(){move(indthumb_skate)sphere(joint_radius);thumbBottom()sphere(joint_radius);}
    hull(){thumbBottom()sphere(joint_radius);
           thumbBottom2()move([10.55,.25,4.0]){ 
             left(3.5)down(2)prismoid(size1=[.05,3.], size2=[.05,1], shift=[0,0], h=2.5); 
             left(3.5)down(3.5)prismoid(size1=[.05,3], size2=[.05,3], shift=[-0,0], h=1.5); 
           }} 

    hull(){thumbPaddleSupportBack(); move(palm_skate)sphere(joint_radius);}
    hull(){thumbPaddleSupportBack(); move(thumb_skate)sphere(joint_radius);}
  } 
}

module indexPCBMount (quad=0, u=0) { 
  indexOrigin(index_adjust){ //
    if(quad==0)translate([-8,(20-2.5)/2,u])children(); 
    else if(quad==1)translate([ 8,(20-2.5)/2,u])children(); 
    else if(quad==2)translate([-8.5,-(20-2.5)/2,u])children(); 
    else if(quad==3)translate([ 8.5,-(20-2.5)/2,u])children(); 
    else if(quad==4)translate([-11,-0,u])children(); 
    else if(quad==5)translate([ 11, 0,u])children(); 
    else if(quad==6)translate([ 0,-18,u])children(); 
  }
}

module SupportJointIndexPCB () {
  //sub module for mount placement
      
  //build Index side 
  difference(){
    union(){
      hull()mouseOrigin(){v_ind()indexPCBMount(quad=4, u=-4)sphere(joint_radius); v_ind()indexPCBMount(quad=2, u=-joint_radius)sphere(joint_radius); }
      hull()mouseOrigin(){v_ind()indexPCBMount(quad=4, u=-4)sphere(joint_radius); v_ind()indexPCBMount(quad=0, u=-joint_radius)sphere(joint_radius); }
      hull(){mouseOrigin()v_ind()indexPCBMount(quad=4, u=-4)sphere(joint_radius);move(indthumb_skate)sphere(joint_radius);}
     
      hull(){mouseOrigin()v_ind()indexPCBMount(quad=0, u=-joint_radius)sphere(joint_radius); move(index_stake)sphere(joint_radius);}   
      hull(){mouseOrigin()v_ind()indexPCBMount(quad=4, u=-4)sphere(joint_radius); thumbPaddleSupportFront();}   
      
      mouseOrigin()v_ind(){
        let(d=2.5, h=2, r=0)indexPCBMount(quad=0, u=.5)cyl(d=d,h,rounding2= r);
        let(d=2.5, h=2, r=0)indexPCBMount(quad=2, u=.5)cyl(d=d,h,rounding2= r);

        let(d=joint_radius*2+1, h=.5, r=0)indexPCBMount(quad=0, u=.25)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2+1, h=.5, r=0)indexPCBMount(quad=2, u=.25)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2, h=1.25, r=-.5)indexPCBMount(quad=0, u=-joint_radius+1.25/2)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2, h=1.25, r=-.5)indexPCBMount(quad=2, u=-joint_radius+1.25/2)cyl(d=d,h,rounding2= r);
     }
    }
    
    mouseOrigin()v_ind(){
      let(d=1.25, h=6, r=0)indexPCBMount(quad=0,u=0)cyl(d=d,h,rounding2= r);
      let(d=1.25, h=6, r=0)indexPCBMount(quad=2,u=0)cyl(d=d,h,rounding2= r);
    }
  }
  //build mid side 
  difference(){
    union(){  
     hull()mouseOrigin(){v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius); v_ind()indexPCBMount(quad=3, u=-joint_radius)sphere(joint_radius); }
     hull()mouseOrigin(){v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius); v_ind()indexPCBMount(quad=1, u=-joint_radius)sphere(joint_radius); }

     hull(){move(middle_skate)sphere(joint_radius); mouseOrigin()v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius); }
     
     hull(){mouseOrigin()v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius); move(index_stake)sphere(joint_radius);}
     hull(){mouseOrigin()v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius); move(ring_skate([0,0,joint_radius+.5]))sphere(joint_radius);}
     hull()mouseOrigin()v_ind(){indexPCBMount(quad=3, u=-joint_radius)sphere(joint_radius); indexPCBMount(quad=3, u=-joint_radius)fwd(3)sphere(joint_radius); }
     //hull(){move(thumb_skate)sphere(joint_radius); mouseOrigin()v_ind()indexPCBMount(quad=5, u=-2.5)sphere(joint_radius);}   


//     #hull(){mouseOrigin()v_ind()indexPCBMount(quad=1, u=-joint_radius-3)sphere(joint_radius); move(index_stake)sphere(joint_radius);}   

     mouseOrigin()v_ind(){
        let(d=2.5, h=2, r=0)indexPCBMount(quad=1, u=.5)cyl(d=d,h,rounding2= r);
        let(d=2.5, h=2, r=0)indexPCBMount(quad=3, u=.5)cyl(d=d,h,rounding2= r);

        let(d=joint_radius*2+1, h=.5,   r=0)indexPCBMount(quad=1, u=.25)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2+1, h=.5,   r=0)indexPCBMount(quad=3, u=.25)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2, h=1.25, r=-.5)indexPCBMount(quad=1, u=-joint_radius+1.25/2)cyl(d=d,h,rounding2= r);
        let(d=joint_radius*2, h=1.25, r=-.5)indexPCBMount(quad=3, u=-joint_radius+1.25/2)cyl(d=d,h,rounding2= r);
     }
    }
    
    mouseOrigin()v_ind(){
      let(d=1.25, h=6, r=0)indexPCBMount(quad=1, u=0)cyl(d=d,h,rounding2= r);
      let(d=1.25, h=6, r=0)indexPCBMount(quad=3, u=0)cyl(d=d,h,rounding2= r);
    }
  }

}

module SupportJointSensorMount () {
    hull(){move(sensorPCBMountRight(3))sphere(joint_radius); thumbPaddleSupportBack();}
    hull(){move(sensorPCBMountRight(3))sphere(joint_radius); move(palm_skate)sphere(joint_radius);}
    
    hull(){move(sensorPCBMountLeft(1))sphere(joint_radius);move(sensorPCBMountLeft(1)+[-5,0,0])sphere(joint_radius);}
    hull(){move(sensorPCBMountLeft(1)+[-5,0,0])sphere(joint_radius);thumbPaddleSupportFront();}
    hull(){move(sensorPCBMountLeft(1))sphere(joint_radius); move(sensorPCBMountRight(3))sphere(joint_radius);}

    difference(){
      union(){
        move(sensorPCBMountRight(-1.75))cyl(r=joint_radius*2, rounding2=.25 ,1.5 );
        move(sensorPCBMountRight(1.25))cyl(r1=joint_radius+.7,  r2=joint_radius,rounding1=-.25,rounding2=.75, 4.5);
      }
        move(sensorPCBMountRight(-1.5))cyl(d=1.25,2.1); //hole
    }
    
    difference(){
      union(){
        move(sensorPCBMountLeft(-1.75))cyl(r=joint_radius*2, rounding2=.25 ,1.5 );
        move(sensorPCBMountLeft(.5))cyl(r1=joint_radius+.7,  r2=joint_radius+.5,rounding1=-.25, rounding2=.75, 3);
      }
        move(sensorPCBMountLeft(-1.5))cyl(d=1.25,2.1); //hole
    }
 }

module SupportJointGround () {

  hull(){move(thumb_skate)sphere(joint_radius); move(palm_skate)sphere(joint_radius);}   
  hull(){move(thumb_skate)sphere(joint_radius); move(indthumb_skate)sphere(joint_radius);}   
  hull(){move(index_stake)sphere(joint_radius); move(indthumb_skate)sphere(joint_radius);}   
  hull(){move(index_stake)sphere(joint_radius); move(middle_skate)sphere(joint_radius);}    
  hull(){move(ring_skate([0,0,joint_radius+.5]))sphere(joint_radius); move(middle_skate)sphere(joint_radius);}   
  hull(){move(pinky_skate([-1,-1,joint_radius+.5]))sphere(joint_radius); move(palm_skate)sphere(joint_radius);}   
  hull(){move(ring_skate([0,0,joint_radius+.5]))sphere(joint_radius); move(pinky_skate([-1,-1,joint_radius+.5]))sphere(joint_radius);}   

   adjust = -.125;
   h1 = joint_radius+.5-.375+ adjust;
   h2 = joint_radius/2+.25-.5; 
   module feet (d=7) {cyl(d=d,rounding=.2,1);}
   
   down(h1){
     move(thumb_skate)feet(7.5);
     move(index_stake)feet(7.5);
     move(middle_skate)feet(7.5);
     move(ring_skate([0,0,joint_radius+.5]))feet(7.5);
     move(palm_skate)feet(7.5);
     move(indthumb_skate)feet(7.5);
     move(pinky_skate([-.0,-.0,joint_radius+.5]))feet(7.5);
   }

   down(h2){
     move(thumb_skate)cyl(d=joint_radius*2, rounding1=-.5, joint_radius+.5-1);
     move(index_stake)cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
     move(middle_skate)cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
     move(ring_skate([0,0,joint_radius+.5]))cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
     move(palm_skate)cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
     move(indthumb_skate)cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
     move(pinky_skate([-.0,-.0,joint_radius+.5]))cyl(d=joint_radius*2,rounding1=-.5,joint_radius+.5-1);
   }
}

module SupportJointIndexPaddle () {
  difference(){
    union(){
      mouseOrigin()v_ind()hull(){indexPaddleMount();middlePaddleMount();}
      hull()mouseOrigin()v_ind(){middlePaddleMount(); indexPCBMount(quad=3, u=-joint_radius)fwd(3)sphere(joint_radius); }

      hull(){mouseOrigin()v_ind()indexPaddleMount();thumbPaddleSupportTop();}
      hull(){mouseOrigin()v_ind()indexPaddleMount();thumbPaddleSupportBack();}
      hull(){mouseOrigin()v_ind()indexPaddleMount();thumbPaddleSupportFront();}
      hull(){mouseOrigin()v_ind()indexPaddleMount();move(sensorPCBMountRight(3))sphere(joint_radius);}

      hull(){mouseOrigin()v_ind()middlePaddleMount();move(sensorPCBMountRight(3))sphere(joint_radius);}
      hull(){mouseOrigin()v_ind()middlePaddleMount();move(sensorPCBMountLeft(1))sphere(joint_radius);}
      
      hull(){mouseOrigin()v_ind()middlePaddleMount();pinkyPaddleSupportTop();}
      hull(){mouseOrigin()v_ind()middlePaddleMount();ringPaddleSupportFront();}
      hull(){mouseOrigin()v_ind()middlePaddleMount();ringPaddleSupportTop();}

      mouseOrigin()v_ind()indexOrigin([0,0,-5.5])translate([ -15.5,-20,11.75])cuboid([6,5.5,2.5],rounding=.5);
      mouseOrigin()v_ind()indexOrigin([0,0,-7.5])translate([13.5,-20,11.75])cuboid([6,5.5,2.5],rounding=.5);
    }
   //cuts
   mouseOrigin()v_ind(){
    indexOrigin([0,0,-5.5])translate([ -15.5,-20,11.75]){
        translate([0,1,1])cuboid([4.2,6,1.3],rounding=0);
        cyl(d=1.5, 5);
      }
      indexOrigin([0,0,-7.5])translate([ 13.5,-20,11.75]){
        translate([0,1,1])cuboid([4.2,6,1.3],rounding=0);
        cyl(d=1.5, 6);
      } 
   }
  }
}

module SupportJointRingPinky () {
  hull(){pinkyPaddleSupportBottom();move(ring_skate([0,0,joint_radius+.5]))sphere(joint_radius);}
  hull(){ringPaddleSupportTop();pinkyPaddleSupportTop();}   

  hull(){ringPaddleSupportFront(); move(middle_skate)sphere(joint_radius);}
  hull(){pinkyPaddleSupportTop();move(palm_skate)sphere(joint_radius);}   
}


  module PaddleMountPlacer(u=0,v=0, height_offset=0, finger, phalange, patch) {
    mouseOrigin()PlaceOn(finger= finger, phalange = phalange, A_hand = NeutralHandFlexion)down(Finger_diam[finger][phalange]*2+height_offset)
            move(bezier_patch_points(EdgePatching(patch), u,v))yrot(0)back(-5)children(); 
  }
