@testset "Create mesh" begin
    
	@testset "Mesh of unit square with hole" begin
		println("1st pass with TriangleMesh switches 'second_order_triangles' ")
	    p = polygon_unitSquareWithHole()
	    m = create_mesh(p, info_str = "Mesh test",
                            verbose = false,
                            check_triangulation = true,
                            voronoi = true,
                            delaunay = true,
                            output_edges = true,
                            output_cell_neighbors = true,
                            quality_meshing = true,
                            prevent_steiner_points_boundary  = false,
                            prevent_steiner_points = false,
                            set_max_steiner_points = false,
                            set_area_max = false,
                            set_angle_min = false,
							second_order_triangles = true,
                            add_switches = "")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
		println(m.cell[:,1])
		println(m.cell[:,end])
	end

	@testset "Mesh of unit square with hole (manual switch passing)" begin
		println("2nd pass with Triangle switch 'o2' ")
	    p = polygon_unitSquareWithHole()
	    switches = "penvQa0.01o2"
	    m = create_mesh(p, switches, info_str = "Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
		println(m.cell[:,1])
		println(m.cell[:,end])
	end

	@testset "Mesh of unit square with hole (manual switch passing)" begin
		println("2nd pass with Triangle switch 'o2' ")
	    p = polygon_unitSquareWithRegion()
	    switches = "penvQa0.01o2"
	    m = create_mesh(p, switches, info_str = "Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_region == 1
	    @test m.voronoi.n_point > 1
		println("number of regions ", m.n_region)
		println("regions ", m.region)
		println("triangle_attribute ", m.triangle_attribute)
	end


	# @testset "Mesh of unit square with hole (with regional attribute)" begin
	# 	println("Testing regional attribute support ")
	#     # p = polygon_unitSquareWithRegion()
	# 	p = polygon_unitSquareWithHole()
	# 	switches = "penvQa0.01o2"
	#     m = create_mesh(p, switches, info_str = "Mesh test")
	# 	@test m.n_point > 1
	#     @test m.n_cell > 1
	#     @test m.n_edge > 1
	#     @test m.n_segment > 1
	#     @test m.n_hole == 0
	# 	@test m.n_region == 0
	#     @test m.voronoi.n_point > 1
	# println("number of regions ", m.n_region)
	# println("regions ", m.region)
	# println("triangle_attribute ", m.triangle_attribute)
	# end

end # end "Create Mmsh"