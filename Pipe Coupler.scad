/* 

Pipe Connector Plug 
Eric Vitiello, 2025





*/

$fn=128;

topType = "barbed";
topRingHeight = 1;
topRingOuterDiameter = (3/8);
topWallWidth = .125;
topBarbCount = 4;
topBarbWidth = .125;
topBarbHeight = topRingHeight/topBarbCount;

middleLayer = true;
middleLayerDiameter = 1.25;
middleLayerWallWidth = .75;
middleLayerHeight = .125;

bottomType = "tube";
bottomRingHeight = 1;
bottomRingOuterDiameter = 1+(1/16);
bottomWallWidth = .125;
bottomBarbCount = 4;
bottomBarbWidth = 6;
bottomBarbHeight = bottomRingHeight/bottomBarbCount;


// Top
translate ([0,0,(middleLayerHeight+bottomRingHeight)]) {
	side(topType,
		topRingOuterDiameter,
		topRingHeight,
		topWallWidth,
		topBarbCount,
		topBarbHeight,
		topBarbWidth,
		false
	);
}

// Middle
translate ([0,0,bottomRingHeight]) {
	if (middleLayer == true) {
		tube(middleLayerDiameter, middleLayerHeight, middleLayerWallWidth);
	}
}

// bottom
translate ([0,0,0]) {
	side(bottomType,
		bottomRingOuterDiameter,
		bottomRingHeight,
		bottomWallWidth,
		bottomBarbCount,
		bottomBarbHeight,
		bottomBarbWidth
	);
}


module side(type, diameter, height, wallWidth, barbCount, barbHeight, barbWidth, flipped) {
	if (type == "barbed") {
		barbedTube(
			height,
			diameter, 
			wallWidth,
			barbCount, 
			barbHeight,
			barbWidth,
			flipped
		);
	} else {
		tube(diameter, height, wallWidth);
	}
}


module tube(diameter, height, wallWidth) {
	radius = diameter/2;
    difference() {
		cylinder(height, radius, radius, false);
		cylinder(height, (diameter-wallWidth)/2, (diameter-wallWidth)/2, false);
    }
}

module barbedTube(tubeHeight, outerDiameter, wallWidth, barbCount, barbHeight, barbWidth, flipped) {
    // Calculate proper spacing of barbs
    local_barb_spacing = tubeHeight / barbCount;
	innerDiameter = outerDiameter - (wallWidth);
    
    union() {
        tube(outerDiameter, tubeHeight, wallWidth);
        
        // Create barbs along the tube
        for (i = [0:barbCount-1]) {
            barb(
                i * local_barb_spacing, 
                outerDiameter, 
                innerDiameter, 
                barbHeight, 
                barbWidth,
				flipped
            );
        }
    }
}

module barb(position, outerDiameter, innerDiameter, height, overhang, flipped) {
    translate([0, 0, position]) {
        difference() {
			if (flipped == false) {
				cylinder(h=height, d2=outerDiameter, d1=outerDiameter + overhang*2, center=false);
			} else {
				cylinder(h=height, d2=outerDiameter + overhang*2, d1=outerDiameter, center=false);
			}
            cylinder(h=height, d=innerDiameter, center=false);
        }
    }
}

