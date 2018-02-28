@testset "Writing mesh to file" begin

    p = polygon_unitSquareWithHole()

    switches = "penvQa0.01"
    m = create_mesh(p, switches, info_str = "Mesh test")

    write_mesh(m, "test_mesh_write")

    @test isfile(pwd() * "/meshfiles/test_mesh_write.node")
    @test isfile(pwd() * "/meshfiles/test_mesh_write.ele")
    @test isfile(pwd() * "/meshfiles/test_mesh_write.edge")
    @test isfile(pwd() * "/meshfiles/test_mesh_write.neigh")
           
   rm(pwd() * "/meshfiles/", recursive=true)
end