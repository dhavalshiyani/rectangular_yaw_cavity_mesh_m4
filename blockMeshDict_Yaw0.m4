//blockMesh: Block mesh description file
//Author: Dhaval Shiyani
/*MIT License

Copyright (c) [2017] [Dhaval Shiyani]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/
//*****************************************************//

// Include this header as is in all blockMesh m4 files 
// Begin Header
FoamFile
{
version 2.0;
`format' ascii;

root	"";
case	"";
instance "constant";
local    "mesh";

class dictionary;
object blockMeshDict;
}
// *****************************
changecom(//)changequote([,])
define(calc, [esyscmd(perl -e 'printf ($1)')])
define(VCOUNT, 0)
define(vlabel, [[// ]Vertex $1 = VCOUNT define($1, VCOUNT)define([VCOUNT], incr(VCOUNT))])
//End Header



  convertToMeters 1;

  //Constants
  define(Sin, 0.9659258263) //sin(75)
  define(Cos, 0.2588190451) //cos(75) 

  //Geometric Variables

  //Cavity
  define(L, 0.032)	//CavityFloor Length
  define(D, 0.032)     //Cavity Depth
  define(W, 0.26)	//Cavity Width

  //Domain
  define(V1, 0.3)    //Domain Height 1
  define(FEL, 0.381)   //Exit_FlatPlate Length
  define(FIL, 0.4)        //Inlet_FlatPlate Length

  //Intermediate geometric variables for yaw
  define(x2, L) //Look at diagram
  define(x1, 0) //Look at diagram
  define(z1, 0) //Look at diagram
  define(z2, W) //Look at diagram

  define(z3, calc(5*D))  //Sideplate width
  define(z4, calc(5*D))
  define(zint, W)
  define(xint, L)

  define(DW, calc(z1+z2+(2*z3)))  //Domain Width
  define(TX, calc(FEL+xint))
  define(TY, calc(V1+V2))

  //Grading variables
  define(ncx, 30)	//Cavity x direction number of cells
  define(ncy, 40)	//Cavity y direction number of cells
  define(ncz, 140)      //Cavity z direction number of cells

  define(ny, 50)	//y direction number of cells over the front, center & back 
  define(nz, 30)	//z direction number of cells over the front & back 
  
  define(nix, 80)	//x direction number of cells inlet plate
  define(nex, 75)	//x direction number of cells exit plate   

  vertices
  (
    //Cavity co-ordinates
    (0  0 0)		vlabel(f0)
    (0 -D 0)		vlabel(f1)
    (0 V1 0)		vlabel(f67c)
    (L -D 0)		vlabel(f2)
    (L  0 0)		vlabel(f3)
    (x1  0 -z2)		vlabel(b14)
    (x1 -D -z2)		vlabel(b15)
    (xint -D -zint)	vlabel(b16)
    (xint  0 -zint)	vlabel(b17)
    (xint V1 -zint)      vlabel(b24c)

    //Inlet-Block-Center 
    (-FIL V1 z3)  	vlabel(f8)
    (-FIL 0  z3)	vlabel(f9)
    (-FIL 0    0)       vlabel(fi10)
    (-FIL V1   0)       vlabel(fi11)
    (x2  V1  z1)	vlabel(f6)
    (-FIL V1 -z2)  	vlabel(b22)
    (-FIL 0  -z2)	vlabel(b23)
    (x1  V1 -z2)	vlabel(b20)

    //Extra co-ordinates for sideplates - back
    (-FIL 0 -calc(z2+z3)) vlabel(b24)
    (-FIL V1 -calc(z2+z3)) vlabel(b25)
    (x1 0 -calc(z2+z3)) vlabel(b26)
    (x1 V1 -calc(z2+z3)) vlabel(b27)
    (xint 0 -calc(z2+z3)) vlabel(b28)  
    (xint V1 -calc(z2+z3)) vlabel(b29)
    
    //Extra co-ordinates for sideplates - front
    (0 0 z3) vlabel(f10)
    (0 V1 z3) vlabel(f11)
    (x2 0 z3) vlabel(f12)
    (x2 V1 z3) vlabel(f13)
    (TX 0 z3)  vlabel(f14)
    (TX V1 z3) vlabel(f15) 

    //Exit-Block-Center near boundary  co-ordinates
    (TX 0 z1)		vlabel(f4)
    (TX V1 z1)		vlabel(f5)
    (TX 0  -zint)        vlabel(fi12)
    (TX V1 -zint)        vlabel(fi13)
    (TX 0 -calc(z2+z3))	vlabel(b18)
    (TX V1 -calc(z2+z3)) vlabel(b19)

  );

  blocks
  (
    //cavityblock
    hex (f3 f2 f1 f0 b17 b16 b15 b14) (ncy ncx ncz) 
	simpleGrading 
	(
		(
			(35 40 5)	//35% y-dir, 40% cells, expansion = 5
			(30 20 1)	//30% y-dir, 20% cells, expansion = 1
			(35 40 0.2) 	//35% y-dir, 40% cells, expansion = 1/5
		)
		(
			(35 40 10)	//35% y-dir, 40% cells, expansion = 10
			(30 10 1)	//30% y-dir, 10% cells, expansion = 1
			(35 40 0.1) 	//35% y-dir, 40% cells, expansion = 1/10
		)
		(
			(35 40 12)	//35% y-dir, 40% cells, expansion = 12
			(30 13 1)	//30% y-dir, 13% cells, expansion = 1
			(35 40 0.08334) //35% y-dir, 40% cells, expansion = 1/12
		)
	)

    //Over Cavity front
    hex (f13 f12 f10 f11 f6 f3 f0 f67c) (ny ncx nz) 
	simpleGrading 
	(
		(
			(35 40 10)	//35% y-dir, 40% cells, expansion = 10
			(30 20 1)	//30% y-dir, 20% cells, expansion = 1
			(35 40 0.1) 	//35% y-dir, 40% cells, expansion = 1/10
		)
		(
			(35 40 10)	//35% y-dir, 40% cells, expansion = 10
			(30 10 1)	//30% y-dir, 10% cells, expansion = 1
			(35 40 0.1) 	//35% y-dir, 40% cells, expansion = 1/10
		)
		0.0625
	) 

    //ShortEdge over cavity - Center
    hex (f6 f3 f0 f67c b24c b17 b14 b20) (ny ncx ncz) 
	simpleGrading 
	(
		(
			(35 40 10)	//35% y-dir, 40% cells, expansion = 10
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) 	//35% y-dir, 40% cells, expansion = 1/10
		)
		(
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 10 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		)
		(
			(35 40 12)	//40% y-dir, 40% cells, expansion = 15
			(30 13 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.08334) //40% y-dir, 40% cells, expansion = 1/15
		)
	) 

    //Over Cavity back
    hex (b24c b17 b14 b20 b29 b28 b26 b27) (ny ncx nz)
	simpleGrading 
	(
		(
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		)
		(
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 10 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		)
		16
	) 
   
    // exitplate - Front
    hex (f15 f14 f12 f13 f5 f4 f3 f6) (ny nex nz) simpleGrading ((
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		) 0.0334 0.0625)

    //ShortEdge over exit flat plate - Center
    hex (f5 f4 f3 f6 fi13 fi12 b17 b24c) (ny nex ncz) 
	simpleGrading 
	(
		(
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		)
		0.0334 
		(
			(35 40 12)	//40% y-dir, 40% cells, expansion = 15
			(30 13 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.08334) //40% y-dir, 40% cells, expansion = 1/15
		)
	)
    
    //ShortEdge over exit flat plate - Back
    hex (fi13 fi12 b17 b24c b19 b18 b28 b29) (ny nex nz) simpleGrading ((
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		) 0.0334 16)
    
    //Shortedge over Inlet plate - Front
    hex (f11 f10 f9 f8 f67c f0 fi10 fi11) (ny nix nz) simpleGrading ((
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		) 25 0.0625)
    
    //Shortedge over Inlet plate - Center
    hex (f67c f0 fi10 fi11 b20 b14 b23 b22) (ny nix ncz) 
	simpleGrading 
	(
		(
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		)
		25
		(
			(35 40 12)	//40% y-dir, 40% cells, expansion = 15
			(30 13 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.08334) //40% y-dir, 40% cells, expansion = 1/15
		)
	)

    //Shortedge over Inlet plate - Back
    hex (b20 b14 b23 b22 b27 b26 b24 b25) (ny nix nz) simpleGrading ((
			(35 40 10)	//40% y-dir, 40% cells, expansion = 15
			(30 20 1)	//20% y-dir, 20% cells, expansion = 1
			(35 40 0.1) //40% y-dir, 40% cells, expansion = 1/15
		) 25 16)

       

  );

  edges
  (
  );

  boundary
  (
    inlet 
    {
      type patch;
      faces
      (       
   	//(f13 f8 b22 b27)
        (f8  f9 fi10 fi11)   	
        (fi11 fi10 b23 b22)
        (b22 b23 b24 b25)
     );
    }

    outlet
    {
      type patch;
      faces
      (
		
        (f5 f4 fi12 fi13)
        (fi13 fi12 b18 b19) 
 	(f15 f14 f4 f5)
 	//(f10 f5 b19 b24)
	
     );
    }

    inletPlate
    {
      type wall;
      faces
      (
        //(df2 cf2 f0 f9)
	(f9 f10 f0 fi10) 
        (fi10 f0 b14 b23)
	(b23 b14 b26 b24)
	//sideplate front
	
	//(b23 b14 cb2 db2)
      );
    }

    exitPlate
    {
      type wall;
      faces
      (
	//(cf3 ef3 f4 f3)
	(f12 f14 f4 f3)	
	(f3 f4 fi12 b17) 
	(b17 fi12 b18 b28)
 	//sideplateback
	(b14 b17 b28 b26)
        (f10 f12 f3 f0)
	//(b17 b18 eb3 cb3)
      );
    }

    cavityFloor
    {
      type wall;
      faces
      (
        (f1 f2 b16 b15)
      );
    }

    cavityFrontWall
    {
      type wall;
      faces
      (
        (f0 f1 b15 b14)
      );
    }

    cavityRearWall
    {
      type wall;
      faces
      (
        (f3 f2 b16 b17)
      );
    }


    cavitySideWall
    {
      type wall;
      faces
      (
        (f0 f3 f2 f1)
	(b14 b17 b16 b15)
      );
    }

    topDomain
    {
      type symmetry;
      faces
      (
      	
	//(f13 f12 b26 b27)
 	//(f12 f11 b25 b26)
	//(f11 f10 b24 b25)

	(f8 f11 f67c fi11)
        (fi11 f67c b20 b22)
	(b22 b20 b27 b25)
        (f67c f6 b24c b20)
        (f11 f13 f6 f67c)
	(b20 b24c b29 b27)
	(f13 f15 f5 f6) 
        (f6 f5 fi13 b24c)
        (b24c fi13 b19 b29)
	
   
        //(f8 f6 f67c b20 b22 fi11)
	//(f6 f5 fi13 b19 b20 b24c)
	//(f67c f6 b24c b20)

	//(f6 f6 b20 b20)   
	
      );
    }

    domainSideWall
    {
      type symmetry;
      faces
      (      
	(f8 f11 f10 f9)
	(f11 f13 f12 f10)
	(f13 f15 f14 f12) 
	//(f6 f6 f3 f0)..Not necessary as one vertex is removed

        (b25 b27 b26 b24)
	//(b20 b20 b17 b14)..Not necessary as one vertex is removed
	(b27 b29 b28 b26)	
	(b29 b19 b18 b28)

      );
    }

     

  );

  mergePatchPairs
  (
  );


