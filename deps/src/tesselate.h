#ifndef TESSELATE_H
#define TESSELATE_H

#include "triangle.h"


void tesselate_pslg(struct triangulateio*,
                    struct triangulateio*, struct triangulateio*,
				char*);

void refine_trimesh(struct triangulateio*,
                    struct triangulateio*, struct triangulateio*,
                    char*);

#endif // TESSELATE_H