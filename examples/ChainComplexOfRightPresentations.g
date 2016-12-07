LoadPackage( "ModulePresentationsForCap" );;
LoadPackage( "complex" );;

#! @Chunk example1
#! @Example
S := KoszulDualRing( HomalgFieldOfRationalsInSingular()*"x,y,z" );;
right_pre_category := RightPresentations( S );
#! Category of right presentations of Q{e0,e1,e2}
chain_category := ChainComplexCategory( right_pre_category );
#! Chain complexes category over Category of right presentations of Q{e0,e1,e2}
m := HomalgMatrix( "[ [ e0, e1, e2 ],[ 0, 0, e0 ] ]", 2, 3, S );
#! <A 2 x 3 matrix over an external ring>
M := AsRightPresentation( m );
#! <An object in Category of right presentations of Q{e0,e1,e2}>
F := FreeRightPresentation( 2, S );
#! <An object in Category of right presentations of Q{e0,e1,e2}>
f_matrix := HomalgMatrix( "[ [ e1, 0 ], [ 0, 1 ] ]",2, 2, S );;
f := PresentationMorphism( F, f_matrix, M );
#! <A morphism in Category of right presentations of Q{e0,e1,e2}>
g := KernelEmbedding( f );
#! <A monomorphism in Category of right presentations of Q{e0,e1,e2}>
K := Source( g );
#! <An object in Category of right presentations of Q{e0,e1,e2}>
h := ZeroMorphism( M, K );
#! <A zero morphism in Category of right presentations of Q{e0,e1,e2}>
l := RepeatListZ( [ h, f, g ] );;
C1 := ChainComplexByDifferentialList( right_pre_category, l );
#! <An object in Chain complexes category over Category of right presentations of 
#! Q{e0,e1,e2}>
shift := ShiftAsFunctor( chain_category, -1 );
#! Shift (1 times to the right) functor in Chain complexes category over Category of 
#! right presentations of Q{e0,e1,e2}
C2 := ApplyFunctor( shift, C1 );
#! <An object in Chain complexes category over Category of right presentations of 
#! Q{e0,e1,e2}>
diffs := Differentials( C1 );;
map := ChainMapByMorphismList( C1, C2, diffs );
#! <A morphism in Chain complexes category over Category of right presentations of 
#! Q{e0,e1,e2}>
cone := MappingCone( map );
#! <An object in Chain complexes category over Category of right presentations of 
#! Q{e0,e1,e2}>
d := PreCompose( cone^3, cone^2 );
#! <A morphism in Category of right presentations of Q{e0,e1,e2}>
# d is supposed to be zero since "cone" is complex, let us find out 
IsZeroForMorphisms( d );
#! true
H0 := HomologyAsFunctor( right_pre_category, 0 );
#! 0-th homology functor in Category of right presentations of Q{e0,e1,e2}
H1 := HomologyAsFunctor( right_pre_category, 1 );
#! 1-th homology functor in Category of right presentations of Q{e0,e1,e2}
H2 := HomologyAsFunctor( right_pre_category, 2 );
#! 2-th homology functor in Category of right presentations of Q{e0,e1,e2}

IsZeroForObjects(ApplyFunctor( H1, cone ) );
#! false
IsZeroForMorphisms( ApplyFunctor( H0, map ) );
#! true
IsZeroForMorphisms( ApplyFunctor( H1, map ) );
#! true
IsZeroForMorphisms( ApplyFunctor( H2, map ) );
#! true
#! @EndExample
#! @EndChunk
