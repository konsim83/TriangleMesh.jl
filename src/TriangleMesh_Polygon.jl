# -----------------------------------------------------------
# -----------------------------------------------------------
struct Polygon_pslg#{T} <: Union{Array{Cdouble,2}, Array{Cint,1}, Array{Cint,2}, UnionAll}

    n_point :: Cint # number of points
    point :: Any#Array{Cdouble, 2} # (2, n_point)-array

    n_point_marker :: Cint # either 0 or 1
    point_marker :: Any#T
    
    n_point_attribute :: Cint # number of attributes
    point_attribute :: Any#T

    n_segment :: Cint # number of segments
    segment :: Any#T
    segment_marker :: Any#T

    n_hole :: Cint # number of holes
    hole :: Any#T
    
end

# Outer constructor that only reserves space
function Polygon_pslg(n_point :: Int, n_point_marker :: Int, n_point_attribute :: Int,
                        n_segment :: Int, n_hole :: Int)

    n_point = Cint(n_point)
    if n_point>0
        point = Array{Cdouble,2}(2,n_point)
    else
        error("Number of polygon points must be positive.")
    end

    if n_point_marker>0
        n_point_marker>1 ? info("Number of point markers > 1. Only 0 or 1 admissible. Set to one.") :
        n_point_marker = Cint(1)

        point_marker = Array{Cint,2}(n_point,n_point_marker)
    else
        n_point_marker = Cint(0)
        point_marker = C_NULL
    end

    n_point_attribute = Cint(n_point_attribute)
    if n_point_attribute>0
        point_attribute = Array{Cdouble,2}(n_point_attribute, n_point)
    else
        point_attribute = C_NULL
    end

    n_segment = Cint(n_segment)
    if n_segment>0
        segment = Array{Cint,2}(2,n_segment)
        segment_marker = Array{Cint,1}(n_segment)
    else
        segment = C_NULL
        segment_marker = C_NULL
    end

    n_hole = Cint(n_hole)
    if n_hole>0
        hole = Array{Cdouble,2}(2,n_hole)
    else
        hole = C_NULL
    end

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


function set_polygon_point!(poly :: Polygon_pslg, p :: Array{Float64,2})

    if length(p)>0
        size(poly.point)!=size(p') ? error("Polygon constructor: Point size mismatch...") :

        poly.point[:,:] = p'
    end

    return nothing
end


function set_polygon_point_marker!(poly :: Polygon_pslg, pm :: Array{Int,2})

    if length(pm)>0
        size(poly.point_marker)!=size(pm) ? error("Polygon constructor: Point marker mismatch...") :

        poly.point_marker[:,:] = convert(Array{Cint,2}, pm)
    end

    return nothing
end


function set_polygon_point_attribute!(poly :: Polygon_pslg, pa :: Array{Float64,2})

    if length(pa)>0
        size(poly.point_attribute)!=size(pa') ? error("Polygon constructor: Point attribute mismatch...") :

        poly.point_attribute[:,:] = pa'
    end

    return nothing
end


function set_polygon_segment!(poly :: Polygon_pslg, s :: Array{Int,2})

    if length(s)>0
        size(poly.segment)!=size(s') ? error("Polygon constructor: Segment size mismatch...") :

        poly.segment[:,:] = convert(Array{Cint,2}, s)'
    end

    return nothing
end


function set_polygon_segment_marker!(poly :: Polygon_pslg, sm :: Array{Int,1})

    if length(sm)>0
        size(poly.segment_marker)!=size(sm) ? error("Polygon constructor: Segment marker mismatch...") :

        poly.segment_marker[:] = convert(Array{Cint,1}, sm)
    end

    return nothing
end


function set_polygon_hole!(poly :: Polygon_pslg, h :: Array{Float64,2})

    if length(h)>0
        size(poly.hole)!=size(h') ? error("Polygon constructor: Hole mismatch...") :

        poly.hole[:,:] = h'
    end

    return nothing
end