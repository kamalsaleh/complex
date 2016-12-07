LoadPackage( "ModulePresentationsForCap" );;
LoadPackage( "complex" );;

#! @Chunk cochain_creation
#! @Example
S := HomalgFieldOfRationalsInSingular()*"x,y,z";;
left_pre_cat := LeftPresentations( S );
#! Category of left presentations of Q[x,y,z]
cochain_cat := CochainComplexCategory ( left_pre_cat );
#! Cochain complexes category over Category of left presentations of Q[x,y,z]
m := HomalgMatrix( "[ [ x,y ], [ y, z ], [ 0, x ] ]", 3, 2, S );
#! <A 3 x 2 matrix over an external ring>
n := HomalgMatrix( "[ [ x, y, z ], [ 0, x, 1 ] ]", 2, 3, S );    
#! <A 2 x 3 matrix over an external ring>
M := AsLeftPresentation( m );
#! <An object in Category of left presentations of Q[x,y,z]>
N := AsLeftPresentation( n );
#! <An object in Category of left presentations of Q[x,y,z]>
f := PresentationMorphism( M, 
HomalgMatrix( "[ [ x, y, z ], [ 0, 0, 0 ] ]", 2, 3, S ), N );
#! <A morphism in Category of left presentations of Q[x,y,z]>
g := CokernelProjection( f );
#! <An epimorphism in Category of left presentations of Q[x,y,z]>
T := CokernelObject( f );
#! <An object in Category of left presentations of Q[x,y,z]>
h := ZeroMorphism( T, M );
#! <A zero morphism in Category of left presentations of Q[x,y,z]>
#! @EndExample
#! Let us define the cochain complex 
#! @BeginLatexOnly
#! \begin{center}
#! \begin{tikzpicture}
#!   \matrix (m) [matrix of math nodes,row sep=1em,column sep=3em,minimum width=2em]
#!   {
#!       & -1 & 0 & 1 & 2 & 3 & 4 \\
#!     C_1:\cdots  & M & N & T & M & N & T & \cdots \\};
#!   \path[-stealth]
#!     (m-2-1) edge node[above] {$h$} (m-2-2)        
#!     (m-2-2) edge node[above] {$f$} (m-2-3)
#!     (m-2-3) edge node[above] {$g$} (m-2-4)
#!     (m-2-4) edge node[above] {$h$} (m-2-5)
#!     (m-2-5) edge node[above] {$f$} (m-2-6)
#!     (m-2-6) edge node[above] {$g$} (m-2-7)
#!     (m-2-7) edge node[above] {$h$} (m-2-8);
#!     
#! \end{tikzpicture}
#! \end{center}
#! @EndLatexOnly

#! @Example
l := RepeatListZ( [ g, h, f ] );;
C1 := CochainComplexByDifferentialList( left_pre_cat, l );
#! <An object in Cochain complexes category over Category of left presentations 
#! of Q[x,y,z]>
Display( C1^0 );
#! 1,0,0,
#! 0,1,0,
#! 0,0,1 
#! 
#! An epimorphism in Category of left presentations of Q[x,y,z]
Display( C1^-1 );
#! x,y,z,
#! 0,0,0 
#!
#! A morphism in Category of left presentations of Q[x,y,z]
Display( C1[ 3 ] );
#! x,y,z,
#! 0,x,1 
#!
#! An object in Category of left presentations of Q[x,y,z]
objs := Objects( C1 );          
#! <An infinit list>
diffs := Differentials( C1 );
#! <An infinit list>
diffs[ 100 ] = C1^100;
#! true
#! @EndExample
#! @EndChunk

#! @Chunk 2
#! Let us constructe the finite cochain map 
#! @BeginLatexOnly
#! \begin{center}
#! \begin{tikzpicture}
#!   \matrix (m) [matrix of math nodes,row sep=1em,column sep=3em,minimum width=2em]
#!   {
#!        \cdots\;13   & 14 & 15 & 16 & 17 & 18 & 19 & \cdots\\
#!     C_2:0  & N  & T  & M  & N  & T  & 0  & 0 \\};
#!   \path[-stealth]
#!     (m-2-1) edge (m-2-2)
#!     (m-2-2) edge node[above] {$g$} (m-2-3)
#!     (m-2-3) edge node[above] {$h$} (m-2-4)
#!     (m-2-4) edge node[above] {$f$} (m-2-5)
#!     (m-2-5) edge node[above] {$g$} (m-2-6)
#!     (m-2-6) edge  (m-2-7)
#!     (m-2-7) edge  (m-2-8);
#!     
#! \end{tikzpicture}
#! \end{center}
#! @EndLatexOnly
#! @Example
C2 := FiniteCochainComplex( [ g, h, f, g ], 14 );
#! <A bounded object in Cochain complexes category over Category of left 
#! presentations of Q[x,y,z]>
C2[ 29 ];
#! <A zero object in Category of left presentations of Q[x,y,z]>
C2[ -100 ];
#! <A zero object in Category of left presentations of Q[x,y,z]>
ActiveUpperBound( C2 );
#! 19
ActiveLowerBound( C2 );
#! 13
#! @EndExample
#! @EndChunk

