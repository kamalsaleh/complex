# kroppen
k := Rationals;

vec_k := Vec( k );

# vektorrom
V := k;
W := k^2;
U := k^3;
Y := VectorSpace( Rationals, [ [1,2], [0,1] ]);

# avbildinger

# V --> W
h := LeftModuleHomomorphismByMatrix( Basis(V), [[0,1]], Basis(W) );

# W --> U
j := LeftModuleHomomorphismByMatrix( Basis(W), [[1,0,1],[1,0,0]] , Basis(U) );

# W --> Y
iso := LeftModuleHomomorphismByMatrix( Basis(W), [ [1,0], [0,1] ], Basis(Y));

# U --> W
m := LeftModuleHomomorphismByMatrix( Basis(U), [ [1,2],[0,0],[0,0] ], Basis(W));
ker := Kernel(m);

# V --> U
c := LeftModuleHomomorphismByMatrix(Basis(V), [ [2,0,0 ] ], Basis(U));

# V --> U
f := LeftModuleHomomorphismByMatrix(Basis(V), [ [3,1,0 ] ], Basis(U));
