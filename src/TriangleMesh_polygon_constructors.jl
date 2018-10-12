# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    polygon_unitSimplex()

Create a polygon of the unit simplex (example code).
"""
function polygon_unitSimplex()

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = 3
    n_point_marker = 1 # Set up one point marker
    n_point_attribute = 0 # no special point attributes
    n_segment = 3
    n_hole = 0 # no holes

    # Initialize a polygon and reserve memory ()
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    point = [0.0 0.0 ; 1.0 0.0 ; 0.0 1.0]
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    pm = ones(Int, n_point,n_point_marker)
    set_polygon_point_marker!(poly, pm)

    # 4 segments, indexing starts at one
    s = [1 2 ; 2 3 ; 3 1]
    set_polygon_segment!(poly, s)

    # Mark all input segments with one (as boundary marker)
    sm = ones(Int, n_segment)
    set_polygon_segment_marker!(poly, sm)

    return poly
end


"""
    polygon_unitSquare()

Create a polygon of the unit square (example code).
"""
function polygon_unitSquare()

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = 4
    n_point_marker = 1 # Set up one point marker
    n_point_attribute = 0 # no special point attributes
    n_segment = 4
    n_hole = 0 # no holes

    # Initialize a polygon and reserve memory
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    point = [0.0 0.0 ; 1.0 0.0 ; 1.0 1.0 ; 0.0 1.0]
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    pm = ones(Int, n_point,n_point_marker)
    set_polygon_point_marker!(poly, pm)

    # Create random attributes
    pa = rand(n_point, n_point_attribute)
    set_polygon_point_attribute!(poly, pa)

    # 4 segments, indexing starts at one
    s = [1 2 ; 2 3 ; 3 4 ; 4 1]
    set_polygon_segment!(poly, s)

    # Mark all input segments with one (as boundary marker)
    sm = ones(Int, n_segment)
    set_polygon_segment_marker!(poly, sm)

    return poly
end


"""
    polygon_regular(n_corner :: Int)

Create a polygon of a regular polyhedron with `n_corner` corners (example code).
"""
function polygon_regular(n_corner :: Int)

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = n_corner
    n_point_marker = 1 # Set up one point marker
    n_point_attribute = 0 # no special point attributes
    n_segment = n_point
    n_hole = 0 # no holes

    # Initialize a polygon and reserve memory
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    point = zeros(n_point,2)
    phi = range(0, stop=2*pi, length=n_point+1)[1:end-1]
    point = [cos.(phi) sin.(phi)]
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    pm = ones(Int, n_point,n_point_marker)
    set_polygon_point_marker!(poly, pm)

    # 4 segments, indexing starts at one
    s = [1:n_point circshift(1:n_point,-1)]
    set_polygon_segment!(poly, s)

    # Mark all input segments with one (as boundary marker)
    sm = ones(Int, n_segment)
    set_polygon_segment_marker!(poly, sm)

    return poly
end


"""
    polygon_unitSquareWithHole()

Create a polygon of the unit square that has a squared hole in the middle (example code).
"""
function polygon_unitSquareWithHole()

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = 8
    n_point_marker = 1 # Set up one point marker
    n_point_attribute = 2 # no special point attributes
    n_segment = 8
    n_hole = 1 # no holes

    # Initialize a polygon and reserve memory
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    point = [0.0 0.0 ; 1.0 0.0 ; 1.0 1.0 ; 0.0 1.0 ; 
            0.25 0.25 ; 0.75 0.25 ; 0.75 0.75 ; 0.25 0.75]
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    pm = [ones(Int, 4,n_point_marker) ; 2*ones(Int, 4,n_point_marker)]
    set_polygon_point_marker!(poly, pm)

    # Create random attributes
    pa = rand(n_point, n_point_attribute)
    set_polygon_point_attribute!(poly, pa)

    # 4 segments, indexing starts at one
    s = [1 2 ; 2 3 ; 3 4 ; 4 1 ;
        5 6 ; 6 7 ; 7 8 ; 8 5]
    set_polygon_segment!(poly, s)

    # Mark all input segments with one (as boundary marker)
    sm = [ones(Int, 4) ; ones(Int, 4)]
    set_polygon_segment_marker!(poly, sm)

    # This hole is marked by the point (0.5,0.5). The hole is as big as the
    # segment that encloses the point.
    h = [0.5 0.5]
    set_polygon_hole!(poly, h)

    return poly
end


"""
    polygon_Lshape()

Create a polygon of an L-shaped domain (example code).
"""
function polygon_Lshape()

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = 6
    n_point_marker = 1 # Set up one point marker
    n_point_attribute = 2 # no special point attributes
    n_segment = 6
    n_hole = 0 # no holes

    # Initialize a polygon and reserve memory
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    point = [0.0 0.0 ; 1.0 0.0 ; 1.0 0.5 ; 0.5 0.5 ; 0.5 1.0 ; 0.0 1.0]
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    pm = ones(Int, n_point,n_point_marker)
    set_polygon_point_marker!(poly, pm)

    # Create random attributes
    pa = rand(n_point, n_point_attribute)
    set_polygon_point_attribute!(poly, pa)

    # 4 segments, indexing starts at one
    s = [1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 6 ; 6 1]
    set_polygon_segment!(poly, s)

    # Mark all input segments with one (as boundary marker)
    sm = ones(Int, n_segment)
    set_polygon_segment_marker!(poly, sm)

    return poly
end


"""
    polygon_struct_from_points(point :: Array{Float64,2},
                                    pm :: Array{Int,2},
                                    pa :: Array{Float64,2})

Create a polygon from a set of points (example code). No segments or holes are set here.

# Arguments
- `point :: Array{Float64,2}`: point set (dimension n-by-2)
- `pm :: Array{Int,2}`: each point can have a marker (dimension either n-by-0 or n-by-1)
- `pa :: Array{Float64,2}`: each point can have a number of ``k>=0``real attributes (dimension n-by-k)
"""
function polygon_struct_from_points(point :: Array{Float64,2},
                                    pm :: Array{Int,2},
                                    pa :: Array{Float64,2})
    
    # Create a Polygon_pslg struct as the input for TRIANGLE. The Polygon_pslg
    # struct then only contains points, markers and attributes.

    size(point,2)!=2 ? Base.@error("Point set must have dimensions (n,2).") :

    # Choose the numbers. Everything that is zero does not need to be set.
    n_point = size(point,1)
    n_point_marker = size(pm,2) # Set up one point marker
    n_point_attribute = size(pa,2) # no special point attributes
    n_segment = 0
    n_hole = 0 # no holes

    # Initialize a polygon and reserve memory
    poly = Polygon_pslg(n_point, n_point_marker, n_point_attribute, n_segment, n_hole)

    # 4 points
    set_polygon_point!(poly, point)

    # Mark all input points with one (as boundary marker)
    set_polygon_point_marker!(poly, pm)

    # Create random attributes
    set_polygon_point_attribute!(poly, pa)

    return poly
end
# -----------------------------------------------------------
# -----------------------------------------------------------