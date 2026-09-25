include <BOSL2/std.scad>
include <WheelHolder.scad>

/// HSK PCB 
  module hsk_main (){ 
//   #xrot(90)cyl(r=1,10);
   
    difference(){
      color("purple"){
        rect([39, 26]);
        translate([-39/2-5/2,26/2-3/2-3])rect([5, 3]);
        translate([39/2+5/2,-26/2+2/2])rect([5, 2]);
        translate([-39/2+22.25+1.25,-26/2,0])circle(d=4.5, $fn=16);
        }
      translate([-39/2+2.5/2+1,18.5-13,0])cyl(d=2.5,2, $fn=16); //16.25 7.25 
      translate([-39/2+22.25+1.25,-26/2,0])circle(d=2.5, $fn=16);
    } 

    color("white", alpha=.5)move([0,5,-4.5/2])cube([11,7,4.5], center=true);
    color("black", alpha=.5)move([-17.5+1.25-2,10.5,2.5])cube([6.5,3,5], center=true);
    color("grey", alpha=.5)move([-17.5+1+10,-26/2+3.5/2,2.5+.5])cube([6,3.5,5], center=true);
    color("grey", alpha=.5)move([-18,-26/2+2.5,2.5+.5])cube([3,5,5], center=true);
    color("white", alpha=.5)move([0,5,1.75])cube([16,11,2.5], center=true);
    color("black", alpha=.2)translate([-39/2+22.25+1.25+3.5,-26/2+3.5,2])cyl(d=4, 3, $fn=16);

//    #fwd(-5)down(2)cyl(r=1.5, rounding=1.5, 8);

  }
  
  // INDEX 
  module hsk_index (){ 
      wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1), hd=1.6, mh=1, whp=[6, -0.5, 5], wh_d=6.5, wh_hd=4, wh_h=2);
    difference(){
      color("purple")down(.5)linear_extrude(1){
        rect([24, 23]);
        back(2.5)rect([14, 28]);
        left(2)back(-1)rect([37, 15]);
        }
      translate([-8,(20-2.5)/2,0])cyl(d=2.5,2, $fn=16); //16.25 7.25 
      translate([8,(20-2.5)/2,0])cyl(d=2.5,2, $fn=16); //16.25 7.25 
      translate([-8,-(20-2.5)/2,0])cyl(d=2.5,2, $fn=16); //16.25 7.25 
      translate([8,-(20-2.5)/2,0])cyl(d=2.5,2, $fn=16); //16.25 7.25 
//      translate([-39/2+22.25+1.25,-26/2,0])circle(d=2.5, $fn=16);
    } 
    move([13.5,0,3])xrot(-90){
      color("black")cube([5.8,6.5,12.8],center=true);
      color("blue")up(1.3)fwd(1.15/2)cube([2.9,7.35,1.2],center=true);
    }
    move([-15.5,0,3])xrot(-90){
      color("black")cube([5.8,6.5,12.8],center=true);
      color("blue")up(1.3)fwd(1.15/2)cube([2.9,7.35,1.2],center=true);
    }
   //rot enco
     {
        color("LightSeaGreen")right(-3)up(5){
          yrot(90)cyl(r=7, 3, rounding1=.5, rounding2=-2.5, $fn=32);
          right(3)yrot(90)cyl(d=3, 19, $fn=32);
          right(2.)yrot(90)cyl(r=10, 1, rounding=.5,$fn=32);
          right(4)yrot(90)cyl(r=7, 3, rounding2=.5, rounding1=-2.5, $fn=32);
  //        #right(3)yrot(90)cyl(r=1, 12);
          right(2.)yrot(90)cyl(r=10, 7, rounding=2,$fn=32);
        }
        right(-10)up(5)xrot(-90)cuboid([4,9.5,9.7], rounding=3, edges=[FRONT+TOP, FRONT+BOTTOM]);
     }
//    move([-15.5,-10,3])xrot(-90)cube([6,5,5],center=true); //pin header
}
  
 module encoder () {
  difference(){
    union(){
      yrot(90)cyl(r=7, 3, rounding1=.5, rounding2=-2.5);
      right(2.)yrot(90)cyl(r=10, 1, rounding=.5);
      right(4)yrot(90)cyl(r=7, 3, rounding2=.5, rounding1=-2.5);
    }
      
  //        #right(3)yrot(90)cyl(r=1, 12);
    right(2.)yrot(90)cyl(r=5, 7.01, rounding=-1);
    let(n=12)for(i=count(n)){
      xrot(i*360/n)right(2.)up(7)yrot(90)cyl(r=1, 10, rounding=0);
      xrot(i*360/n+180/n)right(2.)up(8.5)yrot(90)cyl(r=1, 10, rounding=0);}
  }
  right(2)yrot(90)cyl(r=1.5, 19, rounding=0);
  xrot(0)right(2)prismoid(size1 =[3,1], size2= [4,1], h=5, rounding=.5);
  xrot(120)right(2)prismoid(size1 =[3,1], size2= [4,1], h=5, rounding=.5);
  xrot(240)right(2)prismoid(size1 =[3,1], size2= [4,1], h=5, rounding=.5);
 }
