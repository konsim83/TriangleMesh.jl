# -----------------------------------------------------------
# -----------------------------------------------------------
"""
Struct containing Voronoi diagram. If arrays do not contain 
data their length is zero.
"""
struct VoronoiDiagram

    vor_info :: String

    n_point :: Int
    point :: Array{Float64, 2}

    n_point_attribute :: Int
    point_attribute :: Array{Float64,2}

    n_edge :: Int
    edge :: Array{Int, 2}

    normal :: Array{Float64, 2}

end


"""   
Struct containing triangular mesh and a Voronoi diagram. If arrays do not contain 
data their length is zero.
"""
struct TriMesh
    
    mesh_info :: String

    n_point :: Int
    point :: Array{Float64, 2}
    
    n_point_marker :: Int
    point_marker :: Array{Int, 2}
    
    n_point_attribute :: Int
    point_attribute :: Array{Float64,2}

    n_cell :: Int
    cell :: Array{Int, 2}
    cell_neighbor :: Array{Int, 2}

    n_edge :: Int
    edge :: Array{Int, 2}

    n_edge_marker :: Int
    edge_marker :: Array{Int, 1}

    n_segment :: Int
    segment :: Array{Int, 2}
    
    n_segment_marker :: Int
    segment_marker :: Array{Int, 1}

    n_hole :: Int
    hole :: Array{Float64, 2}

    voronoi :: VoronoiDiagram
    
end # end struct
# -----------------------------------------------------------
# -----------------------------------------------------------



