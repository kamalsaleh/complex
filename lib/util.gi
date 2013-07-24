######################################################
##
#O MultiplyListsOfMaps( <projections>, <matrix>, <inclusions> )
##
## <projections> is a list of m maps, <matrix> is a list of
## m lists of n maps, <inclusions> is a list of n maps. 
## Considering <projections> as a 1xm-matrix, <matrix> as an
## mxn-matrix and and <inclusions> as an nx1-matrix, the 
## matrix product is computed. Naturally, the maps in the 
## matrices must be composable.
##
## Output is a map (not a 1x1-matrix).
##
## Utility method not supposed to be here, but there seemed
## to be no existing GAP method for this.
##
InstallMethod( MultiplyListsOfMaps,
                    [ IsList, IsList, IsList ],
                    function( projections, matrix, inclusions )
    local sum, list, n, m, i, j;

    n := Length(projections);
    m := Length(inclusions);
    list := [1..m];
    sum := 0;

    for i in [1..m] do
       list[i] := projections*matrix[i];
    od;

    sum := list*inclusions;
    return sum;
end);
