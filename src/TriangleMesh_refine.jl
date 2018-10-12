# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    refine(m :: TriMesh ; <keyword arguments>)

Refines a triangular mesh according to user set constraints.

# Keyword arguments
- `divide_cell_into :: Int = 4`: Triangles listed in `ind_cell` are area constrained
                                    by 1/divide_cell_into * area(triangle[ind_cell]) in refined triangulation.
- `ind_cell :: Array{Int,1} = collect(1:m.n_cell)`: List of triangles to be refined.
- `keep_segments :: Bool = false`: Retain segments of input triangulations (although they may be subdivided).
- `keep_edges :: Bool = false`: Retain edges of input triangulations (although they may be subdivided).
- `verbose :: Bool = false`: Output triangle's commandline info.
- `check_triangulation :: Bool = false`: Check refined mesh.
- `voronoi :: Bool = false`: Output Voronoi diagram.
- `output_edges :: Bool = true`: Output edges.
- `output_cell_neighbors :: Bool = true`: Output cell neighbors.
- `quality_meshing :: Bool = true`: No angle is is smaller than 20 degrees.
- `info_str :: String = "Refined mesh"`: Some info string.

# Remark
The switches `keep_segments` and `keep_edges` can not be true at the same time. If `keep_segments=true` area
constraints on triangles listed in `ind_cell` are rather local constraints than hard constraints on a triangle since
the original edges may not be preserved. For details see Triangle's documentation. 

