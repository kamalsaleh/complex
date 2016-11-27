LoadPackage( "ModulePresentationsForCap" );
LoadPackage( "complex" );

S := HomalgFieldOfRationalsInSingular()*"x,y,z";
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
f := PresentationMorphism( M, HomalgMatrix( "[ [ x, y, z ], [ 0, 0, 0 ] ]", 2, 3, S ), N );
#! <A morphism in Category of left presentations of Q[x,y,z]>
g := CokernelProjection( f );
#! <A morphism in Category of left presentations of Q[x,y,z]>
T := CokernelObject( f );
#! <An object in Category of left presentations of Q[x,y,z]>
h := ZeroMorphism( T, M );
#! <A morphism in Category of left presentations of Q[x,y,z]>

#  I want to define the cochain complex 
#  obj index:           -1           0            1            2             3              4                  ...
#-----------------------------------------------------------------------------------------------------------------
#  mor index:                 -1           0            1            2             3              4            ...
#-----------------------------------------------------------------------------------------------------------------
#                              f           g            h            f             g              h            ...
#           C1:   -----> M --------> N ---------> T ---------> M ----------> N -----------> T -----------> etc ...

l := RepeatListZ( [ g, h, f ] );;
C1 := CochainComplexByDifferentialList( left_pre_cat, l );
#! <An object in Cochain complexes category over Category of left presentations of Q[x,y,z]>
Obj := Objects( C1 );;
Diffs := Differentials( C1 );;
Display( C1^0 );
#! 1,0,0,
#! 0,1,0,
#! 0,0,1 
#! 
#! An epimorphism in Category of left presentations of Q[x,y,z]
Display( Diffs[ 0 ] );
#! 1,0,0,
#! 0,1,0,
#! 0,0,1 
#! 
#! An epimorphism in Category of left presentations of Q[x,y,z]
Obj[ 1 ] = T;
#! true
Obj[ 7 ] = T;
#! true
 
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
#! Shift (1 times to the left) functor in Cochain complexes category over Category of left presentations of Q[x,y,z]
C2 := ApplyFunctor( shift_to_left, C1 );
#! <An object in Cochain complexes category over Category of left presentations of Q[x,y,z]>
map := CochainMapByMorphismList( C1, C2, l );
#! <A morphism in Cochain complexes category over Category of left presentations of Q[x,y,z]>

l = MorphismsOfMap( map );
#! true
############################################################
##  We could have used "MorphismsOfCochainMap( map );".
############################################################

f = MorphismOfMap( map, 101 );
#! true
############################################################
##  We could have used "MorphismOfCochainMap( map, 101 );".
############################################################

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
#! <An object in Chain complexes category over Category of left presentations of Q[x,y,z]>
H_minus_3 := HomologyAsFunctor( left_pre_cat, -3 );
#! -3-th homology functor in Category of left presentations of Q[x,y,z]
ApplyFunctor( H_minus_3, B1 ) = ApplyFunctor( Coh3, C1 );
#! true

# Now let us constructe the free (projective) resolution of M.

d0 := UniversalMorphismIntoZeroObject( M );
#! <A morphism in Category of left presentations of Q[x,y,z]>
inductive_function := function( mor )
                      local ker_embedding, cover;
                      ker_embedding := KernelEmbedding( mor );
                      cover := CoverByFreeModule( Source( ker_embedding ) );
                      return PreCompose( cover, ker_embedding );
                      end;;

proj_M := CochainComplexWithInductiveNegativeSide( d0, inductive_function );
#! <An object in Cochain complexes category over Category of left presentations of Q[x,y,z]>


