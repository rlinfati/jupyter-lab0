#!/bin/sh

set -x

export CONDA_PKGS_DIRS=$HOME/.orlibs/pkgsx/

if [[ $(uname -m) == "x86_64" ]]; then \
    conda create --quiet --yes --prefix $HOME/.orlibs/pycpx --no-deps ibmdecisionoptimization::cplex ; \
else true; fi && \
conda create --quiet --yes --prefix $HOME/.orlibs/pygrb --no-deps gurobi::gurobi && \
conda create --quiet --yes --prefix $HOME/.orlibs/pyxpr --no-deps fico-xpress::xpress=9.4 fico-xpress::xpresslibs=9.4 && \
conda clean --all --yes && \
find $HOME/.orlibs/pycpx/ -type f -name libcplex\* -ls && \
find $HOME/.orlibs/pygrb/ -type f -name libgurobi\* -ls && \
find $HOME/.orlibs/pyxpr/ -type f -name libxprs.\* -ls && \
find $HOME/.orlibs/pyxpr/ -type f -name libxprl\* -ls && \
find $HOME/.orlibs/pyxpr/ -type f -name \*xpauth.xpr -ls
# FIX: fico-xpress::xpress=9.5

conda create --quiet --yes --prefix $HOME/.orlibs/pypip python=3.12 &&
$HOME/.orlibs/pypip/bin/python -m pip --no-cache-dir install amplpy --upgrade && \
if [[ $(uname -m) == "x86_64" ]]; then \
    $HOME/.orlibs/pypip/bin/python -m amplpy.modules install --no-cache-dir cplex gurobi xpress; \
else \
    $HOME/.orlibs/pypip/bin/python -m amplpy.modules install --no-cache-dir       gurobi xpress; \
fi && \
conda clean --all --yes && \
find $HOME/.orlibs/pypip/ -type f -name libcplex\* -ls && \
find $HOME/.orlibs/pypip/ -type f -name libgurobi\* -ls && \
find $HOME/.orlibs/pypip/ -type f -name libxprs.\* -ls && \
find $HOME/.orlibs/pypip/ -type f -name libxprl\* -ls && \
find $HOME/.orlibs/pypip/ -type f -name \*xpauth.xpr -ls
# FIX: python=3.12

SYSEXT=so
if [[ $(uname -s) == "Darwin" ]]; then \
    SYSEXT=dylib
else true; fi

mkdir -p $HOME/.orlibs && \
ln -sf $HOME/.orlibs  $HOME/.orlibs/lib && \
ln -sf $HOME/.orlibs  $HOME/.orlibs/bin && \
if [[ $(uname -m) == "x86_64" ]]; then \
    find $HOME/.orlibs/pypip/  -type f -name libcplex\* -ls -exec cp {} $HOME/.orlibs/ \; ; \
else true; fi && \
find $HOME/.orlibs/pypip/ -type f -name libgurobi\*     -ls -exec cp {} $HOME/.orlibs/ \; && \
find $HOME/.orlibs/pyxpr/ -type f -name libxprs.\*      -ls -exec cp {} $HOME/.orlibs/libxprs.$SYSEXT \; && \
find $HOME/.orlibs/pyxpr/ -type f -name libxprl\*       -ls -exec cp {} $HOME/.orlibs/libxprl.$SYSEXT \; && \
find $HOME/.orlibs/pyxpr/ -type f -name libxprl\*       -ls -exec cp {} $HOME/.orlibs/libxprl.$SYSEXT.x9.4 \; && \
find $HOME/.orlibs/pyxpr/ -type f -name \*xpauth.xpr    -ls -exec cp {} $HOME/.orlibs/ \; && \
if [[ $(uname -m) == "x86_64" ]]; then \
    conda remove --quiet --yes --prefix $HOME/.orlibs/pycpx --all
else true; fi && \
conda remove --quiet --yes --prefix $HOME/.orlibs/pygrb --all && \
conda remove --quiet --yes --prefix $HOME/.orlibs/pyxpr --all && \
conda remove --quiet --yes --prefix $HOME/.orlibs/pypip --all && \
conda clean --all --yes && \
rm -r $HOME/.orlibs/pkgsx/ && \
find $HOME/.orlibs/

julia --eval "using InteractiveUtils; versioninfo(); @ccall jl_dump_host_cpu()::Cvoid" && \
julia --threads auto --eval "import Pkg; Pkg.add(\"MathOptInterface\")"

if [[ $(uname -m) == "x86_64" ]]; then \
    CPLEX_STUDIO_BINARIES=$HOME/.orlibs/ julia --eval "import Pkg; Pkg.add(\"CPLEX\"); Pkg.build(\"CPLEX\")"
else true; fi && \
GUROBI_HOME=$HOME/.orlibs/ GUROBI_JL_USE_GUROBI_JLL="false" julia --eval "import Pkg; Pkg.add(\"Gurobi\"); Pkg.build(\"Gurobi\")" && \
XPRESSDIR=$HOME/.orlibs/ julia --eval "import Pkg; Pkg.add(\"Xpress\"); Pkg.build(\"Xpress\")"

# cat /run/secrets/GUROBIWLS | tee $HOME/gurobi.lic
if [[ $(uname -m) == "x86_64" ]]; then \
    julia --eval "import CPLEX; CPLEX.Optimizer(); @show CPLEX.libcplex; @show CPLEX._get_version_number()"
else true; fi && \
julia --eval "import Gurobi; Gurobi.Optimizer(); @show Gurobi.libgurobi; @show Gurobi.GRB_VERSION_MAJOR, Gurobi.GRB_VERSION_MINOR, Gurobi.GRB_VERSION_TECHNICAL" && \
XPAUTH_PATH=$HOME/.orlibs/community-xpauth.xpr julia --eval "import Xpress; Xpress.Optimizer(); @show Xpress.libxprs; @show Xpress.getversion()"

exit 0

if [[ $(uname -m) == "x86_64" ]]; then \
    julia --eval "import Pkg; Pkg.test(\"CPLEX\")"
else true; fi && \
julia --eval "import Pkg; Pkg.test(\"Gurobi\")" && \
XPAUTH_PATH=$HOME/.orlibs/community-xpauth.xpr julia --eval "import Pkg; Pkg.test(\"Xpress\")"

exit 0