"""
function refine(m :: TriMesh ; divide_cell_into :: Int = 4,
                                ind_cell :: Array{Int,1} = collect(1:m.n_cell),
                                keep_segments :: Bool = false,
                                keep_edges :: Bool = false,
                                verbose :: Bool = false,
                                check_triangulation :: Bool = false,
                                voronoi :: Bool = false,
                                output_edges :: Bool = true,
                                output_cell_neighbors :: Bool = true,
                                quality_meshing :: Bool = true,
                                info_str :: String = "Refined mesh")
    
    # Do some sanity check of inputs
    if divide_cell_into<1
        Base.@error "Option `divide_cell_into` must be at least 1."
    end
    
    if isempty(ind_cell)
        Base.@error "List of cells to be refined must not be empty. Leave this option blank to refine globally."
    end

    if keep_edges && keep_segments
        Base.@error "Options `keep_edges` and `keep_segments` can not both be true."
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
    if n_point <1
        Base.@error "No points provided for refinement."
    end
    point = convert(Array{Cdouble,2}, m.point)

    
    # input cells
    n_cell = Cint(m.n_cell)
    if n_cell<1
        Base.@error "No cells provided for refinement."
    end
    cell = convert(Array{Cint,2}, m.cell)
    
    
    # If the list of triangles to be refined is not empty set up
    # `cell_area_constraint` for input and `-a` to switch without a number
    # following.
    cell_area_constraint = -ones(m.n_cell)
    for i in ind_cell
        cell_area_constraint[i] = abs(det([m.point[:,m.cell[:,i]] ; ones(1,3)])) / (2*divide_cell_into)
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
        if n_segment==0
            Base.@info "No segments provided by mesh. Option `keep_segments` disabled."
            keep_segments = false
        elseif n_segment>0
            segment = convert(Array{Cint,2}, m.segment)
            segment_marker = convert(Array{Cint,1}, m.segment_marker)
            switches = switches * "p"
        else
            segment = Array{Cint,2}(undef,2,0)
            segment_marker = Array{Cint,1}(undef,0)
        end
    elseif keep_edges
        # If there are edges use them
        n_segment = Cint(m.n_edge)
        if n_segment==0
            Base.@info "No edges provided by mesh. Option `keep_edges` disabled."
            keep_edges = false
        end

        if n_segment>0
            segment = convert(Array{Cint,2}, m.edge)
            segment_marker = convert(Array{Cint,1}, m.edge_marker)
            switches = switches * "p"
        else
            segment = Array{Cint,2}(undef,2,0)
            segment_marker = Array{Cint,1}(undef,0)
        end
    else
        n_segment = Cint(0)
        segment = Array{Cint,2}(undef,2,0)
        segment_marker = Array{Cint,1}(undef,0)
        Base.@info "Neither segments nor edges will be kept during the refinedment."
    end


    # If there are edges use them (not necessary but does not harm)
    n_edge = Cint(m.n_edge)
    if n_edge==0 && keep_edges
        Base.@info "No edges provided by mesh. Option `keep_edges` disabled."
        keep_edges = false
    end

    if n_edge>0
        edge = convert(Array{Cint,2}, m.edge)
        edge_marker = convert(Array{Cint,1}, m.edge_marker)
    else
        edges = Array{Cint,2}(undef,2,0)
        edge_marker = Array{Cint,1}(undef,0)
    end

    # If there are point marker then use them
    n_point_marker = Cint(m.n_point_marker)
    if n_point_marker==1
        point_marker = convert(Array{Cint,2}, m.point_marker)
    elseif n_point_marker==0
        point_marker = Array{Cint,2}(undef,0,n_point)
    else
        Base.@error "Number of n_point_marker must either be 0 or 1."
    end

    
    # If there are point attributes then use them
    n_point_attribute = Cint(m.n_point_attribute)
    if n_point_attribute>0
        point_attribute = convert(Array{Cdouble,2}, m.point_attribute)
    else
        point_attribute = Array{Cdouble,2}(undef,0,n_point)
    end


    n_hole = Cint(m.n_hole)
    if n_hole>0
        hole = convert(Array{Cdouble,2}, m.hole)
    else
        hole = Array{Cdouble,2}(undef,2,n_hole)
    end

    mesh_in = Mesh_ptr_C(n_point, point,
                            n_point_marker, point_marker,
                            n_point_attribute, point_attribute,
                            n_cell, cell, cell_area_constraint,
                            n_edge, edge, edge_marker,
                            n_segment, segment, segment_marker,
                            n_hole, hole)

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    lib_ptr = Libdl.dlopen(libtesselate)
    refine_trimesh_ptr = Libdl.dlsym(lib_ptr, :refine_trimesh)
    ccall(refine_trimesh_ptr,
                        Cvoid,
                        (Ref{Mesh_ptr_C}, 
                            Ref{Mesh_ptr_C},
                            Ref{Mesh_ptr_C},
                            Cstring),
                        Ref(mesh_in),
                        Ref(mesh_buffer), Ref(vor_buffer),
                        switches)
    Libdl.dlclose(lib_ptr)

    mesh = TriMesh(mesh_buffer, vor_buffer, info_str)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------



# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    refine(m :: TriMesh, switches :: String; <keyword arguments>)

Refines a triangular mesh according to user set constraints. Command line switches are passed directly.
Use this function only if you know what you are doing.

# Keyword arguments
- `divide_cell_into :: Int = 4`: Triangles listed in `ind_cell` are area constrained
                                    by 1/divide_cell_into * area(triangle[ind_cell]) in refined triangulation.
- `ind_cell :: Array{Int,1} = collect(1:m.n_cell)`: List of triangles to be refined.
- `info_str :: String = "Refined mesh"`: Some info string.
"""
function refine(m :: TriMesh, switches :: String;
                                divide_cell_into :: Int = 4,
                                ind_cell :: Array{Int,1} = collect(1:m.n_cell),
                                info_str :: String = "Refined mesh")
    
    # Do some sanity check of inputs    
    if isempty(ind_cell)
        Base.@error("List of cells to be refined must not be empty. Leave this option blank to refine globally.")
    end

    n_point = Cint(m.n_point)
    point = convert(Array{Cdouble,2}, m.point)

    
    # input cells
    n_cell = Cint(m.n_cell)
    cell = convert(Array{Cint,2}, m.cell)
    
    
    # If the list of triangles to be refined is not empty set up
    # `cell_area_constraint` for input and `-a` to switch without a number
    # following.
    cell_area_constraint = -ones(m.n_cell)
    for i in ind_cell
        cell_area_constraint[i] = abs(det([m.point[:,m.cell[:,i]] ; ones(1,3)])) / (2*divide_cell_into)
    end
    switches = switches * "a"


    n_segment = Cint(m.n_segment)
    if n_segment>0
        segment = convert(Array{Cint,2}, m.segment)
        segment_marker = convert(Array{Cint,1}, m.segment_marker)
    else
        segment = Array{Cint,2}(undef,2,0)
        segment_marker = Array{Cint,1}(undef,0)
    end


    # If there are edges use them (not necessary but does not harm)
    n_edge = Cint(m.n_edge)
    if n_edge>0
        edge = convert(Array{Cint,2}, m.edge)
        edge_marker = convert(Array{Cint,1}, m.edge_marker)
    else
        edge = Array{Cint,2}(undef,2,0)
        edge_marker = Array{Cint,1}(undef,0)
    end

    # If there are point marker then use them
    n_point_marker = Cint(m.n_point_marker)
    if n_point_marker==1
        point_marker = convert(Array{Cint,2}, m.point_marker)
    elseif n_point_marker==0
        point_marker = Array{Cint,2}(n_point_marker,n_point)
    else
        Base.@error("Number of n_point_marker must either be 0 or 1.")
    end

    
    # If there are point attributes then use them
    n_point_attribute = Cint(m.n_point_attribute)
    if n_point_marker>0
        point_attribute = convert(Array{Cdouble,2}, m.point_attribute)
    else
        point_attribute = Array{Cdouble,2}(undef,n_point_attribute, n_point)
    end


    n_hole = Cint(m.n_hole)
    if n_hole>0
        hole = convert(Array{Cdouble,2}, m.hole)
    else
        hole = Array{Cdouble,2}(undef,2,n_hole)
    end

    mesh_in = Mesh_ptr_C(n_point, point,
                            n_point_marker, point_marker,
                            n_point_attribute, point_attribute,
                            n_cell, cell, cell_area_constraint,
                            n_edge, edge, edge_marker,
                            n_segment, segment, segment_marker,
                            n_hole, hole)

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    lib_ptr = Libdl.dlopen(libtesselate)
    refine_trimesh_ptr = Libdl.dlsym(lib_ptr, :refine_trimesh)
    ccall(refine_trimesh_ptr,
                        Cvoid,
                        (Ref{Mesh_ptr_C}, 
                            Ref{Mesh_ptr_C},
                            Ref{Mesh_ptr_C},
                            Cstring),
                        Ref(mesh_in),
                        Ref(mesh_buffer), Ref(vor_buffer),
                        switches)
    Libdl.dlclose(lib_ptr)

    mesh = TriMesh(mesh_buffer, vor_buffer, info_str)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------