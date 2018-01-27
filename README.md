# TriangleMesh.jl

*TriangleMesh* is written to provide a convenient mesh generation and refinement tool for Delaunay and constraint Delaunay meshes in Julia. Please see the documentation.

<center>

| **Documentation**                                                               | **Build Status**                                                                            | **Code Coverage**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url] | [![][travis-img]][travis-url] |  [![][codecov-img]][codecov-url] |

</center>


## Installation

*TriangleMesh* is not officialy registered yet. To install run
```julia
Pkg.clone("https://github.com/konsim83/TriangleMesh.jl.git")
```
and then run
```julia
Pkg.build("TriangleMesh")
```
After the build passed successfully type
```julia
using TriangleMesh
```
to use the package.


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://konsim83.github.io/TriangleMesh.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://konsim83.github.io/TriangleMesh.jl/stable

[travis-img]: https://travis-ci.org/konsim83/TriangleMesh.jl.svg?branch=master
[travis-url]: https://travis-ci.org/konsim83/TriangleMesh.jl

[codecov-img]: https://codecov.io/gh/konsim83/TriangleMesh.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/konsim83/TriangleMesh.jl
