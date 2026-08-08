/*  
  Hand Generator and Placement module 
*/ 

//include <BOSL2/std.scad>
//include <DataHand.scad>
//let(A_hand = NeutralHandFlexion)HandsOn(meat= true, A_hand);
//include <PaddleSurfaceGenerator.scad>
//include <DataRingPaddle.scad>

thu = 0; ind = 1; mid = 2; rng = 3; pnk = 4;
meta =0; prx = 1; dis = 3;
step= 32;
res= 64;



module PlaceOn (finger= 0, phalange = 0, A_hand = NeutralHandFlexion) { //place scad object along finger trajectory 
 R_hand = [ A_hand[finger][dis][2],0,0,0,0]; // Thumb  
 translate(W_hand[finger])xrot(R_hand[finger])rotate(A_hand[finger][0])translate([0,Len_hand[finger][0],0]){
   if(phalange >= 1)rotate(A_hand[finger][1])translate([0,Len_hand[finger][1],0]){//proxi phalange
     if(phalange >= 2)rotate(A_hand[finger][2])translate([0,Len_hand[finger][2],0]){//medial phalange
        if(phalange >= 3)rotate(A_hand[finger][3])translate([0,Len_hand[finger][3],0]){// phalange
          children();     
        }else children();
      } else children();
    } else children();
   }
}      
  
function PlaceOnVec (finger= 0, phalange = 0, A_hand = NeutralHandFlexion, vec = [0,0,0]) = //vector to PlaceOn Module

 let(R_hand = [A_hand[finger][dis][2],0,0,0,0])// Thumb  
 move(W_hand[finger], rot([R_hand[finger],0,0], p=rot(A_hand[finger][0], p=move([0,Len_hand[finger][0],0],
        phalange>=1 ? rot(A_hand[finger][1], p= move([0,Len_hand[finger][1],0],  
          phalange>=2 ? rot(A_hand[finger][2], p= move([0,Len_hand[finger][2],0],
            phalange>=3 ? rot(A_hand[finger][3], p= move([0,Len_hand[finger][3],0], vec)) : vec)) : vec)) : vec
  )))); 
 
function PlaceOnOrient (finger= 0, phalange = 0, A_hand = NeutralHandFlexion, vec=[0,0,0]) = //angular cal to PlaceOn Module child

 let(R_hand = [A_hand[finger][dis][2],0,0,0,0])// Thumb  
  rot([R_hand[finger],0,0], p= rot(A_hand[finger][0], p = 
    phalange>=1 ? rot(A_hand[finger][1], p =  
      phalange>=2 ? rot(A_hand[finger][2], p = 
        phalange>=3 ? rot(A_hand[finger][3], p= vec) : vec) : vec) : vec
  ));
  

module HandsOn(meat = true, A_hand=NeutralHandFlexion) {// flexion rotation axis set to knuckle side as it should

  meta= 0; prox = 1; medi = 2; dist = 3;
  module fingerJoint(i,j, sc=1) {scale([Finger_width[i][j],1,Finger_diam[i][j]])rotate([90,30,0])cylinder(r=1,.1,$fn=16);}

  //blob shape generation for skinning
  function ThumbBlob (n) =  let(Tmeta=Finger_diam[thu][meta],Wmeta=36/2, rprox=Finger_diam[thu][prx], length = Len_hand[thu][meta], power=2)
    move([smoothStop(rprox, Tmeta, n, step-1, power),0,lerpn(0,1,step)[n]*length],
          p=path3d(scale(v=[smoothStop(rprox, Tmeta, n, step-1, power),stopPeak(rprox, Wmeta, rprox, n, step-1, round(step*1/2), power)],p=circle($fn=16, r=1))));
          
