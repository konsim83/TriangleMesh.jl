# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    create_mesh(poly :: Polygon_pslg; <keyword arguments>)

Creates a triangulation of a planar straight-line graph (PSLG) polygon. 

# Keyword arguments
- `info_str :: String = "Triangular mesh of polygon (PSLG)"`: Some mesh info on the mesh
- `verbose :: Bool = false`: Print triangle's output
- `check_triangulation :: Bool = false`: Check triangulation for Delaunay property
                                        after it is created
- `voronoi :: Bool = false`: Output a Voronoi diagram
- `delaunay :: Bool = false`: If true this option ensures that the mesh is Delaunay
                            instead of only constrained Delaunay. You can also set
                            it true if you want to ensure that all Voronoi vertices
                            are within the triangulation. 
- `mesh_convex_hull :: Bool = false`: Mesh the convex hull of a `poly` (useful if the polygon does
                                        not enclose a bounded area - its convex hull still does though)
- `output_edges :: Bool = true`: If true gives an edge list.
- `output_cell_neighbors :: Bool = true`: If true outputs a list of neighboring triangles
                                        for each triangle
- `quality_meshing :: Bool = true`: If true avoids triangles with angles smaller that 20 degrees
- `prevent_steiner_points_boundary :: Bool = false`: If true no Steiner points are added on
                                                    boundary segnents.
- `prevent_steiner_points :: Bool = false`: If true no Steiner points are added on boundary segments 
                                            on inner segments.
- `set_max_steiner_points :: Bool = false`: If true the user will be asked to enter the maximum number
                                             of Steiner points added. If the user inputs 0 this is
                                             equivalent to `set_max_steiner_points = true`.
- `set_area_max :: Bool = false`: If true the user will be asked for the maximum triangle area.
- `set_angle_min :: Bool = false`: If true the user will be asked for a lower bound for minimum 
                                angles in the triangulation.
- `add_switches :: String = ""`: The user can pass additional switches as described in triangle's
                                documentation. Only set this option if you know what you are doing.    

"""
function create_mesh(poly :: Polygon_pslg;
                                info_str :: String = "Triangular mesh of polygon (PSLG)",
                                verbose :: Bool = false,
                                check_triangulation :: Bool = false,
                                voronoi :: Bool = false,
                                delaunay :: Bool = false,
                                mesh_convex_hull :: Bool = false,
                                output_edges :: Bool = true,
                                output_cell_neighbors :: Bool = true,
                                quality_meshing :: Bool = true,
                                prevent_steiner_points_boundary :: Bool = false,
                                prevent_steiner_points :: Bool = false,
                                set_max_steiner_points :: Bool = false,
                                set_area_max :: Bool = false,
                                set_angle_min :: Bool = false,
                                add_switches :: String = "")
    
    switches = "p"

    if ~verbose
        switches = switches * "Q"
    end

    if check_triangulation
        switches = switches * "C"
    end

    if mesh_convex_hull
        switches = switches * "c"
    end

    if voronoi
        switches = switches * "v"
    end

    if delaunay
        switches = switches * "D"
    end

    if output_edges
        switches = switches * "e"
    end

    if output_cell_neighbors
        switches = switches * "n"
    end

    # -------    
    if prevent_steiner_points
        prevent_steiner_points_boundary = true
        switches = switches * "YY"
    else
        if prevent_steiner_points_boundary
            switches = switches * "Y"
        end
    end

    # -------

    # -------
    if set_max_steiner_points
        max_steiner_points_str = input("Maximum number of Steiner points allowed: ")
        # Check if input makes sense
        try
            number = parse(Int, max_steiner_points_str)
            if number<0
                Base.@error("Maximum number of Steiner points must be nonnegative.")
            end
        catch
            Base.@error("Maximum number of Steiner points must be a nonnegative integer.")
        end

        switches = switches * "S" * max_steiner_points_str
    end
    # -------

    # -------
    if set_area_max
        max_area_str = input("Maximum triangle area: ")
        # Check if input makes sense
        try
            number = parse(Float64, max_area_str)
            if number<=0
                Base.@error "Area must be positive."
            end
        catch
            Base.@error "Area must be a positive real number."
        end

        switches = switches * "a" * max_area_str
    end
    # -------

    # -------
    if set_angle_min
        quality_meshing = true
        max_angle_str = input("Set angle constraint (choose whith care): ")
        # Check if input makes sense
        try
            number = parse(Float64, max_angle_str)
            if number <=0
                Base.@error "Minimum angle must be positive."
            end
            if number >=34
                Base.@warn "Minimum angle should not be larger than 34 degrees. For a larger angle TRIANGLE might not converge."
            end
        catch
            Base.@error "Area must be a positive real number and should not be larger than 34 degrees."
        end
        switches = switches * "q" * max_angle_str
    else
        if quality_meshing
            switches = switches * "q"
        end
    end
    # -------


    # This enables to use aditional switches and should be used with care
    switches = switches * add_switches

    if occursin("z",switches) 
        Base.@error("Triangle switches must not contain `z`. Zero based indexing is not allowed.")
    end

    mesh_in = Mesh_ptr_C(poly)

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    lib_ptr = Libdl.dlopen(libtesselate)
    tesselate_pslg_ptr = Libdl.dlsym(lib_ptr, :tesselate_pslg)
    ccall(tesselate_pslg_ptr,
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


"""
    create_mesh(poly :: Polygon_pslg, switches :: String; info_str :: String = "Triangular mesh of polygon (PSLG)")