//encoder($fn=32); 
  // THUMB
 module hsk_thumb (){ 
//      union(){left(5)cube([3,19,2],center=true); fwd(9)left(1.5)cube([10,3,2],center=true);fwd(-8.75)left(1.5)cube([10,1.75,2],center=true);}
//      cube([12.5, 18.5,1], center=true);
//      right(3.25+1.5)back(-5.25-1)cube([6, 7.5,1],center=true);
//    }

      move([6.35,-4.75,4.0])prismoid(size1=[2,3], size2=[2,3], shift=[0,0], h=4.25);
      move([6.35,-4.75,8.25])prismoid(size1=[2,3], size2=[1,3], shift=[.5,0], h=1.2);
      
      move([3.75,5.25,4.0])prismoid(size1=[2,3], size2=[2,3], shift=[0,0], h=2.6); 
      move([3.75,5.25,6.6])prismoid(size1=[2,3], size2=[.5,3], shift=[.75,0], h=1);
      
      move([-5.25,-7.25+2.25,1.9])cube([2,4,5],center=true);
    difference(){
      color("yellow"){
        move([-12.5/2+2.5,  18.5/2-2, 2.55])cyl(r=1.5, rounding2=0, 4.1);
        move([  -12.5/2+4, -18.5/2+4, 2.375])cyl(r=1.5, rounding2=0, 3.75);
      }
      move([-12.5/2+2.5,  18.5/2-2, 2.6])cyl(r=.75, 4.2);
      move([  -12.5/2+4, -18.5/2+4, 2.5])cyl(r=.75, 4);
      move([-12.5/2+4.75+3.25,5.25,2])xrot(-90)yrot(90)cube([4.5,3,9.25],center=true);
    }    
    difference(){
      move([6.75,.25,4.0]){
//        up(3)prismoid(size1=[3,1], size2=[1,1], shift=[1,0], h=3); 
//        left(1.75)up(1.5)prismoid(size1=[6.5,1], size2=[3,1], shift=[1.75,0], h=1.5); 
//        left(3.25)up(.5)prismoid(size1=[9.5,1], size2=[6.5,1], shift=[1.5,0], h=1.);         
        color("yellow")left(4.125)up(.5)prismoid(size1=[11.,1], size2=[1.5,1], shift=[-4.25,0], h=.5);
        left(3.5)down(2)prismoid(size1=[9.75,3.], size2=[9.75,1], shift=[0,0], h=2.5); 
//        left(3.25)down(2.5)prismoid(size1=[9.5,3], size2=[9.5,1.5], shift=[-0,0], h=2.);
        left(3.5)down(3.5)prismoid(size1=[9.75,3], size2=[9.75,3], shift=[-0,0], h=1.5); 
        
        color("red")left(8.5)back(-1.75)down(.5)prismoid(size1=[2.,4.5], size2=[2.,4.5], shift=[0,-0], h=1); 
        color("blue")left(8.5)down(2)prismoid(size1=[2,3.], size2=[2,1], shift=[0,0], h=2.5); 
        color("blue")left(8)down(3.5)prismoid(size1=[1.,3.], size2=[2,3], shift=[-.5,0], h=1.5); 


//        #left(8.125)back(0)down(3.5)prismoid(size1=[0.5,3], size2=[1.25,5.5], shift=[-.5,-1.25], h=3); 
      }
      
//      color("red")move([6,0,1])cube([4,4,5],center=true);
    move([6.5,.2,2.25])cyl(r=.5, 4);
    }
}

 module hsk_thumb_PCB (){
    difference(){
      color("purple"){
        rect([12.5, 18.5]);
        right(3.25+1.5)back(-5.25-1)rect([6, 7.5]);
        }
        move([-12.5/2+2.5,18.5/2-2,0])cyl(r=1, 1.1);
        move([-12.5/2+4,-18.5/2+4,0])cyl(r=1, 1.1);
    }  
    //switches
    move([-12.5/2+4.75+6,-4.75,2])xrot(-90)yrot(90){
      color("black")cube([4.5,3,9.25],center=true);
      color("blue")up(4.75-.6-2.5)fwd(.2)cube([2.9,3.35,1.2],center=true);
    }
    move([-12.5/2+4.75+3.25,5.25,2])xrot(-90)yrot(90){
      color("black")cube([4.5,3,9.25],center=true);
      color("blue")up(4.75-.6-2.5)fwd(.2)cube([2.9,3.35,1.2],center=true);
    }
    //button
//    color("teal")up(6.4)left(-5)cube([4,29,4.7],center=true);
} 

//hsk_index();
//hsk_thumb_PCB();