  function IndexBlob (n) =  let(rcen=25/2, rprox =Finger_diam[ind][prx], rmeta= Finger_diam[ind][meta], length = Len_hand[ind][meta])
        move([smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/2)),0,lerpn(0,1,step)[n]*length],
          p=path3d(scale(v=[smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/2)),stopPeak(Finger_width[ind][prx], rcen, Finger_width[ind][meta], n, step-1, round(step/2),2)],p=circle($fn=16, r=1))));

  function IndexPalmBlob (n) =  let(rcen=25/2, rprox =Finger_diam[ind][prx], rmeta= Finger_diam[ind][meta], length = Len_hand[ind][meta]-Finger_diam[ind][meta])
        move([smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/2)),0,lerpn(0,1,step)[n]*length+rmeta],
          p=path3d(scale(v=[smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/2)),stopPeak(18/2, 13, Finger_width[ind][meta]+0, n, step-1, round(step/2),2)],p=circle($fn=8, r=1))));
          
  function MiddleBlob (n) =  let(rcen=23/2, rprox =Finger_diam[mid][prx], rmeta= Finger_diam[mid][meta], length = Len_hand[mid][meta])
        move([smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/3)),0,lerpn(0,1,step)[n]*length],
          p=path3d(scale(v=[smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/3)),smoothPeak(Finger_width[mid][prx], rcen, rmeta, n, step-1, round(step/3))],p=circle($fn=16, r=1))));
          
  function RingBlob (n) = let(rcen=23/2, rprox =Finger_diam[rng][prx], rmeta= Finger_diam[rng][meta], length = Len_hand[rng][meta])
        move([smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/3)),0,lerpn(0,1,step)[n]*length],
          p=path3d(scale(v=[smoothPeak(rprox, rcen, rmeta, n, step-1, round(step/3)),smoothPeak(Finger_width[rng][prx], rcen, rmeta, n, step-1, round(step/3))],p=circle($fn=16, r=1))));
  
  function PinkieBlob (n) = let(rmeta=20/2,rcen=29/2,rprox=16/2, length = Len_hand[pnk][meta], h=lerpn(Finger_diam[pnk][prx],Finger_diam[pnk][meta],step))
    move([h[n],0,lerpn(0,1,step)[n]*length], p=path3d(scale(v=[h[n],stopPeak(rprox, rcen, rmeta, n, step-1, round(step*1/2),2)],p=circle($fn=16, r=1))));
 
   for (i = [0:len(Len_hand)-1]){
     //Finger Generation
     let(j=meta)color("Turquoise")PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]/2,-1])xrot(90)zrot(90)cyl(r=1,Len_hand[i][j],$fn=3);
     let(j=prox)color("DodgerBlue")PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]/2,-1])xrot(90)zrot(90)cyl(r=1,Len_hand[i][j],$fn=3);
     let(j=medi)color("RoyalBlue")PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]/2,-1])xrot(90)zrot(90)cyl(r=1,Len_hand[i][j],$fn=3);
     if(i>thu)let(j=dist)color("MidnightBlue")PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]/2,-1])xrot(90)zrot(90)cyl(r=1,Len_hand[i][j],$fn=3);
  }

  for (i = [0:len(Len_hand)-1])color("tan",alpha=.5){
     //Finger Generation
 
     let(j=prox)hull(){
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
        PlaceOn(finger=i, phalange=j+1, A_hand = A_hand)translate([0,-Len_hand[i][j+1],-Finger_diam[i][j+1]])fingerJoint(i,j+1, sc=fingerScale);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,0,-Finger_diam[i][j+1]])fingerJoint(i,j+1, sc=fingerScale);
        PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)translate([0,0,-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
     }      

     if(i>thu)let(j=medi)hull(){//medial phalanges separate thumb
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
        PlaceOn(finger=i, phalange=j+1, A_hand = A_hand)translate([0,-Len_hand[i][j+1],-Finger_diam[i][j+1]])fingerJoint(i,j+1, sc=fingerScale);

        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,0,-Finger_diam[i][j+1]])fingerJoint(i,j+1, sc=fingerScale);
        PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)translate([0,0,-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
     } else let(j=medi)hull(){//Thumb 
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)
          translate([0,-Finger_diam[i][j+1]*sin(Tip_angle[i]),-Finger_diam[i][j+1]*1.4])
            rotate([-Tip_angle[i],0,0])scale([fingerScale,1,1.4])
              rotate([90,0,0])up(Tip_thickness[i])
                cyl(r=Finger_diam[i][j+1],Tip_thickness[i]*2,rounding=Tip_thickness[i], $fn=16);
        PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)translate([0,0,-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
      }   
      if(i>thu)let(j=dist)hull(){
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)
          translate([0,-Finger_diam[i][j+1]*sin(Tip_angle[i]),-Finger_diam[i][j+1]*1.4])
            rotate([-Tip_angle[i],0,0])scale([fingerScale,1,1.4])
              rotate([90,0,0])up(Tip_thickness[i])
                cyl(r=Finger_diam[i][j+1],Tip_thickness[i]*2,rounding=Tip_thickness[i], $fn=16);
        PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)translate([0,0,-Finger_diam[i][j]])fingerJoint(i,j, sc=fingerScale);
      } 
  }
  
  //Palm generation   
  if (meat == true)color("tan",alpha=.5){
      hull(){
        PlaceOn(finger=ind, phalange=meta, A_hand = A_hand)rotate([90,90,0])skin([for(n=[0,step-5]) IndexPalmBlob(n)], slices=0);
        PlaceOn(finger=thu, phalange=meta, A_hand = A_hand)rotate([90,90,0])skin([for(n=[4,step-5]) ThumbBlob(n)], slices=0);
      }

 //intra digit web meta and phalenges
      let(i= ind, j=prox){
      hull(){
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
        let(t=round(Finger_diam[i][j]/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) IndexBlob(n)], slices=0);
        
        let(i=i+1){
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
          let(t=round(Finger_diam[i][j]/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) MiddleBlob(n)], slices=0);
        }
      }}  
      
      let(i= mid, j=prox){
      hull(){
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
        let(t=round(Finger_diam[i][j]/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) MiddleBlob(n)], slices=0);
        
        let(i=i+1){
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
          let(t=round((Finger_diam[i][j]+3)/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) RingBlob(n)], slices=0);
        }
      }}  
      
      let(i= rng, j=prox){
      hull(){
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
        PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
        let(t=round((Finger_diam[i][j]+3)/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) RingBlob(n)], slices=0);
        let(i=i+1){
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j],-Finger_diam[i][j]])fingerJoint(i,j, sc=1);
          PlaceOn(finger=i, phalange=j, A_hand = A_hand)translate([0,-Len_hand[i][j]+Finger_diam[i][j],-Finger_diam[i][j]*2+Finger_diam[i][j]*(Finger_diam[i][j]/Len_hand[i][j])])rotate([90,30,0])cylinder(r=1,.1,$fn=3);
          let(t=round(Finger_diam[i][j]/(Len_hand[i][j-1]/step)))PlaceOn(finger=i, phalange=j-1, A_hand = A_hand)rotate([90,90,0])skin([for(n=[t,t+1]) PinkieBlob(n)], slices=0);
        }
      }}  
  }
  //improved metacarpal palm blob generation 
  color("tan",alpha=.5)translate([0,0,0]){
     let(i=thu, j=meta)PlaceOn(finger=i, phalange=j, A_hand = A_hand)rotate([90,90,0])skin([for(n=count(step)) ThumbBlob(n)], slices=0);
     let(i=ind, j=meta)PlaceOn(finger=i, phalange=j, A_hand = A_hand)rotate([90,90,0])skin([for(n=count(step)) IndexBlob(n)], slices=0);
     let(i=mid, j=meta)PlaceOn(finger=i, phalange=j, A_hand = A_hand)rotate([90,90,0])skin([for(n=count(step)) MiddleBlob(n)], slices=0);
     let(i=rng, j=meta)PlaceOn(finger=i, phalange=j, A_hand = A_hand)rotate([90,90,0])skin([for(n=count(step)) RingBlob(n)], slices=0);
     let(i=pnk, j=meta)PlaceOn(finger=i, phalange=j, A_hand = A_hand)rotate([90,90,0])skin([for(n=count(step)) PinkieBlob(n)], slices=0);
   }  
   
} //END OF HAND MODULE