#! @Chunk 3
#!@Example
chain_N := StalkChainComplex( N );
#! <A bounded object in Chain complexes category over Category of left 
#! presentations of Q[x,y,z]>
chain_N^0;
#! <A zero, split epimorphism in Category of left presentations of Q[x,y,z]>
Source( chain_N^0 ) = N;
#! true
Range( chain_N^1 ) = N;
#! true
cochain_N := StalkCochainComplex( N );
#! <A bounded object in Cochain complexes category over Category of left 
#! presentations of Q[x,y,z]>
Source( cochain_N^0 ) = N;
#! true
Range( cochain_N^-1 ) = N;
#! true
ActiveLowerBound( cochain_N );
#! -1
ActiveUpperBound( cochain_N );
#! 1
#! @EndExample
#! @EndChunk

#! @Chunk 4
#! To illustrate this let us constructe the free (projective) resolution of M as a chain complex. 
#! @Example
d0 := UniversalMorphismIntoZeroObject( M );
#! <A zero, split epimorphism in Category of left presentations of Q[x,y,z]> 
inductive_function := function( mor ) local ker_embedding, cover;ker_embedding := KernelEmbedding( mor );cover := CoverByFreeModule( Source( ker_embedding ) );return PreCompose( cover, ker_embedding );end;;
proj_M := ChainComplexWithInductivePositiveSide( d0, inductive_function );
#! <A bounded from bellow object in Chain complexes category over Category of left 
#! presentations of Q[x,y,z]>
Display( proj_M, 0, 4 );
#! -----------------------------------------------------------------
#! In index 0
#! 
#! Object[ 0 ] is
#! x,y,
#! y,z,
#! 0,x 
#! 
#! An object in Category of left presentations of Q[x,y,z]
#! 
#! Differential[ 0 ] is
#! (an empty 2 x 0 matrix)
#! 
#! A zero, split epimorphism in Category of left presentations of Q[x,y,z]
#! -----------------------------------------------------------------
#! In index 1
#! 
#! Object[ 1 ] is
#! (an empty 0 x 2 matrix)
#! 
#! An object in Category of left presentations of Q[x,y,z]
#! 
#! Differential[ 1 ] is
#! 1,0,
#! 0,1 
#! 
#! A morphism in Category of left presentations of Q[x,y,z]
#! -----------------------------------------------------------------
#! In index 2
#! 
#! Object[ 2 ] is
#! (an empty 0 x 3 matrix)
#! 
#! An object in Category of left presentations of Q[x,y,z]
#! 
#! Differential[ 2 ] is
#! x,y,
#! y,z,
#! 0,x 
#! 
#! A morphism in Category of left presentations of Q[x,y,z]
#! -----------------------------------------------------------------
#! In index 3
#! 
#! Object[ 3 ] is
#! (an empty 0 x 1 matrix)
#! 
#! An object in Category of left presentations of Q[x,y,z]
#! 
#! Differential[ 3 ] is
#! -x*y,x^2,y^2-x*z
#! 
#! A morphism in Category of left presentations of Q[x,y,z]
#! -----------------------------------------------------------------
#! In index 4
#! 
#! Object[ 4 ] is
#! (an empty 0 x 0 matrix)
#! 
#! An object in Category of left presentations of Q[x,y,z]
#! 
#! Differential[ 4 ] is
#! (an empty 0 x 1 matrix)
#! 
#! A morphism in Category of left presentations of Q[x,y,z]
#! @EndExample
#! @EndChunk

