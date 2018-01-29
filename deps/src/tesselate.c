#include "tesselate.h"

void tesselate_pslg(struct triangulateio *in, struct triangulateio *out, struct triangulateio *vorout, char *switches) {
    triangulate(switches,in,out,vorout);
}

void refine_trimesh(struct triangulateio *in, struct triangulateio *out, struct triangulateio *vorout, char *switches) {
    triangulate(switches,in,out,vorout);
}

void call_trifree(VOID *memptr) {
    trifree(memptr);
}
