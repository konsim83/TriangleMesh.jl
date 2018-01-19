# -----------------------------------------------------------
# -----------------------------------------------------------
function refine(m :: TriMesh ; divide_cell_into :: Int = 4,
                                ind_cell :: Array{Int,1} = collect(1:m.n_cell),
                                keep_segments :: Bool = false,
                                keep_edges :: Bool = false,
                                verbose :: Bool = false,
                                check_triangulation :: Bool = false,
                                voronoi :: Bool = false,
                                output_edges :: Bool = true,
                                output_cell_neighbors :: Bool = true,
                                quality_meshing :: Bool = true)
    
    # Do some sanity check of inputs
    divide_cell_into<1 ? error("Option 'divide_cell_into' must be at least 1.") :
    
    isempty(ind_cell) ? error("List of cells to be refined must not be empty. Leave this option blank to refine globally.") :

    if keep_edges && keep_segments
        error("Options 'keep_edges' and 'keep_segments' can not both be true.")
    end


    # Initial switch, indicates refinement, gives edges and triangle neighbors
    switches = "r"


    if output_edges
        switches = switches * "e"
    end


    if output_cell_neighbors
        switches = switches * "n"
    end


    if voronoi
        switches = switches * "v"
    end
    
    
    if quality_meshing
        switches = switches * "q"
    end


    # input points
    n_point = Cint(m.n_point)
    point = convert(Array{Cdouble,2}, m.point)'

    
    # input cells
    n_cell = Cint(m.n_cell)
    cell = convert(Array{Cint,2}, m.cell)'
    
    
    # If the list of triangles to be refined is not empty set up
    # 'cell_area_constraint' for input and '-a' to switch without a number
    # following.
    cell_area_constraint = -ones(m.n_cell)
    for i in ind_cell
        cell_area_constraint[i] = abs(det([m.point[m.cell[i,:],:] ones(3)])) / (2*divide_cell_into)
    end
    switches = switches * "a"


    # Check verbose option
    if ~verbose
        switches = switches * "Q"
    end


    # Check_triangulation
    if check_triangulation
        switches = switches * "C"
    end


    # Either keep segments or not (provided there are any)
    if keep_segments
        n_segment = Cint(m.n_segment)
        if n_segment==0 && keep_segments
            info("No segments provided by mesh. Option 'keep_segments' disabled.")
            keep_segments = false
        end

        if n_segment>0
            segment = convert(Array{Cint,2}, m.segment)'
            segment_marker = convert(Array{Cint,1}, m.segment_marker)
            switches = switches * "p"
        else
            segment = convert(Ptr{Cint}, C_NULL)
            segment_marker = convert(Ptr{Cint}, C_NULL)
        end
    elseif keep_edges
        # If there are edges use them
        n_segment = Cint(m.n_edge)
        if n_segment==0 && keep_edges
            info("No edges provided by mesh. Option 'keep_edges' disabled.")
            keep_edges = false
        end

        if n_segment>0
            segment = convert(Array{Cint,2}, m.edge)'
            segment_marker = convert(Array{Cint,1}, m.edge_marker)
        else
            segment = convert(Ptr{Cint}, C_NULL)
            segment_marker = convert(Ptr{Cint}, C_NULL)
        end
    else
        n_segment = Cint(m.n_segment)
        if n_segment>0
            segment = convert(Array{Cint,2}, m.segment)'
            segment_marker = convert(Array{Cint,1}, m.segment_marker)
        else
            segment = convert(Ptr{Cint}, C_NULL)
            segment_marker = convert(Ptr{Cint}, C_NULL)
        end
        info("Neither segments nor edges will be kept during the refinedment.")
    end


    # If there are edges use them (not necessary but does not harm)
    n_edge = Cint(m.n_edge)
    if n_edge==0 && keep_edges
        info("No edges provided by mesh. Option 'keep_edges' disabled.")
        keep_edges = false
    end

    if n_edge>0
        edge = convert(Array{Cint,2}, m.edge)'
        edge_marker = convert(Array{Cint,1}, m.edge_marker)
        switches = switches * "p"
    else
        edge = convert(Ptr{Cint}, C_NULL)
        edge_marker = convert(Ptr{Cint}, C_NULL)
    end

    # If there are point marker then use them
    n_point_marker = Cint(m.n_point_marker)
    if n_point_marker==1
        point_marker = convert(Array{Cint,2}, m.point_marker)
    elseif n_point_marker==0
        point_marker = convert(Ptr{Cint}, C_NULL)
    else
        error("Number of n_point_marker must either be 0 or 1.")
    end

    
    # If there are point attributes then use them
    n_point_attribute = Cint(m.n_point_attribute)
    if n_point_marker>0
        point_attribute = convert(Array{Cdouble,2}, m.point_attribute)'
    else
        point_attribute = convert(Ptr{Cdouble}, C_NULL)
    end


    n_hole = Cint(m.n_hole)
    if n_hole>0
        hole = convert(Array{Cdouble,2}, m.hole)'
    else
        hole = convert(Ptr{Cdouble}, C_NULL)
    end

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    ccall((:refine_trimesh, "libtesselate"), 
                            Void,
                            (Ref{Mesh_ptr_C}, 
                                Ref{Mesh_ptr_C},
                                Cint, Ptr{Cdouble},
                                Cint, Ptr{Cint},
                                Cint, Ptr{Cdouble},
                                Cint, Ptr{Cint}, Ptr{Cdouble},
                                Cint, Ptr{Cint}, Ptr{Cint},
                                Cint, Ptr{Cint}, Ptr{Cint},
                                Cint, Ptr{Cdouble},
                                Cstring),
                            Ref(mesh_buffer), Ref(vor_buffer),
                            n_point, point,
                            n_point_marker, point_marker,
                            n_point_attribute, point_attribute,
                            n_cell, cell, cell_area_constraint,
                            n_edge, edge, edge_marker,
                            n_segment, segment, segment_marker,
                            n_hole, hole,
                            switches)

    mesh = TriMesh(mesh_buffer, vor_buffer, "info_str")

    return mesh
