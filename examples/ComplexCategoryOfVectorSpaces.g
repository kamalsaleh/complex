LoadPackage( "LinearAlgebraForCap" );
LoadPackage( "complex" );

Q := HomalgFieldOfRationals( );;
matrix_category := MatrixCategory( Q );;
complex_category := ChainComplexCategory( matrix_category );;
A := VectorSpaceObject( 1, Q );;
B := VectorSpaceObject( 2, Q );;
f := VectorSpaceMorphism( A, HomalgMatrix( [ [ 1, 3 ] ], 1, 2, Q ), B );;
g := VectorSpaceMorphism( B, HomalgMatrix( [ [ 0 ], [ 0 ] ], 2, 1, Q ), A );;

#  Now I want to define the chain complex
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
Display( Obj[ 1 ] );
Obj[ 1 ] = ObjectOfComplex( P, 1 );
#! true
Id_P := IdentityMorphism( P );
#! <An identity morphism in Chain complexes category over Category of matrices over Q>
H1 := HomologyAsFunctor( matrix_category, 1 );
#! 1-th homology functor in Category of matrices over Q
H2 := HomologyAsFunctor( matrix_category, 2 );
#! 2-th homology functor in Category of matrices over Q
H1_P := ApplyFunctor( H1, P );
#! <A vector space object over Q of dimension 1>
H1_Id_P := ApplyFunctor( H1, Id_P );
#! <A morphism in Category of matrices over Q>
Display( H1_Id_P );
#! [ [  1 ] ]
#! 
#! A morphism in Category of matrices over Q
H2_P := ApplyFunctor( H2, P );
#! <A vector space object over Q of dimension 0>
H2_Id_P := ApplyFunctor( H2, Id_P );
#! <A morphism in Category of matrices over Q>
Display( H2_Id_P );
#! (an empty 0 x 0 matrix)
#! 
#! A morphism in Category of matrices over Q
