#ifdef SINGLE
#define REAL float
#else // not SINGLE 
#define REAL double
#endif // not SINGLE 

int const Debug = 0;
int const  print_flag = 0;

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "allocate.h"
#include "triangle.h"
#include "tesselate.h"



//---------------------------------------------------------------------------
//                                                                           
//  ()   Tesselate a straight planar line graph
//                                                                           
//---------------------------------------------------------------------------
void tesselate_pslg(struct triangulateio* out, struct triangulateio* vorout,
					int n_point, REAL* point, 
					int n_point_marker, int* point_marker,
					int n_point_attribute, REAL* point_attribute,
					int n_segment, int* segment, int* segment_marker,
					int n_hole, REAL* hole,
					char* switches)
{
	int i, j;
    struct triangulateio in;

    ////////////////////////////////////////////////////////////
    // Points
    in.numberofpoints = n_point;
    in.pointlist = point;

	in.pointmarkerlist = point_marker;

    in.numberofpointattributes = n_point_attribute;
	in.pointattributelist = point_attribute;

    // segments
    in.numberofsegments = n_segment;
	in.segmentlist = segment;
	in.segmentmarkerlist = segment_marker;
    
    // holes
    in.numberofholes = n_hole;
	in.holelist = hole;


	// regionlist not used
	in.numberofregions = 0; 
    in.regionlist = real_alloc(0, "in.regionlist");
    ////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////
	if (print_flag != 0)
	{
		printf("\nOutput pointers at beginning of C-function:\n");
		printf("Struct: %p   |   Points: %p   |   marker: %p   |   attributes: %p \n", 
						out, out->pointlist, out->pointmarkerlist, out->pointattributelist);
		printf("Size in C: %lu\n", sizeof(*out));

		printf("\n\n---------------   Input Points   ---------------\n");
		for(i = 0; i < in.numberofpoints; i++)
		{
		    printf("Point   %4d of %4d   |   (x,y)=(%.3f, %.3f)", i+1, in.numberofpoints, in.pointlist[2*i], in.pointlist[2*i+1]);

		    if (in.numberofpointattributes>0)
		    {
	    		printf("   |   %4d   attributes:   ", in.numberofpointattributes);
	    		for (j = 0; j < in.numberofpointattributes; j++)
			    {
			    	printf("%.2f   ", in.pointattributelist[2*i+j]);
			    }
		    }
		    printf("\n");
		}
		printf("---------------   End points   ---------------\n\n");

		if (n_segment>0)
		{
			printf("\n\n---------------   Input Segments   ---------------\n");
			printf("Segment: %p   |   marker: %p   \n", in.segmentlist, in.segmentmarkerlist);
			for(i = 0; i < in.numberofsegments; i++)
			{
			    printf("Segment   %4d of %4d   |   (p1,p2)=(%4d, %4d)", i+1, in.numberofsegments, in.segmentlist[2*i], in.segmentlist[2*i+1]);
				printf("   |   marker:   %4d\n", in.segmentmarkerlist[i]);
			}
			printf("---------------   End segments   ---------------\n\n");
		}

		if (n_hole>0)
		{
			printf("\n\n---------------   Input Holes   ---------------\n");
			printf("Hole: %p   \n", in.holelist);
			for(i = 0; i < in.numberofholes; i++)
			{
			    printf("Hole   %4d of %4d   |   (x,y)=(%.3f, %.3f)\n", i+1, in.numberofholes, in.holelist[2*i], in.holelist[2*i+1]);
			}
			printf("---------------   End holes   ---------------\n\n");
		}
	}
  	////////////////////////////////////////////////////////////



	////////////////////////////////////////////////////////////
    // Allocate outputs
    out->pointlist = real_alloc(0, "out->pointlist");
    out->pointattributelist = real_alloc(0, "out->pointattributelist");
    out->pointmarkerlist = int_alloc(0,"out->pointmarkerlist") ;
    
    out->trianglelist = int_alloc(0,"out->trianglelist");
    out->triangleattributelist = real_alloc(0, "out->triangleattributelist");
    out->neighborlist = int_alloc(0,"out->neighborlist");
    
    out->segmentlist = int_alloc(0,"out->segmentlist");
    out->segmentmarkerlist = int_alloc(0,"out->segmentmarkerlist");
    
    out->edgelist = int_alloc(0,"out->edgelist");
    out->edgemarkerlist = int_alloc(0,"out->edgemarkerlist");

    out->holelist = real_alloc(0,"out->holelist");
    
    vorout->pointlist = real_alloc(0, "vorout->pointlist");
  	vorout->pointattributelist = real_alloc(0, "vorout->pointattributelist");
  	vorout->edgelist = int_alloc(0, "vorout->edgelist");
  	vorout->normlist = real_alloc(0, "vorout->normlist");
  	////////////////////////////////////////////////////////////

 	
  	////////////////////////////////////////////////////////////
  	// Triangulate the points.
    triangulate(switches, &in, out, vorout);
    ////////////////////////////////////////////////////////////

	
	

	////////////////////////////////////////////////////////////
	if (print_flag != 0)
	{
		printf("\nOutput pointers after triangulation:\n");
		printf("Struct: %p   |   Points: %p   |   marker: %p   |   attributes: %p \n", 
						out, out->pointlist, out->pointmarkerlist, out->pointattributelist);
		printf("Size in C: %lu\n", sizeof(*out));

		printf("\n\n---------------   Output Points   ---------------\n");
		printf("Points: %p   |   marker: %p   |   attributes: %p \n", out->pointlist, out->pointmarkerlist, out->pointattributelist);
		for(i = 0; i < out->numberofpoints; i++)
		{
		    printf("Point   %4d of %4d   |   (x,y)=(%.3f, %.3f)", i+1, out->numberofpoints, out->pointlist[2*i], out->pointlist[2*i+1]);

		    if (out->numberofpointattributes>0)
		    {
	    		printf("   |   %4d   attributes:   ", out->numberofpointattributes);
	    		for (j = 0; j < out->numberofpointattributes; j++)
			    {
			    	printf("%.2f   ", out->pointattributelist[2*i+j]);
			    }
		    }
		    printf("\n");
		}
		printf("---------------   End points   ---------------\n\n");

		if (n_segment>0)
		{
			printf("\n\n---------------   Output Segments   ---------------\n");
			printf("Segment: %p   |   marker: %p   \n", out->segmentlist, out->segmentmarkerlist);
			for(i = 0; i < out->numberofsegments; i++)
			{
			    printf("Segment   %4d of %4d   |   (p1,p2)=(%4d, %4d)", i+1, out->numberofsegments, out->segmentlist[2*i], out->segmentlist[2*i+1]);
				printf("   |   marker:   %4d\n", out->segmentmarkerlist[i]);
			}
			printf("---------------   End segments   ---------------\n\n");
		}

		if (n_hole>0)
		{
			printf("\n\n---------------   Output Holes   ---------------\n");
			printf("Hole: %p   \n", out->holelist);
			for(i = 0; i < out->numberofholes; i++)
			{
			    printf("Hole   %4d of %4d   |   (x,y)=(%.3f, %.3f)\n", i+1, out->numberofholes, out->holelist[2*i], out->holelist[2*i+1]);
			}
			printf("---------------   End holes   ---------------\n\n");
		}
	}
  	////////////////////////////////////////////////////////////

}