//Blob definitnions   
function PinkieBlobVec (n, theta, A_hand =NeutralHandFlexion, buffer=0) = let(rmeta=20/2+buffer/2,rcen=31/2+buffer/2,rprox=16/2+buffer/2, length = Len_hand[pnk][meta], h=lerpn(Finger_diam[pnk][prx]+buffer/2,Finger_diam[pnk][meta]+buffer/2,res))
  move(PlaceOnVec(pnk, meta, A_hand = A_hand), p= PlaceOnOrient(pnk, meta, A_hand = A_hand, vec = rot( [90,90,0], p= [h[n],0,lerpn(0,1,res)[n]*length] + [h[n]*cos(theta), stopPeak(rprox, rcen, rmeta, n, res-1, round(res*1/2),2)*sin(theta), 0])));
          
//smoothening functions 
function smoothStart (init, fin, t, steps, power) = 
  (1-pow(t/steps,power))*init + pow(t/steps,power)*fin; 

function smoothStop (init, fin, t, steps, power) = 
  (fin-init)*(1-pow(1-t/steps,power))+init; 

function smoothStep (init, fin, t, steps) = 
  (fin - init)*(pow(t/steps,2)*3 - pow(t/steps,3)*2) + init; 

function smoothPeak(init, cent, fin, t, steps, transitionPoint) = t <= transitionPoint ?  smoothStep(init,cent, t, transitionPoint) :  smoothStep(cent, fin, t-transitionPoint, steps-transitionPoint);

function stopPeak(init, cent, fin, t, steps,transitionPoint, power) = t <= transitionPoint ?  smoothStop(init,cent, t, transitionPoint, power) :  smoothStart(cent, fin, t-transitionPoint, steps-transitionPoint, power);


