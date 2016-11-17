LoadPackage( "LinearAlgebraForCap" );
LoadPackage( "complex" );

Q := HomalgFieldOfRationals( );

matrix_category := MatrixCategory( Q );

complex_category := ComplexCategory( matrix_category );

A := VectorSpaceObject( 1, Q );

B := VectorSpaceObject( 2, Q );

f := VectorSpaceMorphism( A, HomalgMatrix( [ [ 1, 3 ] ], 1, 2, Q ), B );

g := VectorSpaceMorphism( B, HomalgMatrix( [ [ 0 ], [ 0 ] ], 2, 1, Q ), A );

# Now I want to define the complex 
#  obj index:        -1         0            1             2           3           4         etc. 
#  mor index:             -1           0             1          2            3            4          etc.  
#                          f           g             f          g
#            ------> A -------> B ---------> A ----------> B --------> A --------->

neg_integers := ArithmeticSequenceN( -1, -1 );
#! 8[ -1, -2, -3, ... ]
pos_integers := ArithmeticSequenceN( 0, 1 );
#! 8[ 0, 1, 2, ... ]
D := function( i ) 
  if i mod 2 = 0 then    
    return g;
  else 
    return f;
  fi;
end;;
neg_diffs := Map( neg_integers, D );
#! 8[ f( -1, -2, -3, ... ) ]
pos_diffs := Map( pos_integers, D );
#! 8[ f( 0, 1, 2, ... ) ]
diffs := Concatenate( neg_diffs, pos_diffs );
#! 8[ f( ..., -3:-3, -2:-2, -1:-1 ), f( 0:0, 1:1, 2:2, ... ) ]
P := ComplexByDifferentialList( matrix_category, diffs );
#! <An object in Chain complexes over Category of matrices over Q>
Obj := ObjectsOfComplex( P );
#! 8[ f( f( ..., -3:-3, -2:-2, -1:-1 ) ), f( f( 0:0, 1:1, 2:2, ... ) ) ]

