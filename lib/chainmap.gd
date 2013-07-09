DeclareCategory( "IsChainMap", IsObject );
DeclareCategoryFamily( "IsChainMap" );

DeclareRepresentation( "IsChainMapDefaultRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [] );

DeclareAttribute( "Source", IsChainMap );
DeclareAttribute( "Range", IsChainMap );
DeclareAttribute( "MorphismsOfChainMap", IsChainMap );
DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );
DeclareOperation( "\^", [ IsChainMap, IsInt ] );

DeclareOperation( "HighestKnownDegree", [ IsChainMap ] );
DeclareOperation( "LowestKnownDegree", [ IsChainMap ] );

DeclareGlobalFunction( "ChainMap" );
DeclareGlobalFunction( "FiniteChainMap" );
DeclareGlobalFunction( "ZeroChainMap" );

DeclareGlobalFunction( "ComplexAndChainMaps" );

# ComplexAndChainMaps( sourceComplexes, rangeComplexes,
#                      basePosition, middle, positive, negative );

# ComplexAndChainMaps( [ C ], [], 0, [ [ g, f ] ], [ "pos", func ], "zero" );
