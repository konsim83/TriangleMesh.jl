# TriangleMesh.jl

*TriangleMesh* is written to provide a convenient mesh generation and refinement tool for Delaunay and constraint Delaunay meshes in Julia. Please see the documentation.

| **Documentation** | **Build Status** | **Code Coverage**| **Windows Build** | 
|:-----------------:|:----------------:|:----------------:|:-----------------:|
| [![][docs-latest-img]][docs-latest-url] | [![][travis-img]][travis-url] |  [![][codecov-img]][codecov-url] | [![Build status][appveyor-img]][appveyor-url] |

### Installation

*TriangleMesh* is now officialy registered. To install run
```julia
] add TriangleMesh
```
After the build passed successfully type
```julia
using TriangleMesh
```
to use the package. If you are having trouble please open an [issue](https://github.com/konsim83/TriangleMesh.jl/issues).

### TriangleMesh on Windows

To build TriangleMesh you need [VC++ for Python](https://www.microsoft.com/en-us/download/details.aspx?id=44266). It is for free and easy to install.

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://konsim83.github.io/TriangleMesh.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://konsim83.github.io/TriangleMesh.jl/stable

[travis-img]: https://travis-ci.org/konsim83/TriangleMesh.jl.svg?branch=master
[travis-url]: https://travis-ci.org/konsim83/TriangleMesh.jl

[codecov-img]: https://codecov.io/gh/konsim83/TriangleMesh.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/konsim83/TriangleMesh.jl

[appveyor-url]: https://ci.appveyor.com/project/konsim83/trianglemesh-jl
[appveyor-img]: https://ci.appveyor.com/api/projects/status/79ww082lilsp21re?svg=true