//---------------------------------------------------------------------------


void refine_trimesh(struct triangulateio* out, struct triangulateio* vorout,
					int n_point, REAL* point, 
					int n_point_marker, int* point_marker,
					int n_point_attribute, REAL* point_attribute,
					int n_cell, int* cell, REAL* cell_area_constraint,
					int n_edge,  int* edge, int* edge_marker,
					int n_segment, int* segment, int* segment_marker,
					int n_hole, REAL* hole,
					char* switches)
{
	int i, j;
    struct triangulateio in;

    // ///////////////////////////////////
	// // Only for testing
    // ///////////////////////////////////
    // regionlist not used
	// in.numberofregions = 0; 
    // in.regionlist = real_alloc(0, "in.regionlist");

	// in.numberofcorners = 3;
	
	// in.numberofpoints = 4;
	// in.pointlist = real_alloc(2*in.numberofpoints, "in.pointlist");
	// in.pointlist[0] = 0.0;
	// in.pointlist[1] = 0.0;
	// in.pointlist[2] = 1.0;
	// in.pointlist[3] = 0.0;
	// in.pointlist[4] = 1.0;
	// in.pointlist[5] = 1.0;
	// in.pointlist[6] = 0.0;
	// in.pointlist[7] = 1.0;

	// in.numberofpointattributes = 0;
	// in.pointattributelist = real_alloc(0, "in.pointattributelist");

	// in.pointmarkerlist = int_alloc(in.numberofpoints, "in.pointmarkerlist");
	// in.pointmarkerlist[0] = 5;
	// in.pointmarkerlist[1] = 2;
	// in.pointmarkerlist[2] = 3;
	// in.pointmarkerlist[3] = 2;
	
	// in.numberoftriangles = 2;
	// in.trianglelist = int_alloc(3*in.numberoftriangles, "in.trianglelist");
	// in.trianglelist[0] = 1;
	// in.trianglelist[1] = 2;
	// in.trianglelist[2] = 4;
	// in.trianglelist[3] = 2;
	// in.trianglelist[4] = 3;
	// in.trianglelist[5] = 4;

	// in.trianglearealist = real_alloc(in.numberoftriangles, "in.trianglearealist");
	// in.trianglearealist[0] = 0.125;
	// in.trianglearealist[1] = 0.125;

	// in.numberoftriangleattributes = 0;
	// in.triangleattributelist = real_alloc(0, "in.triangleattributelist");
	// ///////////////////////////////////
	// // Only for testing
    // ///////////////////////////////////



    ////////////////////////////////////////////////////////////
    // Points
    in.numberofpoints = n_point;
    in.pointlist = point;

	in.pointmarkerlist = point_marker;

    in.numberofpointattributes = n_point_attribute;
	in.pointattributelist = point_attribute;

	// edges
	in.numberofedges = n_edge;
	in.edgelist = edge;
	in.edgemarkerlist = edge_marker;

    // segments
	in.numberofsegments = n_segment;
	in.segmentlist = segment;
	in.segmentmarkerlist = segment_marker;
    
    // holes
    in.numberofholes = n_hole;
	in.holelist = hole;
    
    // regionlist not used
	in.numberofregions = 0; 
    in.regionlist = real_alloc(0, "in.regionlist");

    // Triangles and list of constraints of triangle areas
    in.numberoftriangles = n_cell;
    in.trianglearealist = cell_area_constraint;
	in.trianglelist = cell;

	in.numberofcorners = 3; // we only hape 3-point-triangles
	in.numberoftriangleattributes = 0;
	in.triangleattributelist = real_alloc(0, "in.triangleattributelist");
    ////////////////////////////////////////////////////////////


	
	////////////////////////////////////////////////////////////
    // Allocate outputs
    out->pointlist = real_alloc(0, "out->pointlist");
    out->pointattributelist = real_alloc(0, "out->pointattributelist");
    out->pointmarkerlist = int_alloc(0,"out->pointmarkerlist") ;
    
    out->trianglelist = int_alloc(0,"out->trianglelist");
    out->triangleattributelist = real_alloc(0, "out->triangleattributelist");
    out->neighborlist = int_alloc(0,"out->neighborlist");
    
    out->segmentlist = int_alloc(0,"out->segmentlist");
    out->segmentmarkerlist = int_alloc(0,"out->segmentmarkerlist");
    
    out->edgelist = int_alloc(0,"out->edgelist");
    out->edgemarkerlist = int_alloc(0,"out->edgemarkerlist");

    out->holelist = real_alloc(0,"out->holelist");
    
    vorout->pointlist = real_alloc(0, "vorout->pointlist");
  	vorout->pointattributelist = real_alloc(0, "vorout->pointattributelist");
  	vorout->edgelist = int_alloc(0, "vorout->edgelist");
  	vorout->normlist = real_alloc(0, "vorout->normlist");
  	////////////////////////////////////////////////////////////



  	////////////////////////////////////////////////////////////
  	// Triangulate the points.
    triangulate(switches, &in, out, vorout);
    ////////////////////////////////////////////////////////////

}

// ---------------------------------------------------------------------------