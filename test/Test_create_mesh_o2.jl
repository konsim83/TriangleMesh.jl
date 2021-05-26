@testset "Create mesh" begin
    
	@testset "Mesh of unit square with hole" begin
		println("1st pass with TriangleMesh switches 'second_order_triangles' ")
	    p = polygon_unitSquareWithHole()
	    m = create_mesh(p, info_str="Mesh test",
                            verbose=false,
                            check_triangulation=true,
                            voronoi=true,
                            delaunay=true,
                            output_edges=true,
                            output_cell_neighbors=true,
                            quality_meshing=true,
                            prevent_steiner_points_boundary=false,
                            prevent_steiner_points=false,
                            set_max_steiner_points=false,
                            set_area_max=false,
                            set_angle_min=false,
							second_order_triangles=true,
                            add_switches="")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
		println("Node connectivity, first triangle: ", m.cell[:,1])
		println("Node connectivity, last  triangle: ", m.cell[:,end])
	end

	@testset "Mesh of unit square with hole (manual switch passing)" begin
		println("2nd pass with Triangle switch 'o2' ")
	    p = polygon_unitSquareWithHole()
	    switches = "penvQa0.01o2"
	    m = create_mesh(p, switches, info_str="Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
		println("Node connectivity, first triangle: ", m.cell[:,1])
		println("Node connectivity, last  triangle: ", m.cell[:,end])
	end

	@testset "Mesh of unit square with region (manual switch passing)" begin
	    p = polygon_unitSquareWithRegion()
		switches = "QDpeq33o2Aa0.01"
	    m = create_mesh(p, switches, info_str="Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_region == 1
		println("number of regions: ", m.n_region)
		println("Minimum triangle_attribute: ", minimum(m.triangle_attribute))
		println("Maximum triangle_attribute: ", maximum(m.triangle_attribute))
	end

	@testset "Mesh of unit square with enclosed region (manual switch passing)" begin
	    p = polygon_unitSquareWithEnclosedRegion()
		switches = "QDpeq33o2Aa0.01"
	    m = create_mesh(p, switches, info_str="Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_region == 2
		println("number of regions: ", m.n_region)
		println("Minimum triangle_attribute: ", minimum(m.triangle_attribute))
		println("Maximum triangle_attribute: ", maximum(m.triangle_attribute))
	end

end # end "Create Mesh"