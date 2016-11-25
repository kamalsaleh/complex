LoadPackage( "ModulePresentationsForCap" );
LoadPackage( "complex" );

S := KoszulDualRing(HomalgFieldOfRationalsInSingular()*"x,y,z" );
right_pre_category := RightPresentations( S );
chain_category := ChainComplexCategory( right_pre_category );
m := HomalgMatrix( "[ [ e0, e1, e2 ],[ 0, 0, e0 ] ]", 2, 3, S );
M := AsRightPresentation( m );
F := FreeRightPresentation( 2, S );
f := PresentationMorphism( F, HomalgMatrix( "[ [ e1, 0 ], [ 0, 1 ] ]",2, 2, S ), M );
g := KernelEmbedding( f );
K := Source( g );
h := ZeroMorphism( M, K );

#  Now I want to define the chain complex
#  obj index:        -1         0            1             2           3           4         etc.
#  mor index:              0           1             2          3            4               etc.
#
#                          h           f             g          h
#            <------ K <------- M <--------- F <---------- K <-------- M <--------

l := RepeatListZ( [ h, f, g ] );
C1 := ChainComplexByDifferentialList( right_pre_category, l );
shift := ShiftAsFunctor( chain_category, -1 );
C2 := ApplyFunctor( shift, C1 );
diffs := Differentials( C1 );
map := ChainMapByMorphismList( C1, C2, diffs );
cone := MappingCone( map );
d := PreCompose( cone^3, cone^2 );
# d is supposed to be zero since "cone" is complex, let us find out 
IsZeroForMorphisms( d );
#true

H0 := HomologyAsFunctor( right_pre_category, 0 );
H1 := HomologyAsFunctor( right_pre_category, 1 );
H2 := HomologyAsFunctor( right_pre_category, 2 );

IsZeroForObjects(ApplyFunctor( H1, cone ) );
#! false
# Hence, "map" is not quasi-isomorphism, because if it were, then the mapping cone would be exact chain which is 
# not true.

# It can easily be shown that "map" is 0-homotopic. This means that the morphisms between homology groups 
# induced by "map" should all be equal to zero.

IsZeroForMorphisms( ApplyFunctor( H0, map ) );
#! true
IsZeroForMorphisms( ApplyFunctor( H1, map ) );
#! true
IsZeroForMorphisms( ApplyFunctor( H2, map ) );
#! true


