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

To build TriangleMesh you need the Visual Studio Community Edition 2017 which you can get [here](https://www.techspot.com/downloads/6278-visual-studio.html). It is for free and easy to install.

You can also use a newer version of Visual Studio (and at any rate it is only important that you have the build tools installed) but then you will have to modify the environment variable in the 'compile.bat' script in the 'deps/src/' directory:
> set VS150COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\

for example becomes

> set VS150COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\

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
