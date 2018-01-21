#ifndef TESSELATE_H
#define TESSELATE_H

#include "triangle.h"


void tesselate_pslg(struct triangulateio*, struct triangulateio*,
					int, REAL*, 
					int, int*,
					int, REAL*,
					int, int*, int*,
					int, REAL*,
					char*);

void refine_trimesh(struct triangulateio*, struct triangulateio*,
                    int, REAL*, 
                    int, int* ,
                    int, REAL*,
                    int, int* , REAL*,
                    int,  int*, int*,
                    int, int*, int*,
                    int, REAL*,
                    char*);

#endif // TESSELATE_H