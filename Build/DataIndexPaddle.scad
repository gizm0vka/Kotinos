//include <PaddleSurfaceGenerator.scad>

DeepPaddlePatch=[
               [[        ], [ 9,15, -3], [ 8, 13,  -4], [ 7, 11,  -3], [ 7,9, -1], [ 6, 4,-.5], [  6, 0, -0], [          ]],
               [[ 4,19,-3], [ 3,15, -5], [ 2, 13,  -5], [ 2, 11,  -4], [ 2,9,-0.], [ 2, 4,  0], [  2, 0, -0], [  2,-6, -1]],
               [[-1,21,-6], [-1,15,-6.5], [-1, 13,-5.5], [-1, 11,-4.5], [-1,9,-0.5], [-1, 4,  0], [ -1, 0, -0], [ -1,-6, -1]],
               [[-6,19,-2], [-4,15, -5], [-4, 13,  -5], [-4, 11,  -4], [-4,9,-0.], [-4, 4,  0], [ -4, 0, -0], [ -6,-6, -1]],
               [[        ], [-10,15,-1], [-9, 13,  -2], [-8.5, 11,  -1], [-8,9,  0], [-8, 4,  1], [ -8, 0, -0], [          ]]
              ]; 

 ShallowPaddlePatch=[
               [[        ], [ 9,17,-1.5], [ 8, 13, -2], [ 7, 10, -0.5], [ 6, 5, .5], [  6, 0, -0], [          ]],
               [[ 4,21, 0], [ 3,17, -2], [ 2, 13, -3], [ 2, 10,   -1.0], [ 2, 5,  0], [  2, 0, -0], [  2,-6, -1]],
               [[-1,22,-2], [-1,17, -2.5], [-1, 13, -3.5], [-1, 10, -1.5], [-1, 5,  0], [ -1, 0, -0], [ -1,-6, -1]],
               [[-6,21, 0], [-4,17, -2], [-4, 13, -3], [-4, 10,   -1], [-4, 5,  0], [ -4, 0, -0], [ -6,-6, -1]],
               [[        ], [-8,17, -1], [-9, 13, -2], [-8, 10,   -0], [-8, 5,  1], [ -8, 0, -0], [          ]]
              ]; 
                   

//%PatchPaddle(ThumbPatch, debug=true); //comment out when redner
//color("gold", alpha=.5)
//PatchPaddle(ShallowPaddlePatch, debug=false);
//$fn=32;
//IndexDeepPaddle();



module PaddleMount () {
  difference(){
    fwd(10)xrot(90)prismoid(size1 =[4,1], size2= [4,1],shift=[0,0], h=5.5, rounding1=.1, rounding2= .1);
    fwd(13.5)cyl(d=2.2, 1);
    fwd(13.5)up(.4)cyl(d=3, .25);
  }      
}

module IndexShallowPaddle (shift =[0,0.0,-2]) {
  left(14)up(13.25)fwd(3)move(shift)scale([1,1.0,1])PatchPaddle(ShallowPaddlePatch, debug=false); //mid 
  move([-15.5,1,10.35+shift[2]/2-1.25])cuboid([4,2.5,4.+shift[2]+2.5],rounding=.5); 
  move([-15.5,-6.5,11.6]){
      up(+shift[2]){
        xrot(90)prismoid(size1 =[5,1], size2= [4,1], h=2, rounding=.5);
        zrot(180)xrot(90)prismoid(size1 =[5,1], size2= [6,.25],shift=[0,.75], h=2, rounding1=.5);      
        fwd(2)xrot(90)prismoid(size1 =[4,1], size2= [4,1],shift=[0,-2], h=8, rounding1=.5, rounding2= .1);
      }
      up(shift[2]-2)PaddleMount();
   }
}

module IndexDeepPaddle (shift =[0,-0.0,-1.5], scaling = [1,1,1], cut = true) {
  difference(){
    left(14)up(13.25)fwd(3)move(shift)scale(scaling)PatchPaddle(DeepPaddlePatch, debug=false); //mid 
    if (true == cut)  
        move([-8.5,-1.5,10])cuboid([7,15,5],rounding=1); 
  }
  move([-15.5,1,10.35+shift[2]/2-.4])cuboid([4,2.5,4.+shift[2]+.2],rounding=.5); //switch nib
  
  move([-15.5,-6.5,11.6]){
      up(+shift[2]){
        fwd(2)xrot(90)prismoid(size1 =[4,1], size2= [4,1],shift=[0,-.5], h=8, rounding1=.5, rounding2= .1);
      }
      up(shift[2])down(.5)PaddleMount();
   }
}

module MidPaddle (rend=false, scaling = [1,1.0,1],shift =[0,-0.5,-2.5]) {
  
  if(rend==true)left(14)up(13.25)move(shift)scale(scaling)import("\\husk\\mid_paddle2.stl"); //mid 
  else left(14)up(13.25)move(shift)scale(scaling)PatchPaddle(DeepPaddlePatch, debug=false); //mid 
//  left(14)up(13.25)move(shift)scale(scaling)PatchPaddle(DeepPaddlePatch, debug=true); //mid 
//  #xflip()import("\\husk\\husk_mid.stl"); //mid 
  
//  move([-15.5,1,10.6+shift[2]/2])cuboid([4,2.5,4.5+shift[2]],rounding=.5); //switch nib
  move([-15.5,1,10.6+shift[2]/2-.25])cuboid([4,2.5,4.+shift[2]],rounding=.5); //switch nib
  
  move([-15.5,-6.5,11.6]){
      up(shift[2]){
        xrot(90)prismoid(size1 =[5,1], size2= [4,1], h=2, rounding=.5);
        zrot(180)xrot(90)prismoid(size1 =[5,1], size2= [6,.25],shift=[0,.75], h=2, rounding1=.5);      
        fwd(2)xrot(90)prismoid(size1 =[4,1], size2= [4,1],shift=[0,-1.0], h=8, rounding1=.5, rounding2= .1);
      }
      up(shift[2]-1)PaddleMount();    
   }

}