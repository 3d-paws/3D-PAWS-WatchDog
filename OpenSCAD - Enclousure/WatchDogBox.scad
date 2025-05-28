// ====== PARAMETERS ======
inner_length = 67;
inner_width = 29;
inner_height = 18;

wall_thickness = 2;
corner_radius = 5; // <<--- Add this for rounded corners
slot_width = 5;
slot_height = 5;

// Battery and Jumper Slot
slot_bj_x = 8; // from the left
slot_bj_width = 28;
slot_bj_height = 6;

// USB Left Slot
slot_ul_width = 14;
slot_ul_height = inner_height-3;

flange_ul_width = slot_ul_width;
flange_ul_height = inner_height - 11;

// USB Right Slot
slot_ur_width = 11;
slot_ur_height = inner_height -3;

flange_ur_width = slot_ur_width;
flange_ur_height = inner_height - 8;

lid_thickness = 2 * wall_thickness;
lid_insert = lid_thickness / 2;


// Slot positions (on one side, y = 0 face)
slot1_x = inner_length/2 - slot_width/2; // Centered
slot2_x = inner_length - 10 - slot_width; // 10mm from right edge

lid_overlap = 8; // How much the lid slides over the box
lid_clearance = 0.1; // Clearance for sliding fit

// ====== DERIVED DIMENSIONS ======
outer_length = inner_length + 2*wall_thickness;
outer_width = inner_width + 2*wall_thickness;
outer_height = inner_height + wall_thickness; // Lid sits on top

// New slot vertical position
slot_bottom_z = outer_height - (slot_height-0.5); // 10mm below top inside, minus slot height

// ====== MODULES ======

// Rounded box module
module rounded_box(length, width, height, radius) {
    hull() {
        for (x = [radius, length - radius])
        for (y = [radius, width - radius])
            translate([x, y, 0])
                cylinder(r=radius, h=height, $fn=32);
    }
}

// Main box with two cable slots and rounded edges
module logger_box() {
    difference() {
        // Outer shell with rounded edges
        rounded_box(outer_length, outer_width, outer_height, corner_radius);

        // Hollow out for internal space (rounded edges)
        translate([wall_thickness, wall_thickness, wall_thickness])
            rounded_box(inner_length, inner_width, inner_height, max(0,            corner_radius - wall_thickness));
        
        // Battery and Jumpers Slot
        translate([wall_thickness + slot_bj_x, outer_width - wall_thickness, wall_thickness + 4])
            #cube([slot_bj_width, wall_thickness, slot_bj_height]);
        
        // USB Left Slot - centered on left wall
        translate([
            0, // Slightly outside the left wall to ensure subtraction
            (outer_width - slot_ul_width) / 2,
            wall_thickness+3 // Bottom aligned with inner cavity
        ])
            #cube([wall_thickness, slot_ul_width, slot_ul_height]);

        // USB Right Slot - centered on right wall
        translate([
            outer_length-wall_thickness,
            (outer_width - slot_ur_width) / 2, wall_thickness+3
            
        ])
            #cube([wall_thickness, slot_ur_width, slot_ur_height]);
        
            // #cube([wall_thickness, flange_ur_width, flange_ur_height]);
    }
}

module flat_lid() {
    lid_thickness = wall_thickness;
    lid_insert = wall_thickness * 2;

    lid_outer_length = outer_length;
    lid_outer_width = outer_width;
    lid_outer_height = lid_thickness;

    groove_length = lid_outer_length - 2 * wall_thickness;
    groove_width = lid_outer_width - 2 * wall_thickness;
    groove_height = lid_insert;

    difference() {
        union() {
            // Outer lid with rounded edges
            rounded_box(
                lid_outer_length,
                lid_outer_width,
                lid_outer_height, 
                corner_radius);

            // Groove inside the lid (inner lip)
            translate([wall_thickness, wall_thickness, 0])
                rounded_box(
                    groove_length, 
                    groove_width,
                    groove_height,
                    max(0, corner_radius - wall_thickness));
        }

        // === Engraving on the underside ===
        translate([lid_outer_length / 2, lid_outer_width / 2, -0.1])
            rotate([0, 0, 180])
                linear_extrude(height = wall_thickness-0.9)
                    mirror([1, 0, 0])
                        #text("WatchDog", 
                            size = 6, 
                            font = "Arial",
                            halign = "center",
                            valign = "center");
    }
    
    // USB Left Flange
    translate([0,(lid_outer_width-flange_ul_width) / 2, wall_thickness])
        #cube([wall_thickness, flange_ul_width, flange_ul_height]);
    
    // USB Right Flange
    translate([(lid_outer_length-wall_thickness),(lid_outer_width-flange_ur_width) / 2, wall_thickness])
        #cube([wall_thickness, flange_ur_width, flange_ur_height]);

}




// ====== ASSEMBLY ======
logger_box(); // Place at XYZ origion
translate([0, outer_width + 10, 0]) flat_lid(); // Place along Y axis

