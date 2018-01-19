# -----------------------------------------------------------
# -----------------------------------------------------------
function create_mesh(poly :: Polygon_pslg;
                                info_str :: String = "Triangular mesh of polygon (PSLG)",
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
                                set_angle_max :: Bool = false,
                                add_switches :: String = "")
    
    switches = "p"

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
                error("Maximum number of Steiner points must be nonnegative.")
            end
        catch
            error("Maximum number of Steiner points must be a nonnegative integer.")
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
                error("Area must be positive.")
            end
        catch
            error("Area must be a positive real number.")
        end

        switches = switches * "a" * max_area_str
    end
    # -------

    # -------
    if set_angle_max
        quality_meshing = true
        max_angle_str = input("Set angle constraint (choose whith care): ")
        # Check if input makes sense
        try
            number = parse(Float64, max_angle_str)
            if number <=0
                error("Minimum angle must be positive.")
            end
            if number >=34
                warning("Minimum angle should not be larger than 34 degrees. For a larger angle TRIANGLE might not converge.")
            end
        catch
            error("Area must be a positive real number and should not be larger than 34 degrees.")
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

    contains(switches, "z") ? error("Triangle switches must not contain 'z'. Zero based indexing is not allowed.") :


    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    ccall((:tesselate_pslg, "libtesselate"), 
                        Void,
                        (Ref{Mesh_ptr_C}, 
                            Ref{Mesh_ptr_C},
                            Cint, Ptr{Cdouble},
                            Cint, Ptr{Cint},
                            Cint, Ptr{Cdouble},
                            Cint, Ptr{Cint}, Ptr{Cint},
                            Cint, Ptr{Cdouble},
                            Cstring),
                        Ref(mesh_buffer), Ref(vor_buffer),
                        poly.n_point, poly.point,
                        poly.n_point_marker, poly.point_marker,
                        poly.n_point_attribute, poly.point_attribute,
                        poly.n_segment, poly.segment, poly.segment_marker,
                        poly.n_hole, poly.hole,
                        switches)

    mesh = TriMesh(mesh_buffer, vor_buffer, info_str)

    return mesh
end


function create_mesh(point :: Array{Float64,2}; 
                            point_marker :: Array{Int,1} = Array{Int,1}(0),
                            point_attribute :: Array{Float64,2} = Array{Float64,2}(size(point,1),0),
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
                            set_angle_max :: Bool = false,
                            add_switches :: String = "")
    
    switches = "p"

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
                error("Maximum number of Steiner points must be nonnegative.")
            end
        catch
            error("Maximum number of Steiner points must be a nonnegative integer.")
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
                error("Area must be positive.")
            end
        catch
            error("Area must be a positive real number.")
        end

        switches = switches * "a" * max_area_str
    end
    # -------

    # -------
    if set_angle_max
        quality_meshing = true
        max_angle_str = input("Set angle constraint (choose whith care): ")
        # Check if input makes sense
        try
            number = parse(Float64, max_angle_str)
            if number <=0
                error("Minimum angle must be positive.")
            end
            if number >=34
                warning("Minimum angle should not be larger than 34 degrees. For a larger angle TRIANGLE might not converge.")
            end
        catch
            error("Area must be a positive real number and should not be larger than 34 degrees.")
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
  
    contains(switches, "z") ? error("Triangle switches must not contain 'z'. Zero based indexing is not allowed.") :


    poly = polygon_struct_from_points(point, point_marker, point_attribute)
    
    mesh = create_mesh(poly, switches, info_str)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------




# -----------------------------------------------------------
# -----------------------------------------------------------
function create_mesh(poly :: Polygon_pslg, switches :: String;
                                info_str :: String = "Triangular mesh of polygon (PSLG)")
    
    contains(switches, "z") ? error("Triangle switches must not contain 'z'. Zero based indexing is not allowed.") :

    mesh_buffer = Mesh_ptr_C()
    vor_buffer = Mesh_ptr_C()

    ccall((:tesselate_pslg, "libtesselate"), 
                        Void,
                        (Ref{Mesh_ptr_C},
                            Ref{Mesh_ptr_C},
                            Cint, Ptr{Cdouble},
                            Cint, Ptr{Cint},
                            Cint, Ptr{Cdouble},
                            Cint, Ptr{Cint}, Ptr{Cint},
                            Cint, Ptr{Cdouble},
                            Cstring),
                        Ref(mesh_buffer), Ref(vor_buffer),
                        poly.n_point, poly.point,
                        poly.n_point_marker, poly.point_marker,
                        poly.n_point_attribute, poly.point_attribute,
                        poly.n_segment, poly.segment, poly.segment_marker,
                        poly.n_hole, poly.hole,
                        switches)

    mesh = TriMesh(mesh_buffer, vor_buffer, info_str)

    return mesh
end


function create_mesh(point :: Array{Float64,2}, switches :: String;
                                    point_marker :: Array{Int,1} = Array{Int,1}(0),
                                    point_attribute :: Array{Float64,2} = Array{Float64,2}(size(point,1),0),
                                    info_str :: String = "Triangular mesh of convex hull of point cloud.")
  
    contains(switches, "z") ? error("Triangle switches must not contain 'z'. Zero based indexing is not allowed.") :

    if ~contains(switches, "c") 
        info("Option '-c' added. Triangle switches must contain the -c option for point clouds.")
        switches = switches * "c"
    end

    poly = polygon_struct_from_points(point, point_marker, point_attribute)
    
    mesh = create_mesh(poly, switches, info_str)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------