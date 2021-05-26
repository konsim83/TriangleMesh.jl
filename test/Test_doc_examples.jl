@testset "Documentation examples" begin
    
	@testset "Create a PSLG" begin
    # example from the documentation

		println("Testing documentation example")
		poly = Polygon_pslg(8, 1, 2, 8, 1)
		println("PSLG created")

		point = [1.0 0.0 ; 0.0 1.0 ; -1.0 0.0 ; 0.0 -1.0 ;
				0.25 0.25 ; -0.25 0.25 ; -0.25 -0.25 ; 0.25 -0.25] 
		segment = [1 2 ; 2 3 ; 3 4 ; 4 1 ; 5 6 ; 6 7 ; 7 8 ; 8 5] 
		point_marker = [ones(Int, 4, 1) ; 2 * ones(Int, 4, 1)]
		segment_marker = [ones(Int, 4) ; 2 * ones(Int, 4)]
		point_attribute = rand(8, 2) 
		hole = [0.5  0.5] 

		set_polygon_point!(poly, point)
		set_polygon_point_marker!(poly, point_marker)
		set_polygon_point_attribute!(poly, point_attribute)
		set_polygon_segment!(poly, segment)
		set_polygon_segment_marker!(poly, segment_marker)
		set_polygon_hole!(poly, hole)

		@test poly.n_point == 8
		@test poly.n_segment == 8
		@test poly.n_point_marker == 1
		@test poly.n_point_attribute == 2
		@test poly.n_hole == 1
		@test poly.n_region == 0
		@test poly.n_triangle_attribute == 0
	end

end # end Documentation examples