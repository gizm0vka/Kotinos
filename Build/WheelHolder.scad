include <BOSL2/std.scad>



function angle_between(p1, p2) =
    let(
        v  = p2 - p1,
        xy = sqrt(v[0]*v[0] + v[1]*v[1])
    )
    [
        0,
        atan2(xy, v[2]),
        atan2(v[1], v[0])
    ];
    
function move_point_along_line(p1, p2, delta) =
    let(
        dx = p2[0] - p1[0],
        dy = p2[1] - p1[1],
        d = sqrt(dx*dx + dy*dy)
    )
    d < 1e-9
        ? p2
        : [
            p2[0] + dx / d * delta,
            p2[1] + dy / d * delta,
            p2[2]
        ];

module rotate_about(point, rot) {
    translate(point)
        rotate(rot)
            translate(-point)
                children();
}

module connect(p1, p2, a=[0,0,0], r1=1, r2=1, delta1=0, delta2=0, anchor1=CENTER, anchor2=CENTER, pivot=[0,0,0]){
    hull(){
        translate(move_point_along_line(p2, p1, delta1))sphere(r=r1, anchor=anchor1)children();
        rotate_about(pivot, a)translate(move_point_along_line(p1, p2, delta2))sphere(r=r2, anchor=anchor2);
    }
}

module draw_connector_point(p, clr="red"){
    sz = 0.05;
    length = 20;
    %translate(p)color(clr, alpha=0.3){
        cube([sz, sz, length], center=true);
        cube([sz, length, sz], center=true);
        cube([length, sz, sz], center=true);
    }
}


module wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1), hd=1.6, mh=1, whp=[6, -0.5, 5], wh_d=6.5, wh_hd=4, wh_h=2, rounding = ($preview ? 0 : 0.1)){
    //whp= move_point_along_line(mp1, mp2, -10) + wh_shift;
    //whp= move_point_along_line(mp1, mp2, -10) + wh_shift;

    a_w= (wh_d-wh_hd)/2;
    a_l= 1;
    a_h= wh_h;
    whp_c2= whp + [-a_w/2+wh_d/2, -a_l/2, 0];
    whp_c1= whp + [ a_w/2-wh_d/2, -a_l/2, 0];
    
    wh_a = [90, 0, angle_between(mp1, mp2)[2]];

    ma=CENTER;
    wha=CENTER;
    
    //draw_connector_point(whp);
    //draw_connector_point(mp1, "blue");
    //draw_connector_point(whp_c2, "blue");

    difference(){
        union(){
            translate(mp1)cyl(d=md, h=mh, anchor=ma, rounding1=-rounding);
            translate(mp2)cyl(d=md, h=mh, anchor=ma, rounding1=-rounding);
            render()rotate_about(whp, wh_a)union(){
                translate(whp)back_half()tube(ir=wh_hd/2, or=wh_d/2, h=wh_h, rounding=rounding, anchor=wha);
                translate(whp_c1)xrot(-90)prismoid(size1=[a_w/6, a_h/6], size2=[a_w, a_h], h=a_l, anchor=CENTER, rounding=0.0);
                translate(whp_c2)xrot(-90)prismoid(size1=[a_w/6, a_h/6], size2=[a_w, a_h], h=a_l, anchor=CENTER, rounding=0.0);
                //translate(whp_c1)cuboid([a_w, a_l, a_h], anchor=wha, rounding=rounding);
                //translate(whp_c2)cuboid([a_w, a_l, a_h], anchor=wha, rounding=rounding);
            }
            
            let(r=1.0, zadj=-.25, delta1=-1.6, delta2=.25){
                connect(mp1 +[0,0, zadj], whp_c1 +[0, .5, 0], anchor1=ma, anchor2=wha, r1=r, r2=r, delta1=delta1, delta2=0, a=wh_a, pivot=whp);
                connect(mp2 +[0,0, zadj], whp_c2 +[0, .5, 0], anchor1=ma, anchor2=wha, r1=r, r2=r, delta1=delta1, delta2=0, a=wh_a, pivot=whp);
            }
        }
        
        translate(mp1)cyl(d=hd, h=6);
        translate(mp2)cyl(d=hd, h=6);
        let(clrce_d=4, clrce_d_b=10, clrce_h=2){
            translate(mp1)up(mh/2+clrce_h/2)cyl(d=clrce_d, h=clrce_h, anchor=CENTER);
            translate(mp1)down(mh/2+clrce_h/2)cyl(d=clrce_d_b, h=clrce_h, anchor=CENTER);
            translate(mp2)up(mh/2+clrce_h/2)cyl(d=clrce_d, h=clrce_h, anchor=CENTER);
            translate(mp2)down(mh/2+clrce_h/2)cyl(d=clrce_d_b, h=clrce_h, anchor=CENTER);
        }
        rotate_about(whp, wh_a){
            translate(whp)cyl(d=wh_hd, h=wh_h, anchor=ma);
            right(a_w)translate(whp_c1)cuboid([a_w, a_l, a_h], anchor=wha);
            left(a_w)translate(whp_c2)cuboid([a_w, a_l, a_h], anchor=wha);
        }
    }
    //rotate_about(whp, wh_a)right(a_w)translate(whp_c1)cuboid([a_w, a_l, a_h], anchor=wha);
}

if (0){
$fn=28;

//wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5, 6], wh_d=7, wh_hd=4, wh_h=2);

    if (1){
        color("teal"){
//            left(10*0)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5, 5.5], wh_d=7, wh_hd=4, wh_h=2); // too tight at the top
//            left(10*1)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5, 6.0], wh_d=7, wh_hd=4, wh_h=2);// tight fit but the roller slides out noticable
//            left(10*2)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5, 6.5], wh_d=7, wh_hd=4, wh_h=2);
//            left(10*3)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5, 7.0], wh_d=7, wh_hd=4, wh_h=2);
        }
        color("brown"){
//            back(25)left(10*0)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[5, -0.5, 5.5], wh_d=7, wh_hd=4, wh_h=2);
            back(25)left(10*1)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[5, -0.5, 6.0], wh_d=7, wh_hd=4, wh_h=2); // this one, but fix sagging of the arc when printing, move ~0.5mm towards wheel, fix a little bit of play back and forward.
//            back(25)left(10*2)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[5, -0.5, 6.5], wh_d=7, wh_hd=4, wh_h=2);
//            back(25)left(10*3)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[5, -0.5, 7.0], wh_d=7, wh_hd=4, wh_h=2);
        }
        color("green"){
//            fwd(25)left(10*0)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5-0.5, 5.5], wh_d=7, wh_hd=4, wh_h=2);
//            fwd(25)left(10*1)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5-0.5, 6.0], wh_d=7, wh_hd=4, wh_h=2);
//            fwd(25)left(10*2)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5-0.5, 6.5], wh_d=7, wh_hd=4, wh_h=2);
//            fwd(25)left(10*3)wheelHolder(mp1 = [8.5, (20-2.5)/2, 1], mp2 = [8, -(20-2.5)/2, 1], md=(1.2*2+1.1), hd=1.7, mh=1, whp=[6, -0.5-0.5, 7.0], wh_d=7, wh_hd=4, wh_h=2);
        }


    }
}