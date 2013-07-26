k := Rationals;

inc12 := LeftModuleHomomorphismByMatrix( CanonicalBasis( k ),
                                         [ [ 1, 0 ] ],
                                         CanonicalBasis( k^2 ) );
proj21 := LeftModuleHomomorphismByMatrix( CanonicalBasis( k^2 ),
                                          [ [ 0 ], [ 1 ] ],
                                          CanonicalBasis( k ) );

C1 := BoundedComplex( Vec( k ), 1, [ proj21, inc12 ] );
