include <conf/config.scad>
use <bearing-holder.scad>

bearing         = LM8UU;
bearing_length  = bearing[0];
bearing_dia     = bearing[1];

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
            translate([x_pitch/2, 75, -bearing_dia/2])
                rotate([90,0,0]) 
                    cylinder(d=8, h=150);
            
            translate([-x_pitch/2, 75, -bearing_dia/2])
                rotate([90,0,0]) 
                    cylinder(d=8, h=150);
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
        translate([y_pitch/2, 75, -bearing_dia/2])
            rotate([90,0,0]) 
                cylinder(d=8, h=150);
        
        translate([-y_pitch/2, 75, -bearing_dia/2])
            rotate([90,0,0]) 
                cylinder(d=8, h=150);
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

//plateBottom();
//idlers();
//Y_rods();
plateTop();
//X_rods();