#! @Chunk 33
#!@Example
Coh0 := CohomologyAsFunctor( left_pre_cat, 0 );
#! 0-th cohomology functor in Category of left presentations of Q[x,y,z]
Coh1 := CohomologyAsFunctor( left_pre_cat, 1 );
#! 1-th cohomology functor in Category of left presentations of Q[x,y,z]
Coh2 := CohomologyAsFunctor( left_pre_cat, 2 );
#! 2-th cohomology functor in Category of left presentations of Q[x,y,z]
Coh3 := CohomologyAsFunctor( left_pre_cat, 3 );
#! 3-th cohomology functor in Category of left presentations of Q[x,y,z]
Display( ApplyFunctor( Coh0, C1 ) );
#! 1,0,0,0,
#! 0,1,0,0,
#! 0,0,1,0,
#! 0,0,0,1,
#! 1,0,0,0,
#! 0,1,0,0,
#! 0,0,1,0,
#! 0,0,0,1 
#! 
#! An object in Category of left presentations of Q[x,y,z]
Display( ApplyFunctor( Coh1, C1 ) );
#! 1,0,0,
#! 0,1,0,
#! 0,0,1,
#! x,y,z,
#! 0,0,0,
#! x,y,z,
#! 0,x,1,
#! x,y,z,
#! 0,0,0,
#! x,y,z,
#! 0,x,1 
#! 
#! An object in Category of left presentations of Q[x,y,z]
Display( ApplyFunctor( Coh2, C1 ) );
#! 0,0, 
#! 0,0, 
#! 0,0, 
#! 0,0, 
#! 0,0, 
#! 0,0, 
#! y,z, 
#! x,y, 
#! 0,x, 
#! 0,y^2
#! 
#! An object in Category of left presentations of Q[x,y,z]
Display( ApplyFunctor( Coh3, C1 ) );
#! 1,0,0,0,
#! 0,1,0,0,
#! 0,0,1,0,
#! 0,0,0,1,
#! 1,0,0,0,
#! 0,1,0,0,
#! 0,0,1,0,
#! 0,0,0,1 
#! 
#! An object in Category of left presentations of Q[x,y,z]
shift_to_left := ShiftAsFunctor( cochain_cat, 1 );
#! Shift (1 times to the left) functor in Cochain complexes category over Category 
#! of left presentations of Q[x,y,z]
C2 := ApplyFunctor( shift_to_left, C1 );
#! <An object in Cochain complexes category over Category of left presentations 
#! of Q[x,y,z]>
map := CochainMapByMorphismList( C1, C2, l );
#! <A morphism in Cochain complexes category over Category of left presentations 
#! of Q[x,y,z]>
l = MorphismsOfMap( map );
#! true
f = MorphismOfMap( map, 101 );
#! true
Display( ApplyFunctor( Coh0, map ) );
#! x,y,z,
#! 0,0,0,
#! x,y,z,
#! 0,x,1 
#! 
#! A morphism in Category of left presentations of Q[x,y,z]

cochain_to_chain := CochainToChainComplexAsFunctor( left_pre_cat );
#! Cochain to chain complex functor over Category of left presentations of Q[x,y,z]
B1 := ApplyFunctor( cochain_to_chain, C1 );
#! <An object in Chain complexes category over Category of left presentations 
#! of Q[x,y,z]>
H_minus_3 := HomologyAsFunctor( left_pre_cat, -3 );
#! -3-th homology functor in Category of left presentations of Q[x,y,z]
ApplyFunctor( H_minus_3, B1 ) = ApplyFunctor( Coh3, C1 );
#! true
#! @EndExample

#! Let us constructe the finite cochain map:

#! @BeginCode X1
#! Obj index:  14       15      16      17      18       19
#!                 g       h       f       g                 ...
#! C3:   ----> N -----> T ----> M ----> N ----> T ----> etc  ...
#!                      |       |       |
#!                      | h     |id_M   | id_N
#!                      V       V       V
#! C4:   ----> 0 -----> M ----> M ----> N ----> 0 ----> etc  ...
#!                        id_M     f
#! @EndCode
#! @InsertCode X1

#! @Example
id_M := IdentityMorphism( M );
#! <An identity morphism in Category of left presentations of Q[x,y,z]>
id_N := IdentityMorphism( N );
#! <An identity morphism in Category of left presentations of Q[x,y,z]>
cochain_map := FiniteCochainMap( [ g, h, f, g ], 14, [ id_M, f ], 15, 
                                                    [ h, id_M, id_N ], 15 );
#! <A bounded morphism in Cochain complexes category over Category of left 
#! presentations of Q[x,y,z]>

cochain_map[ 15 ] = h;
#! true
cochain_map[ 16 ] = id_M;
#! true
cochain_map[ 17 ] = id_N;
#! true
Source( cochain_map[ 18 ] ) = T;
#! true
IsQuasiIsomorphismMap( cochain_map );
#! false
#! @EndExample

#! Let us constructe the finite chain map:
#! @BeginCode X2
#! Obj index:  2       3       4       5       6        7            ...
#!
#!                        zero    id_N     f        h      zero      ...
#! C5:  <----- 0 <---- N <---- N <---- N <---- M <----- T <---- etc  ...
#!                                     |       |
#!                                id_N |       | id_M
#!                                     V       V
#! C6:  <----- 0 <---- 0 <---- 0 <---- N <---- M <----- 0 <---- etc  ...
#!                                         f
#! @EndCode
#! @InsertCode X2

#! @Example
chain_map := FiniteChainMap( [ 0*id_N, id_N, f, h ], 4, [ f ], 6, 
                                                  [ id_N, id_M ], 5 );
#! <A bounded morphism in Chain complexes category over Category of left 
#! presentations of Q[x,y,z]>
chain_map!.LowerBound;
#! 5
chain_map!.UpperBound;
#! 6
IsQuasiIsomorphismMap( chain_map );
#! false
#! @EndExample
#! @EndChunk
