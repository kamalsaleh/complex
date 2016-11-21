#n
DeclareCategory( "IsChainOrCochainMap", IsCapCategoryMorphism );
##

#c
DeclareCategory( "IsChainMap", IsChainOrCochainMap );
##

DeclareCategoryFamily( "IsChainMap" );

#n
DeclareCategory( "IsCochainMap", IsChainOrCochainMap );
DeclareCategoryFamily( "IsCochainMap" );
##

# DeclareRepresentation( "IsChainMapDefaultRep",
#                        IsComponentObjectRep and IsAttributeStoringRep,
#                        [] );

DeclareAttribute( "Source", IsChainMap );
DeclareAttribute( "Range", IsChainMap );
DeclareAttribute( "MorphismsOfChainMap", IsChainMap );
#n
DeclareAttribute( "MorphismsOfCochainMap", IsCochainMap );
DeclareAttribute( "MorphismsOfMap", IsChainOrCochainMap );
##


#n
DeclareOperation( "MorphismOfMap", [ IsChainOrCochainMap, IsInt ] );
##

DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );

#n
DeclareOperation( "MorphismOfCochainMap", [ IsCochainMap, IsInt ] );
##
DeclareOperation( "\^", [ IsChainMap, IsInt ] );
DeclareOperation( "\[\]", [ IsChainOrCochainMap, IsInt ] );

DeclareOperation( "HighestKnownDegree", [ IsChainMap ] );
DeclareOperation( "LowestKnownDegree", [ IsChainMap ] );

#DeclareOperation( "ChainMap", [ IsComplex, IsComplex, IsInt, IsList, IsObject, IsObject ] );

DeclareOperation( "ChainMapByMorphismList",
                  [ IsChainComplex, IsChainComplex, IsZList ] );
#n
DeclareOperation( "CochainMapByMorphismList",
                  [ IsCochainComplex, IsCochainComplex, IsZList ] );
##

DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ] );

DeclareOperation( "ZeroMap", 
                  [ IsChainOrCochainComplex, IsChainOrCochainComplex ] );
DeclareOperation( "ZeroChainMap",
                  [ IsChainComplex, IsChainComplex ] );
DeclareOperation( "ZeroCochainMap", 
                  [ IsCochainComplex, IsCochainComplex ] );
