# -----------------------------------------------------------
# -----------------------------------------------------------
# Julia struct for that corresponds to C struct
mutable struct Mesh_ptr_C

    # Triangulation part
    pointlist :: Ptr{Cdouble}
    pointattributelist :: Ptr{Cdouble}
    pointmarkerlist :: Ptr{Cint}
    numberofpoints :: Cint
    numberofpointattributes :: Cint

    trianglelist :: Ptr{Cint}
    triangleattributelist :: Ptr{Cdouble}
    trianglearealist :: Ptr{Cdouble}
    neighborlist :: Ptr{Cint}
    numberoftriangles :: Cint
    numberofcorners :: Cint
    numberoftriangleattributes :: Cint

    segmentlist :: Ptr{Cint}
    segmentmarkerlist :: Ptr{Cint}
    numberofsegments :: Cint

    holelist :: Ptr{Cdouble}
    numberofholes :: Cint

    regionlist :: Ptr{Cdouble}
    numberofregions :: Cint

    edgelist :: Ptr{Cint}
    edgemarkerlist :: Ptr{Cint}
    normlist :: Ptr{Cdouble}
    numberofedges :: Cint

    # Mesh_ptr_C() = new(C_NULL, C_NULL, C_NULL, -1, -1,
    #                     C_NULL, C_NULL, C_NULL, C_NULL, -1, -1, -1,
    #                     C_NULL, C_NULL, -1,
    #                     C_NULL, -1,
    #                     C_NULL, -1,
    #                     C_NULL, C_NULL, C_NULL, -1)

    # Leave uninitialized and let C do this
    Mesh_ptr_C() = new()

end # end struct
# -----------------------------------------------------------
# -----------------------------------------------------------