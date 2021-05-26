#ifndef TESSELATE_H

	#include "commondefine.h"
    #include "triangle.h"

    extern DLLEXPORT void tesselate_pslg(struct triangulateio *, struct triangulateio *, struct triangulateio *, char *);
    extern DLLEXPORT void refine_trimesh(struct triangulateio *, struct triangulateio *, struct triangulateio *, char *);
    extern DLLEXPORT void call_trifree(VOID *memptr);

    #define TESSELATE_H
#endif