Creates a triangulation of a planar straight-line graph (PSLG) polygon. 
Options for the meshing algorithm are passed directly by command line switches
for Triangle. Use only if you know what you are doing.
"""
function create_mesh(poly :: Polygon_pslg, switches :: String;
                                info_str :: String = "Triangular mesh of polygon (PSLG)")
    
    if occursin("z", switches)
        error("Triangle switches must not contain `z`. Zero based indexing is not allowed.")
    end

    mesh_in = Mesh_ptr_C(poly)

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    lib_ptr = Libdl.dlopen(libtesselate)
    tesselate_pslg_ptr = Libdl.dlsym(lib_ptr, :tesselate_pslg)
    ccall(tesselate_pslg_ptr,
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
    create_mesh(point :: Array{Float64,2}; <keyword arguments>)

Creates a triangulation of the convex hull of a point cloud.

# Keyword arguments
- `point_marker :: Array{Int,2} = Array{Int,2}(undef,0,size(point,1))`: Points can have a marker.
- `point_attribute :: Array{Float64,2} = Array{Float64,2}(undef,0,size(point,1))`: Points can be 
                                                                            given a number
                                                                            of attributes.
- `info_str :: String = "Triangular mesh of convex hull of point cloud."`: Some mesh info on the mesh
- `verbose :: Bool = false`: Print triangle's output
- `check_triangulation :: Bool = false`: Check triangulation for Delaunay property
                                        after it is created
- `voronoi :: Bool = false`: Output a Voronoi diagram
- `delaunay :: Bool = false`: If true this option ensures that the mesh is Delaunay
                            instead of only constrained Delaunay. You can also set
                            it true if you want to ensure that all Voronoi vertices
                            are within the triangulation. 
- `output_edges :: Bool = true`: If true gives an edge list.
- `output_cell_neighbors :: Bool = true`: If true outputs a list of neighboring triangles
                                        for each triangle
- `quality_meshing :: Bool = true`: If true avoids triangles with angles smaller that 20 degrees
- `prevent_steiner_points_boundary :: Bool = false`: If true no Steiner points are added on
                                                    boundary segnents.
- `prevent_steiner_points :: Bool = false`: If true no Steiner points are added on boundary segments 
                                            on inner segments.
- `set_max_steiner_points :: Bool = false`: If true the user will be asked to enter the maximum number
                                             of Steiner points added. If the user inputs 0 this is
                                             equivalent to `set_max_steiner_points = true`.
- `set_area_max :: Bool = false`: If true the user will be asked for the maximum triangle area.
- `set_angle_min :: Bool = false`: If true the user will be asked for a lower bound for minimum 
                                angles in the triangulation.
- `add_switches :: String = ""`: The user can pass additional switches as described in triangle's
                                documentation. Only set this option if you know what you are doing.    

"""
function create_mesh(point :: Array{Float64,2}; 
                            point_marker :: Array{Int,2} = Array{Int,2}(undef,0,size(point,1)),
                            point_attribute :: Array{Float64,2} = Array{Float64,2}(undef,0,size(point,1)),
                            info_str :: String = "Triangular mesh of convex hull of point cloud.",
                            verbose :: Bool = false,
                            check_triangulation :: Bool = false,
                            voronoi :: Bool = false,
                            delaunay :: Bool = false,
                            output_edges :: Bool = true,
                            output_cell_neighbors :: Bool = true,
                            quality_meshing :: Bool = true,
                            prevent_steiner_points_boundary :: Bool = false,
                            prevent_steiner_points :: Bool = false,
                            set_max_steiner_points :: Bool = false,
                            set_area_max :: Bool = false,
                            set_angle_min :: Bool = false,
                            add_switches :: String = "")
    
    switches = "c"

    if ~verbose
        switches = switches * "Q"
    end

    if check_triangulation
        switches = switches * "C"
    end

    if voronoi
        switches = switches * "v"
    end

    if delaunay
        switches = switches * "D"
    end

    if output_edges
        switches = switches * "e"
    end

    if output_cell_neighbors
        switches = switches * "n"
    end

    # -------    
    if prevent_steiner_points
        prevent_steiner_points_boundary = true
        switches = switches * "YY"
    else
        if prevent_steiner_points_boundary
            switches = switches * "Y"
        end
    end

    # -------

    # -------
    if set_max_steiner_points
        max_steiner_points_str = input("Maximum number of Steiner points allowed: ")
        # Check if input makes sense
        try
            number = parse(Int, max_steiner_points_str)
            if number<0
                Base.@error("Maximum number of Steiner points must be nonnegative.")
            end
        catch
            Base.@error("Maximum number of Steiner points must be a nonnegative integer.")
        end

        switches = switches * "S" * max_steiner_points_str
    end
    # -------

    # -------
    if set_area_max
        max_area_str = input("Maximum triangle area: ")
        # Check if input makes sense
        try
            number = parse(Float64, max_area_str)
            if number<=0
                Base.@error("Area must be positive.")
            end
        catch
            Base.@error("Area must be a positive real number.")
        end

        switches = switches * "a" * max_area_str
    end
    # -------

    # -------
    if set_angle_min
        quality_meshing = true
        max_angle_str = input("Set angle constraint (choose whith care): ")
        # Check if input makes sense
        try
            number = parse(Float64, max_angle_str)
            if number <=0
                Base.@error("Minimum angle must be positive.")
            end
            if number >=34
                Base.@warn("Minimum angle should not be larger than 34 degrees. For a larger angle TRIANGLE might not converge.")
            end
        catch
            Base.@error("Area must be a positive real number and should not be larger than 34 degrees.")
        end
        switches = switches * "q" * max_angle_str
    else
        if quality_meshing
            switches = switches * "q"
        end
    end
    # -------


    # This enables to use aditional switches and should be used with care
    switches = switches * add_switches
  
    occursin("z", switches) ? Base.@error("Triangle switches must not contain `z`. Zero based indexing is not allowed.") :


    poly = polygon_struct_from_points(point, point_marker, point_attribute)
    
    mesh = create_mesh(poly, switches, info_str = info_str)

    return mesh
