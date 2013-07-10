#######################################################################
##
#O  MappingCone( <f> )
##  
##  <f> is a chain map between two complexes A and B.
##  This method returns a list [ C, i, p ] where C is the mapping cone
##  of <f>, i is the (chain map) inclusion of B into the cone and
##  p is the projection from the cone onto A[-1].
##  
InstallMethod( MappingCone,
[ IsChainMap ],
function( f )
    local cat, C, i, A, B, dirsum, dirsum2, diff, middle, positiveFunction, negativeFunction;

    cat := CatOfComplex( C );

    A := DomainOfMorphism( cat, f );
    B := CodomainOfMorphism( cat, f );

#
#  Consider where to "start" the cone complex.
#
    if ( IsInt( LowerBound( A ) ) ) then
        i := LowerBound( A );
    elif ( IsInt( LowerBound( B ) ) ) then
        i := LowerBound( B );
    elif ( IsInt( UpperBound( A ) ) ) then
        i := UpperBound( A );
    elif ( IsInt( UpperBound( B ) ) ) then
        i := UpperBound( B );
    else
        i := 0;
    fi;

#
#  Construct the first differential of the cone, and the first projection/inclusion morphisms
#

    dirsum := DirectSumOfObjects( cat, ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) );
#    dirsum := DirectSumOfModules( [ ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) ] );
    dirsum2 := DirectSumOfObjects( cat, ObjectOfComplex(A,i-2), ObjectOfComplex(B,i-1) );
#    dirsum2 := DirectSumOfModules( [ ObjectOfComplex(A,i-2), ObjectOfComplex(B,i-1) ] );
    diff := MultiplyListsOfMaps( #DirectSumProjections(dirsum),
                                 [ dirsum[3], dirsum[4] ],
                                 [[ -DifferentialOfComplex(A,i-1),
                                    ZeroMorphism(cat, ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                  [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
                                 #DirectSumInclusions(dirsum2) );
 
                                 [ dirsum2[1], dirsum2[2] ] );
    middle := [ [ diff, dirsum[2], dirsum[3] ] ];
#    middle := [ [ diff, DirectSumInclusions(dirsum)[2], DirectSumProjections(dirsum)[1] ] ];

#
#  Positive degrees of the cone, the projection and the inclusion
#
    positiveFunction := function(C,inmap,outmap,i)
        local nextObj, prevObj, nextDiff;
        nextObj := DirectSumOfObjects( cat, ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) );
#        nextObj := DirectSumOfModules( [ ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) ] );
        prevObj := DomainOfMorphism( cat, DifferentialOfComplex(C,i-1) );

        nextDiff :=  MultiplyListsOfMaps( [ nextObj[3], nextObj[4] ],
#                                         DirectSumProjections(nextObj),
                                          [[ -DifferentialOfComplex(A,i-1),
                                             ZeroMorphism(cat, ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                           [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
#  DirectSumInclusion av prevObj??? Må huske denne. TODO
                                          DirectSumInclusions(prevObj) );
        return [ nextDiff, DirectSumInclusions(nextObj)[2], DirectSumProjections(nextObj)[1] ];

    end ;

#
#  Negative degrees of the cone, the projection and the inclusion
#
    negativeFunction := function(C,inmap,outmap,i)
        local nextObj, prevObj, nextDiff;
        nextObj := DirectSumOfModules( [ ObjectOfComplex(A,i-2), ObjectOfComplex(B,i-1) ] );
        prevObj := Range(DifferentialOfComplex(C,i+1));

        nextDiff := MultiplyListsOfMaps( DirectSumProjections(prevObj),
                                         [[ -DifferentialOfComplex(A,i-1),
                                            ZeroMapping(ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                          [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
                                         DirectSumInclusions(nextObj) );
        return [ nextDiff, DirectSumInclusions(prevObj)[2], DirectSumProjections(prevObj)[1] ];
    end ;

#
#  Returns the cone (as a complex) together with the projection and the inclusion
#
    C := ComplexAndChainMaps( [B], [Shift(A,-1)], i, middle,
                              ["pos", positiveFunction, true],
                              ["pos", negativeFunction, true] );
    return C;
end );
