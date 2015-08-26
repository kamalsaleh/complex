gap> START_TEST( "inflist" );

# Making a repeating list
gap> l := RepeatList( [ 3, 5, 7 ] );;
gap> l[ 1 ];
3
gap> l[ 2 ];
5
gap> Sublist( l, 1, 7 ) = [ 3, 5, 7, 3, 5, 7 ];
true
gap> IsRepeating( l );
true
gap> IsEventuallyRepeating( l );
true
gap> RepeatingFromIndex( l );
1
gap> RepeatingPart( l ) = l;
true
gap> RepeatingList( l ) = [ 3, 5, 7 ];
true
gap> li := Implementation( l );;
gap> IsRepeatingNListImp( li );
true
gap> RepeatingList( li ) = [ 3, 5, 7 ];
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
gap> IsInductive( l );
true
gap> IsEventuallyInductive( l );
true
gap> InductiveFromIndex( l );
1
gap> InductivePart( l ) = l;
true
gap> InductionFunction( l ) = f;
true
gap> li := Implementation( l );;
gap> InitialValue( li );
1
gap> InductionFunction( li ) = f;
true
gap> HasBetterImplementation( li );
false

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
gap> IsRepeatingNListImp( Implementation( L ) );
true
gap> RepeatingList( Implementation( L ) ) = [ 3, 1, 2 ];
true
gap> IsRepeating( L );
true
gap> RepeatingList( L ) = [ 3, 1, 2 ];
true
gap> Concat([3,4],[5]);
Error, Last argument must be N-list

# Test that immediate notification of better implementation works.
gap> l1 := InductiveList( 2, x -> x mod 3 + 1 );;
gap> l2 := Cut( l1, 5 );;
gap> l3 := Concat( [ 2, 2, 2 ], l2 );;
gap> l4 := LiftList( 1, l3, function( a, b ) return b - a; end );;
gap> l4i := Implementation( l4 );;
gap> l4[ 7 ];
0
gap> HasBetterImplementation( l4i );
true
gap> IsIdenticalObj( Implementation( l4 ), l4i );
false
gap> l4i := Implementation( l4 );;
gap> IsConcatNListImp( l4i );
true
gap> IsConcatNListImp( l4i ) and IsRepeatingNListImp( BaseList( l4i ) );
true
gap> STOP_TEST( "inflist.tst", 10000 );
