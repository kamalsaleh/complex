gap> START_TEST( "inflist" );

# Making a repeating list
gap> l := RepeatListN( [ 3, 5, 7 ] );;
gap> l[ 1 ];
3
gap> l[ 2 ];
5
gap> Sublist( l, 1, 7 ) = [ 3, 5, 7, 3, 5, 7 ];
true
gap> RepeatingList( l ) = [ 3, 5, 7 ];
true

# Making an inductive list
gap> f := x -> 2 * x;;
gap> l := InductiveList( 1, f );;
gap> l[ 1 ];
1
gap> l[ 2 ];
2
gap> Sublist( l, 1, 7 ) = [ 1, 2, 4, 8, 16, 32 ];
true

# An inductive list which automatically turns into a repeating list
gap> L := InductiveList( 3, x -> x mod 3 + 1 );;
gap> IsInductiveNListImp( Implementation( L ) );
true
gap> L[ 1 ]; L[ 2 ]; L[ 3 ]; L[ 4 ]; L[ 5 ]; L[ 6 ];
3
1
2
3
1
2
gap> L;
8[ ( 3, 1, 2 )* ]
gap> IsRepeatingNList( Implementation( L ) );
true
gap> RepeatingList( Implementation( L ) ) = [ 3, 1, 2 ];
true

# Test that immediate notification of better implementation works.
gap> l1 := InductiveList( 2, x -> x mod 3 + 1 );;
gap> l2 := Cut( l1, 5 );;
gap> l3 := Concatenate( [ 2, 2, 2 ], l2 );;
gap> l4 := LiftList( 1, l3, function( a, b ) return b - a; end );;
gap> l4i := Implementation( l4 );;
gap> l4[ 7 ];
0
gap> HasImplementation( l4i );
true
gap> IsIdenticalObj( Implementation( l4 ), l4i );
false
gap> l4i := Implementation( l4 );;
gap> IsConcatNList( l4i );
true
gap> IsConcatNList( l4i ) and IsRepeatingNList( BaseList( l4i ) );
true

# making a ZList of concat type with two repeating lists
gap> neg := RepeatListN( [ 20, 21, 22 ] );;
gap> pos := RepeatListN( [ 11, 12 ] );;
gap> L := Concatenate( neg, [ 5, 6, 7 ], pos );;
gap> L[ 0 ] = 5;
true
gap> L[ 1 ] = 6;
true
gap> L[ 2 ] = 7;
true
gap> L[ 3 ] = 11;
true
gap> L[ 4 ] = 12;
true
gap> L[ 5 ] = 11;
true
gap> L[ -1 ] = 20;
true
gap> L[ -2 ] = 21;
true
gap> L[ -3 ] = 22;
true
gap> L[ -4 ] = 20;
true
gap> IsConcatZList( L );
true
gap> BasePosition( L ) = 0;
true
gap> PositiveList( L ) = pos;
true
gap> NegativeList( L ) = neg;
true

# shift and map for ConcatZList
gap> L1 := Concatenate( RepeatListN( [ 20, 21, 22 ] ), [ 1, 2 ], RepeatListN( [ 11, 12 ] ) );;
gap> L2 := Shift( L1, 2 );;
gap> L2[ 0 ] = L1[ 2 ];
true
gap> Sublist( L2, -3, 1 ) = [ 20, 1, 2, 11 ];
true
gap> L3 := Map( L2, x -> x + 1 );;
gap> Sublist( L3, -3, 1 ) = [ 21, 2, 3, 12 ];
true

#
gap> STOP_TEST( "inflist.tst", 10000 );
