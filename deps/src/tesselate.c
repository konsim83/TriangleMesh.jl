#ifdef SINGLE
#define REAL float
#else // not SINGLE 
#define REAL double
#endif // not SINGLE 

int const Debug = 0;

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "allocate.h"
#include "triangle.h"
#include "tesselate.h"


void show_triangle_struct(struct triangulateio* in)
{
	int i, j;

	printf("\n\n---------------   Input Points   ---------------\n");
	printf("Struct: %p   |   Points: %p   |   marker: %p   |   attributes: %p \n", 
					in, in->pointlist, in->pointmarkerlist, in->pointattributelist);
	printf("Size in C: %lu\n", sizeof(*in));
	for(i = 0; i < in->numberofpoints; i++)
	{
	    printf("Point   %4d of %4d   |   (x,y)=(%.3f, %.3f)   |   marker:   %4d",
	    				i+1, in->numberofpoints, in->pointlist[2*i], in->pointlist[2*i+1], in->pointmarkerlist[i]);

	    {
			printf("   |   %4d   attributes:   ", in->numberofpointattributes);
			for (j = 0; j < in->numberofpointattributes; j++)
		    {
		    	printf("%.2f   ", in->pointattributelist[2*i+j]);
		    }
	    }
	    printf("\n");
	}
	printf("---------------   End points   ---------------\n\n");

	{
		printf("\n\n---------------   Input Segments   ---------------\n");
		printf("Segment: %p   |   marker: %p   \n", in->segmentlist, in->segmentmarkerlist);
		for(i = 0; i < in->numberofsegments; i++)
		{
		    printf("Segment   %4d of %4d   |   (p1,p2)=(%4d, %4d)", i+1, in->numberofsegments, in->segmentlist[2*i], in->segmentlist[2*i+1]);
			printf("   |   marker:   %4d\n", in->segmentmarkerlist[i]);
		}
		printf("---------------   End segments   ---------------\n\n");
	}

	{
		printf("\n\n---------------   Input triangles   ---------------\n");
		printf("Triangles: %p   \n", in->trianglelist);
		for(i = 0; i < in->numberoftriangles; i++)
		{
		    printf("Triangle   %4d of %4d   |   (p1,p2,p3)=(%4d, %4d, %4d)", 
		    					i+1, in->numberoftriangles, in->trianglelist[3*i], in->trianglelist[3*i+1], in->trianglelist[3*i+2]);
			printf("   |   area constraint:   %.2f", in->trianglearealist[i]);
			printf("   |   %4d   attributes:   ", in->numberoftriangleattributes);
			for (j = 0; j < in->numberoftriangleattributes; j++)
		    {
		    	printf("%.2f   ", in->triangleattributelist[2*i+j]);
		    }
		    printf("\n");
		}
		printf("---------------   End triangles   ---------------\n\n");
	}

	{
		printf("\n\n---------------   Input Edges   ---------------\n");
		printf("Edges: %p   |   marker: %p   \n", in->edgelist, in->edgemarkerlist);
		for(i = 0; i < in->numberofedges; i++)
		{
		    printf("Edges   %4d of %4d   |   (p1,p2)=(%4d, %4d)", i+1, in->numberofedges, in->edgelist[2*i], in->edgelist[2*i+1]);
			printf("   |   marker:   %4d\n", in->edgemarkerlist[i]);
		}
		printf("---------------   End edges   ---------------\n\n");
	}

	{
		printf("\n\n---------------   Input Holes   ---------------\n");
		printf("Hole: %p   \n", in->holelist);
		for(i = 0; i < in->numberofholes; i++)
		{
		    printf("Hole   %4d of %4d   |   (x,y)=(%.3f, %.3f)\n", i+1, in->numberofholes, in->holelist[2*i], in->holelist[2*i+1]);
		}
		printf("---------------   End holes   ---------------\n\n");
	}

	printf("Number of corners:   %d\n", in->numberofcorners);

}


//---------------------------------------------------------------------------
//                                                                           
//  ()   Tesselate a straight planar line graph
//                                                                           
//---------------------------------------------------------------------------
void tesselate_pslg(struct triangulateio* in,
					struct triangulateio* out, struct triangulateio* vorout,
					char* switches)
{ 	
  	////////////////////////////////////////////////////////////
  	// Triangulate the points.
    triangulate(switches, in, out, vorout);
    ////////////////////////////////////////////////////////////

}

//---------------------------------------------------------------------------


void refine_trimesh(struct triangulateio* in,
					struct triangulateio* out, struct triangulateio* vorout,
					char* switches)
{	  

  	////////////////////////////////////////////////////////////
  	// Triangulate the points.
    triangulate(switches, in, out, vorout);
    ////////////////////////////////////////////////////////////

}

// ---------------------------------------------------------------------------