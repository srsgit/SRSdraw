include <conf/config.scad>
use <bearing-holder.scad>


bearing         = LM8UU;
bearing_length  = bearing[0];
bearing_dia     = bearing[1];

stepper         = NEMA17;
x_pitch         = 50.0;
y_pitch         = 70.0;
belt_gap        = 12.0;
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

belt_guide_height = full_depth - belt_width /2 - belt_clearance /2;

Ymount_height   = 70;
rod_height      = Ymount_height - 25;

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
    top_y_pitch = (bottom_depth - bearing_holder_length(bearing));
    
    translate([0, 0, plate_thickness/2 - bottom - bearing_dia/2])
        cube([bottom_width, 
              bottom_depth, 
              plate_thickness], center = true);

    translate([ x_pitch/2,  top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([ x_pitch/2, -top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([-x_pitch/2,  top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([-x_pitch/2, -top_y_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
   
    translate([-idler_offset, -idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);

    translate([ idler_offset, -idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);

    translate([-idler_offset,  idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);

    translate([ idler_offset,  idler_offset, -full_depth])
        idlerMountTop(d=mount_diameter, h=idler_top);
        
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
    bottom_x_pitch = (bottom_width - bearing_holder_length(bearing));
    
    translate([0, 0, plate_thickness/2 - bottom - bearing_dia/2])
        cube([bottom_depth, 
              bottom_width, 
              plate_thickness], center = true);

    translate([ y_pitch/2,  bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([ y_pitch/2, -bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([-y_pitch/2,  bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);
    translate([-y_pitch/2, -bottom_x_pitch/2, -bearing_dia/2])
        bearing_holder(bearing, bottom);

        
    translate([-idler_offset, -idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);

    translate([ idler_offset, -idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);

    translate([-idler_offset,  idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);

    translate([ idler_offset,  idler_offset, -full_depth])
        idlerMount(d=mount_diameter, h=idler_top);

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

module YMount() {

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
                translate([-y_pitch/2,Ymount_height-15.0, 4.5])
                    cube([6.0, 2.5,10.0],center=true);
                // left nut trap
                translate([ y_pitch/2,Ymount_height-15.0, 4.5])
                    cube([6.0, 2.5,10.0],center=true);
                // right nut trap bolt hole
                translate([-y_pitch/2,35.0+1,5.0])
                    rotate([-90,0,0])
                        cylinder(d=3, h=40);
                // left nut trap bolt hole
                translate([ y_pitch/2,35.0+1,5.0])
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

module XMountL() {
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
                    cube([6.0, 2.5,10.0],center=true);
                // left nut trap
                translate([ x_pitch/2,Xrod_height-8.0, 4.5])
                    cube([6.0, 2.5,10.0],center=true);
#                // right nut trap bolt hole
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
                        cylinder(d=3, h=Xmount_height+2);

            }
        }
    }
}

module XMountR() {
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
                    cube([6.0, 2.5,10.0],center=true);
                // left nut trap
                translate([ x_pitch/2,Xrod_height-8.0, 4.5])
                    cube([6.0, 2.5,10.0],center=true);
#                // right nut trap bolt hole
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
                        cylinder(d=3, h=Xmount_height+2);

            }
        }
    }
}

translate([0,-150, 0]) rotate([0,0,90])  YMount();
translate([0, 150, 0]) rotate([0,0,-90]) YMount();
translate([200, 0, 0]) rotate([0,0,180]) XMountL();
translate([-200, 0, 0]) rotate([0,0,0]) XMountL();

plateBottom();
idlers();
Y_rods();
plateTop();
X_rods();
