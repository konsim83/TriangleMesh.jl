using BinDeps

isfile("deps.jl") && rm("deps.jl")

@BinDeps.setup
    libtesselate = library_dependency("libtesselate", aliases = ["libtesselate.dylib"], runtime = true)

    rootdir = BinDeps.depsdir(libtesselate)
    srcdir = joinpath(rootdir, "src")
    prefix = joinpath(rootdir, "usr")
    libdir = joinpath(prefix, "lib")
    headerdir = joinpath(prefix, "include")

    if Sys.iswindows()
        libfile = joinpath(libdir, "libtesselate.dll")
        arch = "x86"
        if Sys.WORD_SIZE == 64
            arch = "x64"
        end
        @build_steps begin
            FileRule(libfile, @build_steps begin
                 BinDeps.run(@build_steps begin
                    ChangeDirectory(srcdir)
                    `cmd /c compile.bat all $arch`
                    `cmd /c copy libtesselate.dll $libfile`
                    `cmd /c copy triangle.h $headerdir`
                    `cmd /c copy tesselate.h $headerdir`
                    `cmd /c copy commondefine.h $headerdir`
                    `cmd /c compile.bat clean $arch`
            end) end) end

        provides(Binaries, URI(libfile), libtesselate)
    else
        libname = "libtesselate.so"
        if Sys.isapple()
            libname = "libtesselate.dylib"
        end
        libfile = joinpath(libdir, libname)
        provides(BinDeps.BuildProcess, (@build_steps begin
                    FileRule(libfile, @build_steps begin
                        BinDeps.ChangeDirectory(srcdir)
                        `make clean`
                        `make libtesselate`
                        `cp libtesselate.so $libfile`
                        `cp triangle.h $headerdir/`
                        `cp tesselate.h $headerdir/`
                        `cp commondefine.h $headerdir/`
                        `make clean`
                    end)
                end), libtesselate)
    end

@BinDeps.install Dict(:libtesselate => :libtesselate)
