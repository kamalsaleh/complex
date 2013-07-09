# Some examples of complexes and chain maps in the category of abelian groups.

G1 := Group( (1,2) );
G2 := Group( (1,2), (3,4) );
G3 := Group( (3,4) );

f := GroupHomomorphismByImages( G1, G2, [ (1,2) ], [ (1,2) ] );
g := GroupHomomorphismByImages( G2, G3, [ (1,2), (3,4) ], [ One(G3), (3,4) ] );

f_ := GroupHomomorphismByImages( G3, G2, [ (3,4) ], [ (3,4) ] );
g_ := GroupHomomorphismByImages( G2, G1, [ (1,2), (3,4) ], [ (1,2), One(G1) ] );

C1 := FiniteComplex( Ab, 1, [ g, f ] );   # 0 -> G1 --f--> G2 --g--> G3 -> 0
C2 := FiniteComplex( Ab, 1, [ g_, f_ ] ); # 0 -> G3 --f_-> G2 --g_-> G1 -> 0

C3 := YonedaProduct( C1, C2 );

iso_1_3 := Isomorphism( Ab, G1, G3 );
iso_3_1 := Inverse( Ab, iso_1_3 );
flip2 := GroupHomomorphismByImages( G2, G2, [ (1,2), (3,4) ], [ (3,4), (1,2) ] );
map := ChainMap( C1, C2, 0, [ iso_3_1, flip2, iso_1_3 ], "zero", "zero" );
