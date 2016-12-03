include <conf/config.scad>
use <bearing-holder.scad>


bearing         = LM8UU;
bearing_length  = bearing[0];
bearing_dia     = bearing[1];

stepper         = NEMA17;
x_pitch         = 50.0;
y_pitch         = 70.0;
z_pitch         = 35.0;


belt_gap        = 13.5;
belt_width      = 6.0;
belt_clearance  = 2.0;

width_extra     =  12.0;
plate_thickness =  4.0;

bottom_width    = x_pitch 
                    + bearing_holder_width(bearing) 
                    + width_extra * 2;
bottom_depth1   = y_pitch 
                    + bearing_holder_width(bearing)
                    + width_extra * 2;
bottom_depth2   = belt_gap 
                    + bearing_holder_length(bearing) * 2;

bottom_depth = max(bottom_depth1, bottom_depth2);

bottom          = bearing_dia;
full_depth      = bearing_dia / 2 + bottom;

idler_thickness = 12.0;
idler_diameter  = 12.5;
mount_diameter  = 15.0;
mount_bolt      = 4.0;

idler_top       = full_depth - idler_thickness / 2;
idler_offset    = belt_gap / 2 + idler_diameter / 2;

Ymount_height   = 65;
rod_height      = Ymount_height - 17.5;

Xmount_height   = 30;
Xrod_height     = 20;

echo("bottom width", bottom_width);
echo("bottom depth", bottom_depth);
echo("bottom height", full_depth);


module idlerMount(d, h) {
    cylinder(h=h,d=d);
}

module idlerMountTop(d, h) {
    difference(){
        cylinder(h=h,d=d);
        translate([0,0,h-6]) cylinder(h=6, d=8);
    }
}
module idler(d, h, bolt) {
    color("Yellow",1) {
        union() {
            cylinder(h=1.0, d=6.0);
            translate([0,0,1.0])  cylinder(h=10.0,d=12.5);
            translate([0,0,11.0]) cylinder(h=1.0,d=6.0);
        }
    }
}

module plateTopPart() {
    webThickness = 3;
    top_y_pitch = (bottom_depth - bearing_holder_length(bearing));
    
