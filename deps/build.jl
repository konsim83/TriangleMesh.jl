using BinDeps

isfile("deps.jl") && rm("deps.jl")

@BinDeps.setup
    libtesselate = library_dependency("libtesselate", aliases = ["libtesselate.dylib"], runtime = true)

    rootdir = BinDeps.depsdir(libtesselate)
    srcdir = joinpath(rootdir, "src")
    prefix = joinpath(rootdir, "usr")
    libdir = joinpath(prefix, "lib")
    headerdir = joinpath(prefix, "include")

    if is_windows()
        libfile = joinpath(libdir, "libtesselate.dll")
        error("Package build rules not implemented for Windows yet.")
    else 
        libname = "libtesselate.so"
        if is_apple()
            libname = "libtesselate.dylib"
        end
        libfile = joinpath(libdir, libname)
        provides(BinDeps.BuildProcess, 
                    (@build_steps begin
                        FileRule(libfile, 
                                    @build_steps begin
                                        BinDeps.ChangeDirectory(srcdir)
                                        `make clean`
                                        `make libtesselate`
                                        `cp libtesselate.so $libfile`
                                        `cp triangle.h $headerdir/`
                                        `cp allocate.h $headerdir/`
                                        `cp tesselate.h $headerdir/`
                                        `make clean`
                                    end)
                    end), libtesselate)
    end

@BinDeps.install Dict(:libtesselate => :libtesselate)