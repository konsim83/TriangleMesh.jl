# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    refine_rg(m :: TriMesh)

Refine triangular mesh by subdivision of each edge into 2. Very slow for large meshes.
"""
function refine_rg(m :: TriMesh)
    ####################################################
    # This needs an improvement because it is very slow.
    ####################################################

    # Step 1: Set up a new poly structure with points and segements. Ignore
    # point attributes for now (could be taken care of by interpolation,
    # depends on the attribute).
    segment = copy(m.edge)
    point = copy(m.point)
    segment_marker = copy(m.edge_marker)
    point_marker = copy(m.point_marker)

    N = m.n_edge
    progress = Progress(N, 0.01, "Subdividing all edges...", 10)
    for i in 1:m.n_edge
        # New point from edge subdivision
        p = (point[:,segment[1,i]] + point[:,segment[2,i]]) / 2

        # Change one end point
        seg_tmp_2 = segment[2,i]
        segment[2,i] = size(point,2) + 1
        
        # Push the new segment and point
        segment = hcat(segment, [size(point,2)+1 ; seg_tmp_2])
        point = hcat(point, p)

        # Mark segments and points as before.
        point_marker = [point_marker  point_marker[i]]
        segment_marker = push!(segment_marker, segment_marker[i])
        next!(progress)
    end
    
    # Step 2: Build a polygon from the above
    poly = Polygon_pslg(size(point,2), 1, 0,
                        size(segment,2), m.n_hole)
    set_polygon_point!(poly, point')
    set_polygon_point_marker!(poly, point_marker')
    set_polygon_segment!(poly, segment')
    set_polygon_segment_marker!(poly, segment_marker)
    set_polygon_hole!(poly, m.hole')


    
    # Step 3: Triangulate the new Polygon_pslg with the -YY switch. This
    # forces the divided edges into the triangulation.
    switches = "pYYQenv"
    info_str = "Red refined triangular mesh"
    mesh = create_mesh(poly, switches)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------



# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    refine_rg(m :: TriMesh)

Refine triangular mesh by subdivision of each edge into 2. Only triangles listed in `ind_red` are refined. Very slow for large meshes.
"""
function refine_rg(m :: TriMesh, ind_red :: Array{Int,1})
    ####################################################
    # This needs an improvement because it is very slow.
    ####################################################
    
    # Step 1: For all cells to be refined mark the edges that are to be
    # divided
    refinement_marker = zeros(Bool, m.n_edge)

    N = length(ind_red)
    progress = Progress(N, 0.01, "Marking edges to be refined...", 10)
    for i in ind_red
        e = [m.cell[1,i] m.cell[2,i] ; 
            m.cell[2,i] m.cell[3,i] ; 
            m.cell[3,i] m.cell[1,i]]
        for j in 1:3
            ind_found = findall(vec(all(m.edge.==[e[j,1] ; e[j,2]],dims=1)))
            if isempty(ind_found)
                ind_found = findall(vec(all(m.edge.==[e[j,2] ; e[j,1]],dims=1)))
            end
            refinement_marker[ind_found] = [true]
        end
        next!(progress)
    end
    ind_refine_edge = findall(refinement_marker)


    # Step 2: Set up a new poly structure with points and segements. Ignore
    # point attributes for now (could be taken care of by interpolation,
    # depends on the attribute).
    segment = copy(m.edge)
    point = copy(m.point)
    segment_marker = copy(m.edge_marker)
    point_marker = copy(m.point_marker)

    N = length(ind_refine_edge)
    progress = Progress(N, 0.01, "Subdividing marked edges...", 10)
    for i in ind_refine_edge
        # New point from edge subdivision
        p = (point[:,segment[1,i]] + point[:,segment[2,i]]) / 2

        # Change one end point
        seg_tmp_2 = segment[2,i]
        segment[2,i] = size(point,2)+1
        
        # Push the new segment and point
        segment = hcat(segment, [size(point,2)+1 ; seg_tmp_2])
        point = hcat(point, p)

        # Mark segments and points as before.
        point_marker = [point_marker point_marker[i]]
        segment_marker = push!(segment_marker, segment_marker[i])
        next!(progress)
    end

    
    # Step 3: Build a polygon from the above
    poly = Polygon_pslg(size(point,2), 1, 0,
                        size(segment,2), m.n_hole)
    set_polygon_point!(poly, point')
    set_polygon_point_marker!(poly, point_marker')
    set_polygon_segment!(poly, segment')
    set_polygon_segment_marker!(poly, segment_marker)
    set_polygon_hole!(poly, m.hole')

    
    # Step 4: Triangulate the new Polygon_pslg with the -YY switch. This
    # forces the divided edges into the triangulation.
    switches = "pYYQenv"
    info_str = "Red-green refined triangular mesh"
    mesh = create_mesh(poly, switches)

    return mesh
end
# -----------------------------------------------------------
# -----------------------------------------------------------