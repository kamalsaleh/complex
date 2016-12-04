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
DeclareAttribute( "MappingCone", IsChainOrCochainMap );
##

#n
DeclareOperation( "MorphismOfMap", [ IsChainOrCochainMap, IsInt ] );
##

DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );

#n
DeclareOperation( "MorphismOfCochainMap", [ IsCochainMap, IsInt ] );
DeclareOperation( "\^", [ IsChainMap, IsInt ] );
DeclareOperation( "\[\]", [ IsChainOrCochainMap, IsInt ] );
DeclareOperation( "Display", [ IsChainOrCochainMap, IsInt, IsInt ] );
##

DeclareOperation( "HighestKnownDegree", [ IsChainMap ] );
DeclareOperation( "LowestKnownDegree", [ IsChainMap ] );

#DeclareOperation( "ChainMap", [ IsComplex, IsComplex, IsInt, IsList, IsObject, IsObject ] );

################################
#
# Constructors of co-chain maps 
#
################################

DeclareOperation( "ChainMapByMorphismList",
                  [ IsChainComplex, IsChainComplex, IsZList ] );
#n
DeclareOperation( "CochainMapByMorphismList",
                  [ IsCochainComplex, IsCochainComplex, IsZList ] );
##

#n
DeclareOperation( "FiniteChainMap",
                  [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );
DeclareOperation( "FiniteChainMap",
                  [ IsDenseList, IsDenseList, IsDenseList ] );
DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsDenseList, IsInt ] );
DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsDenseList ] );

DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsInt, IsDenseList ] );
DeclareOperation( "FiniteCochainMap",
                  [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );
DeclareOperation( "FiniteCochainMap",
                  [ IsDenseList, IsDenseList, IsDenseList ] );
DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsDenseList, IsInt ] );
DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsDenseList ] );
##

DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ] );

###############################
#
# More Operations
#
###############################

#n
DeclareOperation( "SetUpperBound", [ IsChainOrCochainMap, IsInt ] );

DeclareOperation( "SetLowerBound", [ IsChainOrCochainMap, IsInt ] );

DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainMap ] );

DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainMap ] );

DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainMap ] );

DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainMap ] );
##

DeclareOperation( "ZeroMap", 
                  [ IsChainOrCochainComplex, IsChainOrCochainComplex ] );
DeclareOperation( "ZeroChainMap",
                  [ IsChainComplex, IsChainComplex ] );
DeclareOperation( "ZeroCochainMap", 
                  [ IsCochainComplex, IsCochainComplex ] );
DeclareOperation( "IsQuasiIsomorphismMap", [ IsChainOrCochainMap ] );
##

