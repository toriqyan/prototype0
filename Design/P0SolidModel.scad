// Prototype0 Is an amazon echo like product designed for a few use cases
// Home theater -- I want to play episodes of anime...
// Call my friends over webRTC for Dementia/Memory care seniors
// Remind/track my pills
// Notes.
// Email.
// Texting to phones.

// The physical design is contained in this file.  The BOM, so far is:
// A vensmile iPC002 -- 5.827" x 3.11" x 0.362"
// An EnerPlex bluetooth speaker AC-SPEAK-BL -- 2" x2" x2.5"
// An array Microphone -- r=5.5", h = 1.5"

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Includes and constants
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
use <../../Common_Drawings/External/ExternalDrawings.scad>;
include <../../Common_Drawings/ImranDesigned/ScrewsNutsWashers.scad>;
use <../../Common_Drawings/ImranDesigned/Electrical.scad>;
use <../../Common_Drawings/ImranDesigned/MiscParts.scad>;

// For my RepRap
g_nHoleErrorXY = 0.40; // This is to handle the hole error due to whatever process I'm using ( printing, etc... )
g_nHoleErrorXZ = 0.40; // This is to handle the hole error due to whatever process I'm using ( printing, etc... )
g_nPostError = .19; // Turns out posts have different error than holes.
g_nPostEccentricityError = 0.45; // This is the "elipse" error diameter between major/minor axis in posts.
g_qualityFactor = 0.55; // For circular things how many faces should we show?
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 3d models of the existing BOM parts
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This is the vensmilePC
module thePC()
{
	// units are mm
	Width = 148.01;
	Height = 9.21;
	Depth  =  78.99;
	FaceNumber = 100 * g_qualityFactor;
	color("silver")
		hull()
			for ( x = [-Width/2 + Height, Width/2 - Height])
				translate([x, 0 ,0])
					rotate([90, 0, 0])
						cylinder( r = Height/2, h = Depth, $fn = FaceNumber, center = true);
} // end module

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This is the bluetooth speaker
module theSpeaker()
{
	// units are mm
	Width = 25.4 * 2;
	Height = 25.4 * 2.5;
	Depth  =  25.4 * 2;
	color("cyan")
		RoundedCube(Width, Depth, Height, 3);
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This is the array mic.  It's made from 2 parts -- a bottom cylnder and a top cone.
module theMic()
{
	// units are mm
	Radius = 25.4 * 5.5/2;
	BottomHeight = 25.4 * 1;
	TopHeight = 25.4 * 0.5;
	TopRadius = 25.4 * 0.5;
	FaceNumber = 100 * g_qualityFactor;
	
	color("darkgrey")
	union()
	{
		cylinder( r = Radius, h = BottomHeight, $fn=55);
			translate([0, 0, BottomHeight])
				cylinder( r1 = Radius, r2 = TopRadius, h = TopHeight, $fn = FaceNumber);
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// SubAssemblies
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This module is designed to float all the BOM pieces in the air, relative to the PC.
module positionBOM()
{
	thePC();
	translate([ 0, 0, 140])
		theMic();
		
	translate([ 0, 0, 115])
		rotate([90, 0, 0])
			theSpeaker();
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This sphere is the I/O sphere attached to the PC base, supported by mounts of some sort.
module ioSphere( mainRadius = 77 )
{
	Faces = 100 * g_qualityFactor;
	difference()
	{
		sphere( r = mainRadius, $fn = Faces);
		sphere( r = mainRadius - 3, $fn = Faces);
			translate([0, 0, mainRadius])
				cube( size = [mainRadius*2, mainRadius*2, mainRadius*2], center = true);
		rotate([0, 0, 90])
		for ( omega = [-80 : 5 : -30])
			rotate([0, omega, 0])
				for ( theta = [-45 : 5 : 45])
					rotate([theta, 0 ,0])
						cylinder( r = 2, h = (mainRadius + 10) * 2, $fn = 6, center = true);
	}
	// a shelf for the speaker.
	intersection()
	{
		sphere( r = mainRadius-2, $fn = Faces);
		translate([0, 0, -63])
			cylinder(r = mainRadius, h = 3, $fn = Faces);
	}
	// A backing to print from, hide some wires...
	translate([0, -mainRadius -5, 0])
		rotate([90, 0, 0])
		{
			difference()
			{
				RoundedCube( 40, 30, 20, 2);
				translate([0, 5, 0])
					cube(size = [20, 10, 25], center = true);
				//cube(size = [20, 20, 25], center = true);
					
				for ( x = [-1,1])
					translate([-14 * x, -20, 0])
						rotate([-90, 0, 0])
							5mmSlug(5, 30);
			}
		}
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
module hulledPyramid(supportThickness = 4, pcHeight = 10, pcDepth = 80, pcWidth = 150, topHeight = 50)
{
	hull()
	{
		for ( x = [-pcWidth/2, pcWidth/2])
			translate([x, 0, pcHeight])
				rotate( [90, 0, 0] )
					cylinder( r = supportThickness, $fn= 55, center = true, h = pcDepth + 3);
		translate([0, 0, topHeight])
			rotate( [90, 0, 0] )
				cylinder( r = supportThickness, $fn= 55, center = true, h = pcDepth + 3);
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Module:
//	This is the base to hide the PC 
// 	Width = 148.01;
//	Height = 9.21;
//	Depth  =  78.99;
module baseForPC( pcWidth = 150, pcDepth = 80, pcHeight = 10)
{
	difference()
	{
		RoundedCube(pcWidth + 6, pcDepth + 3, pcHeight + 3, 3);
		translate([0, -3/2, -pcHeight/4 + 0.9])
			cube( size = [pcWidth, pcDepth, pcHeight], center = true);
		
		// build a matrix of holes...
		
		for ( x = [-pcWidth/2 + 10 : 8 : pcWidth/2 - 10])
			for ( y = [-pcDepth/2 + 10 : 10 : pcDepth/2 - 10] )
				translate([x, y, 0])
					cylinder(r=2, h=20, $fn = 55, center = true);
	}
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
module connectionGlass( mainRadius = 77)
{
	stemRadius = 6;
	Faces = 100 * g_qualityFactor;

	// Three pieces -- a cone on bottom, a stem, and a cone on top with a divot
	difference()
	{
		cylinder( r1 = 40, r2 = stemRadius, $fn = 100, center = true, h = 15);
		for ( x = [-mainRadius/2 + 10 : 8 : mainRadius/2 - 10])
			for ( y = [-mainRadius/2 + 10 : 10 : mainRadius/2 - 10] )
				translate([x, y, 0])
					cylinder(r=2, h=20, $fn = 55, center = true);
	}
	
	translate([0, 0, 50])
	{
		difference()
		{
			union()
			{
				cylinder( r1 = stemRadius, r2 = stemRadius * 4, $fn = 100, center = true, h = stemRadius * 4);
				translate([0, 0, -55])
					cylinder( r = stemRadius, h = 50, $fn = 55 );
			}
			translate([0, 0, mainRadius])
				sphere( r = mainRadius, $fn = Faces);
			
		}	
	}
	
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
// main area
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
module mainAssembly()
{
	%translate( [0, 0, 150] )
		difference()
		{
			ioSphere();
		}
	translate([0, 0, 14])
		connectionGlass();
	baseForPC();
	positionBOM();
}

//mainAssembly();
module printIoSphere()
{
	rotate([90, 0, 0])
		ioSphere();
}

module printBaseForPC()
{
	rotate([180,0,0])
	baseForPC();
}

connectionGlass();