# ---------------------------------------------------------------------------------------------
"""
   TriMesh(mesh :: Mesh_ptr_C, vor :: Mesh_ptr_C, mesh_info :: String) 

Outer constructor for TriMesh. Read the struct returned by `ccall(...)` to Triangle library.
Wrap a Julia arrays around mesh data if their pointer is not `C_NULL`.
"""
function TriMesh(mesh :: Mesh_ptr_C, vor :: Mesh_ptr_C, mesh_info :: String)

    mesh_info = mesh_info

    # Let julia take ownership of C memory
    take_ownership = false


    # Points
    n_point = Int(mesh.numberofpoints)

    n_point==0 ? Base.@error("Number of points in mesh output is zero...") :

    if mesh.pointlist != C_NULL
        point = convert(Array{Float64,2}, 
                        Base.unsafe_wrap(Array, mesh.pointlist, (2,n_point), own=take_ownership))
    else
        Base.@error("Points could not be read from triangulation structure.")
    end
    
    if mesh.pointmarkerlist != C_NULL
        n_point_marker = 1     
        point_marker = convert(Array{Int,2}, Base.unsafe_wrap(Array, mesh.pointmarkerlist, (1,n_point), own=take_ownership))
    else
        n_point_marker = 0
        point_marker = Array{Int,2}(undef,0,n_point)
    end

    n_point_attribute = Int(mesh.numberofpointattributes)
    if n_point_attribute>0
        point_attribute = convert(Array{Float64,2}, 
                                Base.unsafe_wrap(Array, mesh.pointattributelist, (n_point_attribute, n_point), own=take_ownership))
    else
        point_attribute = Array{Float64,2}(undef,0,n_point)
    end

    
    # Triangles
    n_cell = Int(mesh.numberoftriangles)
    n_cell==0 ? Base.@error("Number of triangles in mesh output is zero...") : 

    if mesh.trianglelist != C_NULL
        cell = convert(Array{Int,2}, 
                        Base.unsafe_wrap(Array, mesh.trianglelist, (3, n_cell), own=take_ownership))
        if minimum(cell)==0
            cell .+= 1
        end
    else
       Base.@error("Cells could not be read.") 
    end

    if mesh.neighborlist != C_NULL
        cell_neighbor = convert(Array{Int,2},
                                Base.unsafe_wrap(Array, mesh.neighborlist, (3,n_cell), own=take_ownership))
        if minimum(cell_neighbor)==-1
            cell_neighbor .+= 1
        end
    else
        cell_neighbor = Array{Int,2}(undef,0,n_cell)
    end


    # Edges
    if mesh.edgelist != C_NULL
        n_edge = Int(mesh.numberofedges)
        edge = convert(Array{Int,2},
                        Base.unsafe_wrap(Array, mesh.edgelist, (2, n_edge), own=take_ownership))
        if minimum(edge)==0
            edge .+= 1
        end
    else
        n_edge = 0
        edge = Array{Int,2}(undef,2,0)
   
    end

    if mesh.edgemarkerlist != C_NULL
        n_edge_marker = 1
        edge_marker = convert(Array{Int,1},
                                Base.unsafe_wrap(Array, mesh.edgemarkerlist, n_edge, own=take_ownership))
    else
        n_edge_marker = 0
        edge_marker = Array{Int,1}(0)
    end


    # Segments
    if mesh.segmentlist != C_NULL
        n_segment = Int(mesh.numberofsegments)
        segment = convert(Array{Int,2}, 
                            Base.unsafe_wrap(Array, mesh.segmentlist, (2,n_segment), own=take_ownership))
        if minimum(segment)==0
            segment .+= 1
        end
    else
        n_segment = 0
        segment = Array{Int,2}(undef,2,0)
    end

    if mesh.segmentmarkerlist != C_NULL
        n_segment_marker = 1
        segment_marker = convert(Array{Int,1},
                                Base.unsafe_wrap(Array, mesh.segmentmarkerlist, n_segment, own=take_ownership))
    else
        n_segment_marker = 0
        segment_marker = Array{Int,1}(undef,0)
    end


    # holes
    if mesh.holelist != C_NULL
        n_hole = Int(mesh.numberofholes)
        hole = convert(Array{Float64,2},
                        Base.unsafe_wrap(Array, mesh.holelist, (2, n_hole), own=take_ownership))
    else
        n_hole = 0
        hole = Array{Float64,2}(undef,2, 0)
    end
    
    # ----------------------------------------
    # VoronoiDiagram
    vor_info = mesh_info * " - Voronoi diagram"

    # Read the pointers
    if vor.pointlist != C_NULL
        # Points
        n_point_v = Int(vor.numberofpoints)
        point_v = convert(Array{Float64,2},
                                Base.unsafe_wrap(Array, vor.pointlist, (2,n_point), own=take_ownership))

        n_point_attribute_v = Int(vor.numberofpointattributes)
        if n_point_attribute_v>0
            point_attribute_v = convert(Array{Float64,2}, 
                                    Base.unsafe_wrap(Array, vor.pointattributelist, (n_point_attribute_v, n_point_v), own=take_ownership))
        else
            point_attribute_v = Array{Float64,2}(undef,0,n_point_v)
        end

        
        # Edges
        n_edge_v = Int(vor.numberofedges)
        if n_edge_v>0
            edge_v = convert(Array{Int,2}, 
                            Base.unsafe_wrap(Array, vor.edgelist, (2, n_edge_v), own=take_ownership))
            if minimum(edge_v)==0
                edge_v .+= 1
            end
            
            if vor.normlist != C_NULL
            normal_v = convert(Array{Float64,2}, 
                            Base.unsafe_wrap(Array, vor.edgelist, (2, n_edge_v), own=take_ownership))
            else
                normal_v = Array{Float64,2}(undef,2, 0)
            end
        else
            edge_v = Array{Int,2}(undef,0,2)
            normal_v = Array{Float64,2}(undef,2, 0)
        end
    else
        n_point_v = 0
        point_v = Array{Float64,2}(undef,2,0)

        n_point_attribute_v = 0
        point_attribute_v = Array{Float64,2}(undef,1,0)

        n_edge_v = 0
        edge_v = Array{Int,2}(undef,2, 0)
        normal_v = Array{Float64,2}(undef,2, 0)
    end

    voronoi = VoronoiDiagram(vor_info, 
                                n_point_v, point_v,
                                n_point_attribute_v, point_attribute_v,
                                n_edge_v, edge_v,
                                normal_v)
    # ----------------------------------------


    mesh_out =  TriMesh(mesh_info,
                    n_point, point,
                    n_point_marker, point_marker,
                    n_point_attribute, point_attribute,
                    n_cell, cell, cell_neighbor,
                    n_edge, edge, 
                    n_edge_marker, edge_marker,
                    n_segment, segment,
                    n_segment_marker, segment_marker,
                    n_hole, hole,
                    voronoi)

    # clean C
    if take_ownership
        mesh.pointlist = C_NULL
        mesh.pointattributelist = C_NULL
        mesh.pointmarkerlist = C_NULL
        mesh.trianglelist = C_NULL
        mesh.triangleattributelist = C_NULL
        mesh.trianglearealist = C_NULL
        mesh.neighborlist = C_NULL
        mesh.segmentlist = C_NULL
        mesh.segmentmarkerlist = C_NULL
        mesh.holelist = C_NULL
        mesh.regionlist = C_NULL
        mesh.edgelist = C_NULL
        mesh.edgemarkerlist = C_NULL
        mesh.normlist = C_NULL    
    end

    return mesh_out
end # end constructor
# ---------------------------------------------------------------------------------------------