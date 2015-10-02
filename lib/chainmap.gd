DeclareCategory( "IsChainMap", IsCapCategoryMorphism );
DeclareCategoryFamily( "IsChainMap" );

# DeclareRepresentation( "IsChainMapDefaultRep",
#                        IsComponentObjectRep and IsAttributeStoringRep,
#                        [] );

DeclareAttribute( "Source", IsChainMap );
DeclareAttribute( "Range", IsChainMap );
DeclareAttribute( "MorphismsOfChainMap", IsChainMap );
DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );
DeclareOperation( "\^", [ IsChainMap, IsInt ] );
DeclareOperation( "\[\]", [ IsChainMap, IsInt ] );

DeclareOperation( "HighestKnownDegree", [ IsChainMap ] );
DeclareOperation( "LowestKnownDegree", [ IsChainMap ] );

#DeclareOperation( "ChainMap", [ IsComplex, IsComplex, IsInt, IsList, IsObject, IsObject ] );

DeclareOperation( "ChainMapByMorphismList",
                  [ IsChainComplex, IsChainComplex, IsZList ] );
DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ] );
DeclareOperation( "ZeroChainMap",
                  [ IsChainComplex, IsChainComplex ] );