end



"""

    create_mesh(point :: Array{Float64,2}, switches :: String; <keyword arguments>)

Creates a triangulation of a planar straight-line graph (PSLG) polygon. 
Options for the meshing algorithm are passed directly by command line switches
for Triangle. Use only if you know what you are doing.

# Keyword arguments
- `point_marker :: Array{Int,2} = Array{Int,2}(undef,0,size(point,1))`: Points can have a marker.
- `point_attribute :: Array{Float64,2} = Array{Float64,2}(undef,0,size(point,1))`: Points can be 
                                                                            given a number
                                                                            of attributes.
- `info_str :: String = "Triangular mesh of convex hull of point cloud."`: Some mesh info on the mesh
"""
function create_mesh(point :: Array{Float64,2}, switches :: String;
                                    point_marker :: Array{Int,2} = Array{Int,2}(undef,0,size(point,1)),
                                    point_attribute :: Array{Float64,2} = Array{Float64,2}(undef,0,size(point,1)),
                                    info_str :: String = "Triangular mesh of convex hull of point cloud.")
  
    occursin("z", switches) ? Base.@error("Triangle switches must not contain `z`. Zero based indexing is not allowed.") :

    if ~occursin("c", switches) 
        Base.@info "Option `-c` added. Triangle switches must contain the -c option for point clouds."
        switches = switches * "c"
    end

    poly = polygon_struct_from_points(point, point_marker, point_attribute)
    
    mesh = create_mesh(poly, switches, info_str = info_str)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------
