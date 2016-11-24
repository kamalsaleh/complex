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

