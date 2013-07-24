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
    local cat, C, i, A, B, prevObj, prevObj2, dirsum, dirsum2, 
          diff, middle, positiveFunction, negativeFunction;

    A := Source( f );
    B := Range( f );

    cat := CatOfComplex( A );

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

    prevObj := DirectSumOfObjects( cat, ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) );
    prevObj2 := DirectSumOfObjects( cat, ObjectOfComplex(A,i-2), ObjectOfComplex(B,i-1) );
    diff := MultiplyListsOfMaps( [ prevObj[3], prevObj[4] ],
                                 [[ -DifferentialOfComplex(A,i-1),
                                    ZeroMorphism(cat, ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                  [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
                                 [ prevObj2[1], prevObj2[2] ] );
    middle := [ [ diff, prevObj[2], prevObj[3] ] ];

#
#  Positive degrees of the cone, the projection and the inclusion
#
    positiveFunction := function(C,inmap,outmap,i)
        local nextObj, nextDiff;
        nextObj := DirectSumOfObjects( cat, ObjectOfComplex(A,i-1), ObjectOfComplex(B,i) );

        nextDiff :=  MultiplyListsOfMaps( [ nextObj[3], nextObj[4] ],
                                          [[ -DifferentialOfComplex(A,i-1),
                                             ZeroMorphism(cat, ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                           [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
                                          [ prevObj[1], prevObj[2] ] );
        prevObj := nextObj;
        return [ nextDiff, nextObj[2], nextObj[3] ];

    end ;

#
#  Negative degrees of the cone, the projection and the inclusion
#
    negativeFunction := function(C,inmap,outmap,i)
        local nextObj, nextDiff, prevObjTemp;
        nextObj := DirectSumOfObjects( cat, ObjectOfComplex(A,i-2), ObjectOfComplex(B,i-1) );

        nextDiff := MultiplyListsOfMaps( [ prevObj2[3], prevObj2[4] ],
                                         [[ -DifferentialOfComplex(A,i-1),
                                            ZeroMorphism(cat, ObjectOfComplex(B,i), ObjectOfComplex(A,i-2)) ],
                                          [ -MorphismOfChainMap(f,i-1), DifferentialOfComplex(B,i)]],
                                         [ nextObj[1], nextObj[2] ] );
        prevObjTemp := prevObj2;
        prevObj2 := nextObj;
        return [ nextDiff, prevObjTemp[2], prevObjTemp[3] ];
    end ;

#
#  Returns the cone (as a complex) together with the projection and the inclusion
#
    C := ComplexAndChainMaps( [B], [Shift(A,-1)], i, middle,
                              ["pos", positiveFunction, true],
                              ["pos", negativeFunction, true] );
    return C;
end );
