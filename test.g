LoadPackage( "QPA", "=1.22" );
Q := Quiver( 3, [ [ 1, 2, "a" ], [ 2, 3, "b" ] ] );
kQ := PathAlgebra( Rationals, Q );
M := RightModuleOverPathAlgebra( kQ, [ 1, 0, 0 ], [] );
P := ProjectiveResolution( M );