    translate([0, 0, plate_thickness/2 - bottom - bearing_dia/2])
        difference() {
            cube([bottom_width, 
                  bottom_depth, 
                  plate_thickness], center = true);
            translate([-60,0,-plate_thickness]) 
                cylinder(r=35,h=plate_thickness*2);
            translate([ 60,0,-plate_thickness]) 
                cylinder(r=35,h=plate_thickness*2);
        };
    translate([ x_pitch/2,  top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bar_height=bottom, populate=false);
    translate([ x_pitch/2, -top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bar_height=bottom, populate=false);
    translate([-x_pitch/2,  top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bar_height=bottom, populate=false);
    translate([-x_pitch/2, -top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bar_height=bottom, populate=false);
   
    translate([-idler_offset, -idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);
    translate([-(idler_offset*1.2)/2  ,idler_offset,-full_depth])
        cube([idler_offset*1.2, webThickness, idler_top]);

    translate([ idler_offset, -idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);
    translate([idler_offset, -(idler_offset*1.2)/2  ,-full_depth])
        cube([webThickness, idler_offset*1.2, idler_top]);
        
    translate([-idler_offset,  idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);
    translate([-idler_offset-webThickness, -(idler_offset*1.2)/2  ,-full_depth])
        cube([webThickness,idler_offset*1.2,idler_top]);
        
    translate([ idler_offset,  idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);
    translate([-(idler_offset*1.2)/2, -idler_offset-webThickness ,-full_depth])
        cube([idler_offset*1.2,webThickness,idler_top]);
        
    x1 = bottom_width/2-width_extra;
    x2 = -bottom_width/2;
    y1 = bottom_depth/2-width_extra;
    y2 = - bottom_depth/2;
    z  = -full_depth+plate_thickness;
    
    
    translate([x1, y1, z])
        difference() {
            cube([width_extra, 
                  width_extra, 
                  full_depth-plate_thickness]);
            translate([width_extra/2,width_extra/2,0])
                    cylinder(d=4.0,h=full_depth+1);
        }
    translate([x1, y2, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);

    translate([x2, y1, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);
    
    translate([x2, y2, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);
}

module plateTop() {
    x = bottom_width/2-width_extra/2;
    y = bottom_depth/2-width_extra/2;
    z = -full_depth;

    color("Red",1) {
        rotate([0,180,90]) {
            union() {
                difference() {
                    plateTopPart();
                    // bolt holes in corners
                    translate([x,y,z])
                        cylinder(d=4.0,h=full_depth+1);
                    translate([-x,y,z])
                        cylinder(d=4.0,h=full_depth+1);
                    translate([x,-y,z])
                        cylinder(d=4.0,h=full_depth+1);
                    translate([-x,-y,z])
                        cylinder(d=4.0,h=full_depth+1);
                    // counter sinks for bolt heads
                    translate([x,y,z])
                        cylinder(d=9.0,h=4);
                    translate([-x,y,z])
                        cylinder(d=9.0,h=4);
                    translate([x,-y,z])
                        cylinder(d=9.0,h=4);
                    translate([-x,-y,z])
                        cylinder(d=9.0,h=4);

                };
                    // add solid bridging layer for countersinks 
                    translate([ x,y,z+4])
                        cylinder(d=12.0,h=0.2);
                    translate([-x,y,z+4])
                        cylinder(d=12.0,h=0.2);
                    translate([ x,-y,z+4])
                        cylinder(d=12.0,h=0.2);
                    translate([-x,-y,z+4])
                        cylinder(d=12.0,h=0.2);
            }
        }
    }
}

module X_rods() {
    color("Blue",1) {
        rotate ([0,180,90]) {
            translate([x_pitch/2, 200, -bearing_dia/2])
                rotate([90,0,0]) 
                    cylinder(d=8, h=400);
            
            translate([-x_pitch/2, 200, -bearing_dia/2])
                rotate([90,0,0]) 
                    cylinder(d=8, h=400);
        }
    }
}

module plateBottomPart() {
    webThickness = 3.0;
    bottom_x_pitch = (bottom_width - bearing_holder_length(bearing));
    
    translate([0, 0, plate_thickness/2 - bottom - bearing_dia/2])
        difference() {
            cube([bottom_depth, 
                  bottom_width, 
                  plate_thickness], center = true);
            translate([0,-60,-plate_thickness]) 
                cylinder(r=35,h=plate_thickness*2);
            translate([0, 60,-plate_thickness]) 
                cylinder(r=35,h=plate_thickness*2);
        }
    translate([ y_pitch/2,  bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom, populate=false);
    translate([ y_pitch/2, -bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom, populate=false);
    translate([-y_pitch/2,  bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom, populate=false);
    translate([-y_pitch/2, -bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom, populate=false);

        
    translate([-idler_offset, -idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);
    translate([-(idler_offset*1.2)/2  ,-idler_offset-webThickness,-full_depth])
        cube([idler_offset*1.2,webThickness,idler_top]);

    translate([ idler_offset, -idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);
    translate([idler_offset,-(idler_offset*1.2)/2,-full_depth])
        cube([webThickness,(idler_offset*1.2),idler_top]);
        
    translate([-idler_offset,  idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);
    translate([-(idler_offset*1.2)/2  ,idler_offset,-full_depth])
        cube([idler_offset*1.2,webThickness,idler_top]);

    translate([ idler_offset,  idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);
    translate([-idler_offset-webThickness,-(idler_offset*1.2)/2,-full_depth])
        cube([webThickness,(idler_offset*1.2),idler_top]);


    x1 = bottom_depth/2-width_extra;
    x2 = -bottom_depth/2;
    y1 = bottom_width/2-width_extra;
    y2 = - bottom_width/2;
    z  = -full_depth+plate_thickness;
    
    translate([x1, y1, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);
    
    translate([x1, y2, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);

    translate([x2, y1, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);
    
    translate([x2, y2, z])
        cube([width_extra, 
              width_extra, 
              full_depth-plate_thickness]);
}

module plateBottom() {
    x = bottom_depth/2-width_extra/2;
    y = bottom_width/2-width_extra/2;
    z = -full_depth;

    color("Green",1) {
        union() {
            difference() {
                plateBottomPart();
                // bolt holes in corners
                translate([x,y,z])
                    cylinder(d=4.0,h=full_depth+1);
                translate([-x,y,z])
                    cylinder(d=4.0,h=full_depth+1);
                translate([x,-y,z])
                    cylinder(d=4.0,h=full_depth+1);
                translate([-x,-y,z])
                    cylinder(d=4.0,h=full_depth+1);
                // nut traps for corners
                translate([x,y,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([-x,y,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([x,-y,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([-x,-y,z])
                    cylinder(d=9.0,h=3,$fn=6);
                // holes for idler bolts
                translate([ idler_offset, idler_offset,z])
                    cylinder(d=mount_bolt,h=full_depth);
                translate([ idler_offset,-idler_offset,z])
                    cylinder(d=mount_bolt,h=full_depth);
                translate([-idler_offset, idler_offset,z])
                    cylinder(d=mount_bolt,h=full_depth);
                translate([-idler_offset,-idler_offset,z])
                    cylinder(d=mount_bolt,h=full_depth);
                // nut traps for idlers
                translate([ idler_offset, idler_offset,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([ idler_offset,-idler_offset,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([-idler_offset, idler_offset,z])
                    cylinder(d=9.0,h=3,$fn=6);
                translate([-idler_offset,-idler_offset,z])
                    cylinder(d=9.0,h=3,$fn=6);
            }
            // add solid bridging layer for corner nut traps
            translate([ x,y,z+3])
                cylinder(d=12.0,h=0.2);
            translate([-x,y,z+3])
                cylinder(d=12.0,h=0.2);
            translate([ x,-y,z+3])
                cylinder(d=12.0,h=0.2);
            translate([-x,-y,z+3])
                cylinder(d=12.0,h=0.2);

            // add solid bridging layer for idler nut traps
            translate([ idler_offset, idler_offset,z+3])
                cylinder(d=12.0,h=0.2);
            translate([ idler_offset,-idler_offset,z+3])
                cylinder(d=12.0,h=0.2);
            translate([-idler_offset, idler_offset,z+3])
                cylinder(d=12.0,h=0.2);
            translate([-idler_offset,-idler_offset,z+3])
                cylinder(d=12.0,h=0.2);
            
        }
    }
}
module Y_rods() {
    color("Blue",1) {
        translate([y_pitch/2, 150, -bearing_dia/2])
            rotate([90,0,0]) 
                cylinder(d=8, h=300);
        
        translate([-y_pitch/2, 150, -bearing_dia/2])
            rotate([90,0,0]) 
                cylinder(d=8, h=300);

        translate([0, 150, -bearing_dia/2 - 30])
            rotate([90,0,0]) 
                cylinder(d=8, h=300);
    }
}

module idlers() {
    translate([-idler_offset, -idler_offset, -full_depth+idler_top])
        idler();

    translate([ idler_offset, -idler_offset, -full_depth+idler_top])
        idler();

    translate([-idler_offset,  idler_offset, -full_depth+idler_top])
        idler();

    translate([ idler_offset,  idler_offset, -full_depth+idler_top])
        idler();    
}

module nemaMount(motor, thickness) {
    corner_rad = 5;
    length = ceil(NEMA_width(motor));
    big_hole = NEMA_big_hole(motor);

    difference() {
        translate([0, 0, thickness/2])
            cube([length, length, thickness], center = true);
        translate([0, 0, -thickness/2])
            cylinder(r=big_hole,h=2*thickness+1);
        
        // motor screw holes
        for(x = NEMA_holes(Z_motor))
            for(y = NEMA_holes(Z_motor))
                translate([x,y,0])
                    cylinder(d = 3.1, 
                             h = 2 * thickness + 1, 
                             center = true);
   }
}

module filletCut(r,h) {
    rotate([0,0,180])
        difference() {
            translate([-1,-1,0]) cube([r+1,r+1,h]);
            translate([r,r,0]) cylinder(r=r,h=h);
        }
}

module XMount() {

    length = ceil(NEMA_width(NEMA17));

    // main body
    translate([0,0,-rod_height-7.5]) {
        rotate([90,0,90]) {
            difference() {
                translate([0,Ymount_height/2,10.0/2])
                    cube([120.0, Ymount_height, 10.0], center=true);
                // rods
                translate([-y_pitch/2,rod_height,-0.5])
                    cylinder(d=8.0,h=11.0);
                translate([ y_pitch/2,rod_height,-0.5])
                    cylinder(d=8.0,h=11.0);
                translate([0, rod_height - 30, -0.5])
                    cylinder(d=8.0,h=11.0);

                // cable cutout
                translate([0,rod_height+7.5,5.0])
                    cube([20,12,11.0], center=true);
                
                // bottom cutout
                translate([0,-195,-0.5])
                    cylinder(r=200,h=11.0);
                // left cutout
                translate([-70,Ymount_height/2,-0.5])
                    cylinder(r=20,h=11.0);
                // left cutout
                translate([70,Ymount_height/2,-0.5])
                    cylinder(r=20,h=11.0);
                
                // top block rounded corners
                translate([60.0,Ymount_height,-0.5]) 
                    filletCut(r=6,h=11);
                translate([-60.0,Ymount_height,-0.5]) 
                    rotate ([0,0,90]) filletCut(r=6,h=11);

                // bottom block rounded corners
                translate([-60.0,0,-0.5]) 
                    rotate ([0,0,180]) filletCut(r=6,h=11);
                translate([ 60.0,0,-0.5]) 
                    rotate ([0,0,-90]) filletCut(r=6,h=11);

                // right nut trap
                translate([-y_pitch/2,Ymount_height-8.0, 4.5])
                    cube([6.2, 2.7,10.0],center=true);
                // left nut trap
                translate([ y_pitch/2,Ymount_height-8.0, 4.5])
                    cube([6.2, 2.7,10.0],center=true);
                // right nut trap bolt hole
                translate([-y_pitch/2,45.0+1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=3, h=40);
                // left nut trap bolt hole
                translate([ y_pitch/2,45.0+1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=3, h=40);
            }
        }
        // nema mount
        translate([-length/2,0,rod_height+7.5+6.0])
            nemaMount(NEMA17,4.0);
            
        // bracing webs
        translate([0,length/2-3,rod_height+7.5+6.0])
            rotate([-90,0,0])
                linear_extrude(height=3)
                    polygon([[0,0],[0,length/2],[-length,0]]);
        translate([0,-length/2,rod_height+7.5+6.0])
            rotate([-90,0,0])
                linear_extrude(height=3)
                    polygon([[0,0],[0,length/2],[-length,0]]);
    };
}

module YMountBack() {
    // main body
    translate([0,0,-Xrod_height+7.5]) {
        rotate([90,0,90]) {
            difference() {
                translate([0,Xmount_height/2,10.0/2])
                    cube([x_pitch+15, 
                          Xmount_height, 
                          10.0], center=true);
                // rods
                translate([-x_pitch/2,Xrod_height,-0.5])
                    cylinder(d=8.0,h=11.0);
                translate([ x_pitch/2,Xrod_height,-0.5])
                    cylinder(d=8.0,h=11.0);

                // cable cutout
                translate([0,Xrod_height-7.5,5.0])
                    cube([20,12,11.0], center=true);
                
                // top block rounded corners
                translate([(x_pitch+15)/2,Xmount_height,-0.5]) 
                    filletCut(r=6,h=11);
                translate([-(x_pitch+15)/2,Xmount_height,-0.5]) 
                    rotate ([0,0,90]) filletCut(r=6,h=11);

                // bottom block rounded corners
                translate([-(x_pitch+15)/2,0,-0.5]) 
                    rotate ([0,0,180]) filletCut(r=6,h=11);
                translate([ (x_pitch+15)/2,0,-0.5]) 
                    rotate ([0,0,-90]) filletCut(r=6,h=11);

                // right nut trap
                translate([-x_pitch/2,Xrod_height-8.0, 4.5])
                    cube([6.2, 2.7,10.0],center=true);
                // left nut trap
                translate([ x_pitch/2,Xrod_height-8.0, 4.5])
                    cube([6.2, 2.7,10.0],center=true);
                // right nut trap bolt hole
                translate([-x_pitch/2,-1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=3, h=Xrod_height);
                // left nut trap bolt hole
                translate([ x_pitch/2,-1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=3, h=Xrod_height);

                // idler bolt hole
                translate([ 0,-1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=4, h=Xmount_height+2);
                // idler bolt nut trap
                translate([ 0,-1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=8.8, h=3, $fn=6);
            }
        }
    }
}

module YMountFront() {
    // main body
    
    Xmount_width = x_pitch+25;
    translate([0,0,-Xrod_height+7.5]) {
        rotate([90,0,90]) {
            union() {
                difference() {
                    translate([0,Xmount_height/2,10.0/2])
                        cube([Xmount_width, 
                              Xmount_height, 
                              10.0], center=true);
                    // rods
                    translate([-x_pitch/2,Xrod_height,-0.5])
                        cylinder(d=8.0,h=11.0);
                    translate([ x_pitch/2,Xrod_height,-0.5])
                        cylinder(d=8.0,h=11.0);

                    // belt cutout
                    translate([-7,Xrod_height-7.5,5.0])
                        cube([2.0,7.5,11.0], center=true);
                    translate([ 7,Xrod_height-7.5,5.0])
                        cube([2.0,7.5,11.0], center=true);

                    translate([-8,Xrod_height-3.75,1]) 
                        rotate ([0,90,-90]) filletCut(r=3,h=7.5);
                    translate([ 8,Xrod_height-3.75,1]) 
                        rotate ([90,180,0]) filletCut(r=3,h=7.5);
                    

                    // belt slot left
                    translate([x_pitch/2,Xrod_height-7.5,0])
                        cube([Xmount_width/2,6.5,2], center=true);
                    // belt slot right
                    translate([-x_pitch/2,Xrod_height-7.5,0])
                        cube([Xmount_width/2,6.5,2], center=true);
                    
                    // top block rounded corners
                    translate([Xmount_width/2,Xmount_height,-0.5]) 
                        filletCut(r=6,h=11);
                    translate([-Xmount_width/2,Xmount_height,-0.5]) 
                        rotate ([0,0,90]) filletCut(r=6,h=11);

                    // bottom block rounded corners
                    translate([-Xmount_width/2,0,-0.5]) 
                        rotate ([0,0,180]) filletCut(r=6,h=11);
                    translate([ Xmount_width/2,0,-0.5]) 
                        rotate ([0,0,-90]) filletCut(r=6,h=11);

                    // right nut trap
                    translate([-x_pitch/2,Xrod_height-14.0, 4.5])
                        cube([6.2, 2.7,10.0],center=true);
                    // left nut trap
                    translate([ x_pitch/2,Xrod_height-14.0, 4.5])
                        cube([6.2, 2.7,10.0],center=true);
                    // right nut trap bolt hole
                    translate([-x_pitch/2,-1,5.0])
                        rotate([-90,0,0])
                            cylinder(d=3, h=Xrod_height);
                    // left nut trap bolt hole
                    translate([ x_pitch/2,-1,5.0])
                        rotate([-90,0,0])
                            cylinder(d=3, h=Xrod_height);

                    // right rod nut trap bolt hole
                    translate([-x_pitch/2,-1,5.0])
                        rotate([-90,0,0])
                            cylinder(d=3, h=Xrod_height);
                    // left rod nut trap bolt hole
                    translate([ x_pitch/2,-1,5.0])
                        rotate([-90,0,0])
                            cylinder(d=3, h=Xrod_height);

                    // bolt hole top centre
                    translate([0, Xrod_height+5,-1])
                        cylinder(d=3.0,h=12);
                    // nut trap
                    translate([0, Xrod_height+5,8])
                        cylinder(d=6.0,h=4,$fn=6);

                    // bolt hole bottom right
                    translate([-Xmount_width/2+5,5,-1])
                        cylinder(d=3.0,h=12);
                    // nut trap
                    translate([-Xmount_width/2+5,5,8])
                        cylinder(d=6.0,h=4,$fn=6);
                    // bolt hole bottom left
                    translate([ Xmount_width/2-5,5,-1])
                        cylinder(d=3.0,h=12);
                    // nut trap
                    translate([ Xmount_width/2-5,5,8])
                        cylinder(d=6.0,h=4,$fn=6);
                };
                // bridging layer for top centre nut trap
                translate([0, Xrod_height+5,8])
                    cylinder(d=6.0,h=0.2);
                // bridging layer for bottom right nut trap
                translate([-Xmount_width/2+5,5,8])
                    cylinder(d=6.0,h=0.2);
                // bridging layer for bottom right nut trap
                translate([Xmount_width/2-5,5,8])
                    cylinder(d=6.0,h=0.2);
            }
        }
    }
}

module ZMountFixed() {
    // main body
    
    Xmount_width = x_pitch+25;
    thickness = 8;
    color("Green",1) {
        translate([0,0,-Xrod_height+7.5]) {
            rotate([90,0,90]) {
                union() {
                    difference() {
                        translate([0,Xmount_height/2,6.0/2])
                            cube([Xmount_width, 
                                  Xmount_height, 
                                  6.0], center=true);
                        // top block rounded corners
                        translate([Xmount_width/2,Xmount_height,-0.5]) 
                            filletCut(r=6,h=11);
                        translate([-Xmount_width/2,Xmount_height,-0.5]) 
                            rotate ([0,0,90]) filletCut(r=6,h=11);

                        // bottom block rounded corners
                        translate([-Xmount_width/2,0,-0.5]) 
                            rotate ([0,0,180]) filletCut(r=6,h=11);
                        translate([ Xmount_width/2,0,-0.5]) 
                            rotate ([0,0,-90]) filletCut(r=6,h=11);


                        // bolt hole top centre
                        translate([0, Xrod_height+5,-1])
                            cylinder(d=3.0,h=12);
                        // bolt hole bottom right
                        translate([-Xmount_width/2+5,5,-1])
                            cylinder(d=3.0,h=12);
                        // bolt hole bottom left
                        translate([ Xmount_width/2-5,5,-1])
                            cylinder(d=3.0,h=12);
                    };
                    // left rod slide
                    translate([z_pitch/2,Xmount_height/2,-4]) {
                        difference() {
                            cube([10,Xmount_height,10],center=true);
                            cube([12,Xmount_height-8,10.5],
                                     center=true);
                            translate([0,(Xmount_height+2)/2,-2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=Xmount_height + 2);
                        }
                    }
                    // right rod slide
                    translate([-z_pitch/2,Xmount_height/2,-4]) {
                        difference() {
                            cube([10,Xmount_height,10],center=true);
                            cube([12,Xmount_height-8,10.5],
                                     center=true);
                            translate([0,(Xmount_height+2)/2,-2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=Xmount_height + 2);
                        }
                    }
                    // servo mount
                    translate([0,38,4.5]) {
                        difference() {
                            cube([40,
                                  18, 
                                  3], center=true);
                            cube([23.0,
                                  12.5, 
                                  5], center=true);
                            // screw hole
                            translate([-14, 0, -3])
                                cylinder(d=2.0,h=12);
                            // screw hole
                            translate([ 14, 0, -3])
                                cylinder(d=2.0,h=12);
                           // rounded corners
                            translate([20,9,-4]) 
                                rotate ([0,0,0]) filletCut(r=6,h=11);
                            translate([-20,9,-4]) 
                                rotate ([0,0,90]) filletCut(r=6,h=11);

                        }
                    }
                }
            }
        }
    }
}

module ZMountMoving() {
    // main body
    
    Xmount_width = z_pitch+6;
    thickness = 8;
    color("Brown",1) {
        translate([0,0,-Xrod_height+7.5]) {
            rotate([90,0,90]) {
                union() {
                    // main back
                    difference() {
                        translate([0,17,-10])
                            cube([Xmount_width, 
                                  62, 
                                  6.0], center=true);
                        translate([10,26.5,-15]) cylinder(d=4,h=15);
                        translate([10,26.5,-10]) cylinder(d=9,h=3,$fn=6);

                    };
                    // servo face
                    translate([0,50,-4])
                        cube([Xmount_width, 
                              4, 
                              18], center=true);

                    // left rod slide1
                    translate([z_pitch/2,-9,-4]) {
                        difference() {
                            cube([6,10,10],center=true);
                            translate([0,12,2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=24);
                        }
                    }
                    // left rod slide2
                    translate([z_pitch/2,43,-4]) {
                        difference() {
                            cube([6,10,10],center=true);
                            translate([0,12,2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=24);
                        }
                    }
                    // right rod slide1
                    translate([-z_pitch/2,-9,-4]) {
                        difference() {
                            cube([6,10,10],center=true);
                            translate([0,12,2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=24);
                        }
                    }
                    // right rod slide2
                    translate([-z_pitch/2,43,-4]) {
                        difference() {
                            cube([6,10,10],center=true);
                            translate([0,12,2])
                                rotate([90,0,0])
                                    cylinder(d=3.0,h=24);
                        }
                    }
                }
            }
        }
    }
}

module PenHolder() {
    
    thickness = 3;
    color("Pink",1) {
        translate([0,0,4]) {
            rotate([90,0,90]) {
                difference() {
                    union() {
                        translate([10,10,-3]) cylinder(d=20,h=6);
                        difference() {
                            union() {
                                // main back
                                translate([0,-1,0])
                                    cube([18, 
                                          60, 
                                          6], center=true);
                                // top
                                translate([0,27,-2])
                                    cube([18, 
                                          4, 
                                          8], center=true);
                                // bottom
                                translate([0,-29,-2])
                                    cube([18, 
                                          4, 
                                          8], center=true);
                                // ring
                                translate([0,-10,-9])
                                    cube([18, 
                                          8, 
                                          22], center=true);
                            };
                            // groove in top
                            translate([ 0, 20,-11]) 
                                rotate ([-90,0,0]) cylinder(d=12.5, h=10);
                            // groove in bottom
                            translate([ 0,-35,-11]) 
                                rotate ([-90,0,0]) cylinder(d=12.5, h=10);

                            // hole in ring
                            translate([ 0,-20,-11]) 
                                rotate ([-90,0,0]) cylinder(d=12.5, h=20);
                            // square hole in ring
                            translate([ 0,-10,-6.625]) 
                               rotate ([-90,0,0])
                                    cube([12.5,7.25,15],center=true);

                            // rounded corner on ring
                            translate([-9,-20,-20]) 
                                rotate ([-90,90,0]) filletCut(r=8,h=20);
                            translate([ 9,-20,-20]) 
                                rotate ([-90,0,0])  filletCut(r=8,h=20);


                        }
                        // bottom screw block
                        translate([0,-10,-22])
                            cube([10, 
                                  8, 
                                  6], center=true);
                    }
                    translate([ 0,-10,-30])
                       rotate ([0,0,0]) cylinder(d=2,h=20);
                    translate([10,10,-4]) cylinder(d=4,h=20);
                }
            }
        }
    }
}




//plateBottom();
//idlers();
//Y_rods();
//plateTop();
//X_rods();

translate([ 0,-150, 0]) rotate([0,0,90])  XMount();
//translate([ 0, 150, 0]) rotate([0,0,-90]) XMount();
//translate([-200, 0, 0]) rotate([0,0,0])   YMountBack();
//translate([ 200, 0, 0]) rotate([0,0,180])  YMountFront();
//translate([ 210, 0, 0]) rotate([0,0,180])  ZMountFixed();
//translate([ 214, 0, 0]) rotate([0,0,180])  ZMountMoving();
//translate([ 230, 0, 0]) rotate([0,0,180])  PenHolder();