end


function refine(m :: TriMesh, switches :: String;
                                ind_cell :: Array{Int,1} = Array{Int,1}(0))
    
    # Do some sanity check of inputs    
    isempty(ind_cell) ? error("List of cells to be refined must not be empty. Leave this option blank to refine globally.") :


    if keep_edges && keep_segments
        error("Options 'keep_edges' and 'keep_segments' can not both be true.")
    end


    
    n_point = Cint(m.n_point)
    point = convert(Array{Cdouble,2}, m.point)'

    
    # input cells
    n_cell = Cint(m.n_cell)
    cell = convert(Array{Cint,2}, m.cell)'
    
    
    # If the list of triangles to be refined is not empty set up
    # 'cell_area_constraint' for input and '-a' to switch without a number
    # following.
    cell_area_constraint = -ones(m.n_cell)
    for i in ind_cell
        cell_area_constraint[i] = abs(det([m.point[m.cell[i,:],:] ones(3)])) / (2*divide_cell_into)
    end
    switches = switches * "a"


    n_segment = Cint(m.n_segment)
    if n_segment>0
        segment = convert(Array{Cint,2}, m.segment)'
        segment_marker = convert(Array{Cint,1}, m.segment_marker)
    else
        segment = convert(Ptr{Cint}, C_NULL)
        segment_marker = convert(Ptr{Cint}, C_NULL)
    end


    # If there are edges use them (not necessary but does not harm)
    n_edge = Cint(m.n_edge)
    if n_edge>0
        edge = convert(Array{Cint,2}, m.edge)'
        edge_marker = convert(Array{Cint,1}, m.edge_marker)
    else
        edge = convert(Ptr{Cint}, C_NULL)
        edge_marker = convert(Ptr{Cint}, C_NULL)
    end

    # If there are point marker then use them
    n_point_marker = Cint(m.n_point_marker)
    if n_point_marker==1
        point_marker = convert(Array{Cint,2}, m.point_marker)
    elseif n_point_marker==0
        point_marker = convert(Ptr{Cint}, C_NULL)
    else
        error("Number of n_point_marker must either be 0 or 1.")
    end

    
    # If there are point attributes then use them
    n_point_attribute = Cint(m.n_point_attribute)
    if n_point_marker>0
        point_attribute = convert(Array{Cdouble,2}, m.point_attribute)'
    else
        point_attribute = convert(Ptr{Cdouble}, C_NULL)
    end


    n_hole = Cint(m.n_hole)
    if n_hole>0
        hole = convert(Array{Cdouble,2}, m.hole)'
    else
        hole = convert(Ptr{Cdouble}, C_NULL)
    end

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    ccall((:refine_trimesh, "libtesselate"), 
                            Void,
                            (Ref{Mesh_ptr_C}, 
                                Ref{Mesh_ptr_C},
                                Cint, Ptr{Cdouble},
                                Cint, Ptr{Cint},
                                Cint, Ptr{Cdouble},
                                Cint, Ptr{Cint}, Ptr{Cdouble},
                                Cint, Ptr{Cint}, Ptr{Cint},
                                Cint, Ptr{Cint}, Ptr{Cint},
                                Cint, Ptr{Cdouble},
                                Cstring),
                            Ref(mesh_buffer), Ref(vor_buffer),
                            n_point, point,
                            n_point_marker, point_marker,
                            n_point_attribute, point_attribute,
                            n_cell, cell, cell_area_constraint,
                            n_edge, edge, edge_marker,
                            n_segment, segment, segment_marker,
                            n_hole, hole,
                            switches)

    mesh = TriMesh(mesh_buffer, vor_buffer, "info_str")

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------