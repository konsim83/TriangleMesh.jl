# -----------------------------------------------------------
# -----------------------------------------------------------
"""
Julia struct for that corresponds to C struct of Triangle. Only for internal use.
"""
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

end # end struct


"""
    Mesh_ptr_C(p :: Polygon_pslg)

Constructor for `Mesh_ptr_C` from polygon. Only for internal use.
"""
function Mesh_ptr_C(p :: Polygon_pslg)

    numberofpoints = Cint(p.n_point)
    pointlist = pointer(p.point)
    
    if p.n_point_marker==0
        pointmarkerlist = convert(Ptr{Cint}, C_NULL)
    else
        pointmarkerlist = pointer(p.point_marker)
    end

    numberofpointattributes = Cint(p.n_point_attribute)
    if numberofpointattributes==0
        pointattributelist = convert(Ptr{Cdouble}, C_NULL)
    else
        pointattributelist = pointer(p.point_attribute)
    end

    
    numberoftriangles = Cint(0)
    numberoftriangleattributes = Cint(0)
    numberofcorners = Cint(3)
    trianglelist = convert(Ptr{Cint}, C_NULL)
    triangleattributelist = convert(Ptr{Cdouble}, C_NULL)
    trianglearealist = convert(Ptr{Cdouble}, C_NULL)
    neighborlist = convert(Ptr{Cint}, C_NULL)

    
    numberofsegments = Cint(p.n_segment)
    if numberofsegments>0
        segmentlist = pointer(p.segment)
        segmentmarkerlist = pointer(p.segment_marker)
    else
        segmentlist = convert(Ptr{Cint}, C_NULL)
        segmentmarkerlist = convert(Ptr{Cint}, C_NULL)
    end

    
    numberofregions = Cint(0)
    regionlist = convert(Ptr{Cdouble}, C_NULL)

    
    numberofholes = Cint(p.n_hole)
    if numberofholes==0
        holelist = convert(Ptr{Cdouble}, C_NULL)
    else
        holelist = pointer(p.hole)
    end

    
    edgelist = convert(Ptr{Cint}, C_NULL)
    edgemarkerlist = convert(Ptr{Cint}, C_NULL)
    normlist = convert(Ptr{Cdouble}, C_NULL)
    numberofedges = Cint(0)


    mesh_C = Mesh_ptr_C(pointlist,
                        pointattributelist,
                        pointmarkerlist,
                        numberofpoints,
                        numberofpointattributes,
                        trianglelist,
                        triangleattributelist,
                        trianglearealist,
                        neighborlist,
                        numberoftriangles,
                        numberofcorners,
                        numberoftriangleattributes,
                        segmentlist,
                        segmentmarkerlist,
                        numberofsegments,
                        holelist,
                        numberofholes,
                        regionlist,
                        numberofregions,
                        edgelist,
                        edgemarkerlist,
                        normlist,
                        numberofedges)

    return mesh_C
end


"""
    Mesh_ptr_C(n_point :: Cint, point :: Array{Float64,2},
                    n_point_marker :: Cint, point_marker :: Array{Cint,2},
                    n_point_attribute :: Cint, point_attribute :: Array{Float64,2},
                    n_cell :: Cint, cell :: Array{Cint,2}, cell_area_constraint :: Array{Float64,1},
                    n_edge :: Cint, edge :: Array{Cint,2}, edge_marker :: Array{Cint,1},
                    n_segment :: Cint, segment :: Array{Cint,2}, segment_marker :: Array{Cint,1},
                    n_hole :: Cint, hole :: Array{Float64,2})

Constructor for `Mesh_ptr_C` from mesh data. Only for internal use.
"""
function Mesh_ptr_C(n_point :: Cint, point :: Array{Float64,2},
                    n_point_marker :: Cint, point_marker :: Array{Cint,2},
                    n_point_attribute :: Cint, point_attribute :: Array{Float64,2},
                    n_cell :: Cint, cell :: Array{Cint,2}, cell_area_constraint :: Array{Float64,1},
                    n_edge :: Cint, edge :: Array{Cint,2}, edge_marker :: Array{Cint,1},
                    n_segment :: Cint, segment :: Array{Cint,2}, segment_marker :: Array{Cint,1},
                    n_hole :: Cint, hole :: Array{Float64,2})

    numberofpoints = Cint(n_point)
    pointlist = pointer(point)
    
    if n_point_marker==0
        pointmarkerlist = convert(Ptr{Cint}, C_NULL)
    else
        pointmarkerlist = pointer(point_marker)
    end

    numberofpointattributes = Cint(n_point_attribute)
    if numberofpointattributes==0
        pointattributelist = convert(Ptr{Cdouble}, C_NULL)
    else
        pointattributelist = pointer(point_attribute)
    end

    
    numberoftriangles = Cint(n_cell)
    trianglelist = pointer(cell)
    trianglearealist = pointer(cell_area_constraint)
    numberoftriangleattributes = Cint(0)
    numberofcorners = Cint(3)
    triangleattributelist = convert(Ptr{Cdouble}, C_NULL)
    neighborlist = convert(Ptr{Cint}, C_NULL)


    numberofsegments = Cint(n_segment)
    if numberofsegments>0
        segmentlist = pointer(segment)
        segmentmarkerlist = pointer(segment_marker)
    else
        segmentlist = convert(Ptr{Cint}, C_NULL)
        segmentmarkerlist = convert(Ptr{Cint}, C_NULL)
    end

    
    numberofregions = Cint(0)
    regionlist = convert(Ptr{Cdouble}, C_NULL)

    
    numberofholes = Cint(n_hole)
    if numberofholes==0
        holelist = convert(Ptr{Cdouble}, C_NULL)
    else
        holelist = pointer(hole)
    end


    numberofedges = Cint(n_segment)
    if numberofedges>0
        edgelist = pointer(segment)
        edgemarkerlist = pointer(segment_marker)
    else
        edgelist = convert(Ptr{Cint}, C_NULL)
        edgemarkerlist = convert(Ptr{Cint}, C_NULL)
    end
    normlist = convert(Ptr{Cdouble}, C_NULL)


    mesh_C = Mesh_ptr_C(pointlist,
                        pointattributelist,
                        pointmarkerlist,
                        numberofpoints,
                        numberofpointattributes,
                        trianglelist,
                        triangleattributelist,
                        trianglearealist,
                        neighborlist,
                        numberoftriangles,
                        numberofcorners,
                        numberoftriangleattributes,
                        segmentlist,
                        segmentmarkerlist,
                        numberofsegments,
                        holelist,
                        numberofholes,
                        regionlist,
                        numberofregions,
                        edgelist,
                        edgemarkerlist,
                        normlist,
                        numberofedges)

    return mesh_C
end


"""
    Mesh_ptr_C()
    
Constructor for `Mesh_ptr_C`. Initialize everything as `NULL`. Only for internal use.
"""
function Mesh_ptr_C()

    return Mesh_ptr_C(C_NULL, C_NULL, C_NULL, 0, 0,
                        C_NULL, C_NULL, C_NULL, C_NULL, 0, 0, 0,
                        C_NULL, C_NULL, 0,
                        C_NULL, 0,
                        C_NULL, 0,
                        C_NULL, C_NULL, C_NULL, 0)
end
# -----------------------------------------------------------
# -----------------------------------------------------------