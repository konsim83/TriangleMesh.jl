# -----------------------------------------------------------
# -----------------------------------------------------------
"""
Struct describes a planar straight-line graph (PSLG) of a polygon. It contains points, point markers,
attributes, segments, segment markers and holes.
"""
struct Polygon_pslg

    n_point :: Cint # number of points
    point :: Array{Cdouble, 2} # (2, n_point)-array

    n_point_marker :: Cint # either 0 or 1
    point_marker :: Array{Cint,2}
    
    n_point_attribute :: Cint # number of attributes
    point_attribute :: Array{Cdouble,2}

    n_segment :: Cint # number of segments
    segment :: Array{Cint,2}
    segment_marker :: Array{Cint,1}

    n_hole :: Cint # number of holes
    hole :: Array{Cdouble,2}
    
end


"""
    Polygon_pslg(n_point :: Int, n_point_marker :: Int, n_point_attribute :: Int, n_segment :: Int, n_hole :: Int)

Outer constructor that only reserves space for points, markers, attributes and holes.
Input data is converted to hold C-data structures (Cint and Cdouble arrays) for internal use.
"""
function Polygon_pslg(n_point :: Int, n_point_marker :: Int, n_point_attribute :: Int,
                        n_segment :: Int, n_hole :: Int)
    
    n_point<1 ? Base.@error("Number of polygon points must be positive.") :
    n_point = n_point
    point = Array{Cdouble,2}(undef, 2, n_point)


    if n_point_marker>1 
        Base.@info "Number of point markers > 1. Only 0 or 1 admissible. Set to 1."
        n_point_marker = 1
    end

    point_marker = Array{Cint,2}(undef, n_point_marker, n_point)

    n_point_attribute<0 ? Base.@error("Number of point attributes must be positive.") :
    n_point_attribute = n_point_attribute
    point_attribute = Array{Cdouble,2}(undef, n_point_attribute, n_point)


    n_segment = n_segment
    segment = Array{Cint,2}(undef, 2,n_segment)
    # Set segment marker to 1 by default.
    segment_marker = ones(Cint,n_segment)

    n_hole<0 ? Base.@error("Number of point attributes must be a nonnegative integer.") :
    n_hole = n_hole
    hole = Array{Cdouble,2}(undef, 2, n_hole)


    # Call inner constructor
    poly = Polygon_pslg(n_point, point,
                        n_point_marker, point_marker,
                        n_point_attribute, point_attribute,
                        n_segment, segment, segment_marker,
                        n_hole, hole)

    return poly
end 
# -----------------------------------------------------------
# -----------------------------------------------------------

"""
    set_polygon_point!(poly :: Polygon_pslg, p :: AbstractArray{Float64,2})

Set `poly.point` appropriately. Input must have dimensions `n_point`-by-`2`.
"""
function set_polygon_point!(poly :: Polygon_pslg, p :: AbstractArray{Float64,2})

    if length(p)>0
        size(poly.point)!=size(p') ? Base.@error("Polygon constructor: Point size mismatch...") :

        poly.point[:,:] = convert(Array{Cdouble,2}, p)'
    end

    return nothing
end


"""
    set_polygon_point_marker!(poly :: Polygon_pslg, pm :: AbstractArray{Int,2})

Set `poly.point_marker` appropriately. Input must have dimensions `n_point`-by-`n_point_marker`. `n_point_marker` can be 1 or 0.
"""
function set_polygon_point_marker!(poly :: Polygon_pslg, pm :: AbstractArray{Int,2})

    if length(pm)>0
        size(poly.point_marker)!=(size(pm,2), size(pm,1)) ? Base.@error("Polygon constructor: Point marker mismatch...") :

        poly.point_marker[:,:] = convert(Array{Cint,2}, pm)'
    end

    return nothing
end


"""
    set_polygon_point_attribute!(poly :: Polygon_pslg, pa :: AbstractArray{Float64,2})

Set `poly.point_attribute` appropriately. Input must have dimensions `n_point`-by-`n_point_attribute`.
"""
function set_polygon_point_attribute!(poly :: Polygon_pslg, pa :: AbstractArray{Float64,2})

    if length(pa)>0
        size(poly.point_attribute)!=size(pa') ? Base.@error("Polygon constructor: Point attribute mismatch...") :

        poly.point_attribute[:,:] = convert(Array{Cdouble,2}, pa)'
    end

    return nothing
end


"""
    set_polygon_segment!(poly :: Polygon_pslg, s :: AbstractArray{Int,2})

Set `poly.segment` appropriately. Input must have dimensions `n_segment`-by-`2`.
"""
function set_polygon_segment!(poly :: Polygon_pslg, s :: AbstractArray{Int,2})

    if length(s)>0
        size(poly.segment)!=size(s') ? Base.@error("Polygon constructor: Segment size mismatch...") :

        poly.segment[:,:] = convert(Array{Cint,2}, s)'
    end

    return nothing
end


"""
    set_polygon_segment_marker!(poly :: Polygon_pslg, sm :: AbstractArray{Int,1})

Set `poly.segment_marker` appropriately. Input must have dimensions `n_segment`-by-`1`. If not set every segemnt will have marker equal to 1.
"""
function set_polygon_segment_marker!(poly :: Polygon_pslg, sm :: AbstractArray{Int,1})

    if length(sm)>0
        size(poly.segment_marker)!=size(sm) ? Base.@error("Polygon constructor: Segment marker mismatch...") :

        poly.segment_marker[:] = convert(Array{Cint,1}, sm)
    end

    return nothing
end


"""
    set_polygon_hole!(poly :: Polygon_pslg, h :: AbstractArray{Float64,2})

Set `poly.hole` appropriately. Input must have dimensions `n_hole`-by-`2`.

!!!
    Each hole must be enclosed by segments. Do not place holes on segments.
"""
function set_polygon_hole!(poly :: Polygon_pslg, h :: AbstractArray{Float64,2})

    if length(h)>0
        size(poly.hole)!=size(h') ? Base.@error("Polygon constructor: Hole mismatch...") :

        poly.hole[:,:] = convert(Array{Cdouble,2}, h)'
    end

    return nothing
end