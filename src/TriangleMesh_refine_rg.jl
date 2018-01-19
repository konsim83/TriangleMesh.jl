# -----------------------------------------------------------
# -----------------------------------------------------------
function refine_rg(m :: TriMesh)

    # Step 1: Set up a new poly structure with points and segements. Ignore
    # point attributes for now (could be taken care of by interpolation,
    # depends on the attribute).
    segment = copy(m.edge)
    point = copy(m.point)
    segment_marker = copy(m.edge_marker)
    point_marker = copy(m.point_marker)

    N = m.n_edge
    progress = Progress(N, 0.01, "Refining edges...", 10)
    for i in 1:m.n_edge
        # New point from edge subdivision
        p = (point[segment[i,1],:] + point[segment[i,2],:]) / 2

        # Change one end point
        seg_tmp_2 = segment[i,2]
        segment[i,2] = size(point,1) + 1
        
        # Push the new segment and point
        segment = vcat(segment, [size(point,1) + 1 seg_tmp_2])
        point = vcat(point, p')

        # Mark segments and points as before.
        point_marker = [point_marker ; point_marker[i]]
        segment_marker = push!(segment_marker, segment_marker[i])
        next!(progress)
    end
    println("...done.\n")
    
    # Step 2: Build a polygon from the above
    poly = Polygon_pslg(size(point,1), 1, 0,
                        size(segment,1), 0)
    set_polygon_point!(poly, point)
    set_polygon_point_marker!(poly, point_marker)
    set_polygon_segment!(poly, segment)
    set_polygon_segment_marker!(poly, segment_marker)

    
    # Step 3: Triangulate the new Polygon_pslg with the -YY switch. This
    # forces the divided edges into the triangulation.
    switches = "pYYQenv"
    info_str = "Red refined complete triangular mesh"
    mesh = create_mesh(poly, switches)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------



# -----------------------------------------------------------
# -----------------------------------------------------------
function refine_rg(m :: TriMesh, 
                    ind_red :: Array{Int,1})

    # Step 1: For all cells to be refined mark the edges that are to be
    # divided
    refinement_marker = zeros(Bool, m.n_edge)

    N = length(ind_red)
    progress = Progress(N, 0.01, "Marking edges to be refined...", 10)
    for i in ind_red
        e = [m.cell[i,1] m.cell[i,2] ; 
            m.cell[i,2] m.cell[i,3] ; 
            m.cell[i,3] m.cell[i,1]]
        for j in 1:3
            ind_found = find(all(m.edge.==[e[j,1] e[j,2]],2))
            if isempty(ind_found)
                ind_found = find(all(m.edge.==[e[j,2] e[j,1]],2))
            end
            refinement_marker[ind_found] = true
        end
        next!(progress)
    end
    ind_refine_edge = find(refinement_marker)
    println("...done.\n")


    # Step 2: Set up a new poly structure with points and segements. Ignore
    # point attributes for now (could be taken care of by interpolation,
    # depends on the attribute).
    segment = copy(m.edge)
    point = copy(m.point)
    segment_marker = copy(m.edge_marker)
    point_marker = copy(m.point_marker)

    N = length(ind_refine_edge)
    progress = Progress(N, 0.01, "Refining marked edges...", 10)
    for i in ind_refine_edge
        # New point from edge subdivision
        p = (point[segment[i,1],:] + point[segment[i,2],:]) / 2

        # Change one end point
        seg_tmp_2 = segment[i,2]
        segment[i,2] = size(point,1) + 1
        
        # Push the new segment and point
        segment = vcat(segment, [size(point,1) + 1 seg_tmp_2])
        point = vcat(point, p')

        # Mark segments and points as before.
        point_marker = [point_marker ; point_marker[i]]
        segment_marker = push!(segment_marker, segment_marker[i])
        next!(progress)
    end
    println("...done.\n")

    
    # Step 3: Build a polygon from the above
    poly = Polygon_pslg(size(point,1), 1, 0,
                        size(segment,1), 0)
    set_polygon_point!(poly, point)
    set_polygon_point_marker!(poly, point_marker)
    set_polygon_segment!(poly, segment)
    set_polygon_segment_marker!(poly, segment_marker)

    
    # Step 4: Triangulate the new Polygon_pslg with the -YY switch. This
    # forces the divided edges into the triangulation.
    switches = "pYYQenv"
    info_str = "Red-green refined triangular mesh"
    mesh = create_mesh(poly, switches)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------