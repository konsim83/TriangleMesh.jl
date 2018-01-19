push!(LOAD_PATH,"../src/")

using Documenter, TriangleMesh

makedocs(
    format = :html,
    sitename = "TriangleMesh",
    pages = []
)

deploydocs(
    repo   = "https://github.com/konsim83/TriangleMesh.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing
)
