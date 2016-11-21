LoadPackage( "LinearAlgebraForCap" );
LoadPackage( "complex" );

Q := HomalgFieldOfRationals( );;
matrix_category := MatrixCategory( Q );;
complex_category := ChainComplexCategory( matrix_category );;
A := VectorSpaceObject( 1, Q );;
B := VectorSpaceObject( 2, Q );;
f := VectorSpaceMorphism( A, HomalgMatrix( [ [ 1, 3 ] ], 1, 2, Q ), B );;
g := VectorSpaceMorphism( B, HomalgMatrix( [ [ 0 ], [ 0 ] ], 2, 1, Q ), A );;

# Now I want to define the chain complex
#  obj index:        -1         0            1             2           3           4         etc.
#  mor index:              0           1             2          3            4               etc.
#
#                          f           g             f          g
#            <------ B <------- A <--------- B <---------- A <-------- B <--------

neg_integers := ArithmeticSequenceN( -1, -1 );;
pos_integers := ArithmeticSequenceN( 0, 1 );;

D := function( i )
  if i mod 2 = 0 then
    return f;
  else
    return g;
  fi;
end;;

neg_diffs := Map( neg_integers, D );;
pos_diffs := Map( pos_integers, D );;
diffs := Concatenate( neg_diffs, pos_diffs );;
P := ChainComplexByDifferentialList( matrix_category, diffs );
#! <An object in Chain complexes over Category of matrices over Q>
Obj := ObjectsOfComplex( P );;
