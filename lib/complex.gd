DeclareCategory( "IsChainOrCochainComplex", IsCapCategoryObject );
DeclareCategory( "IsChainComplex", IsChainOrCochainComplex );
DeclareCategory( "IsCochainComplex", IsChainOrCochainComplex );
DeclareCategory( "IsChainOrCochainComplexCategory", IsCapCategory );
DeclareCategory( "IsChainComplexCategory", IsChainOrCochainComplexCategory );
DeclareCategory( "IsCochainComplexCategory", IsChainOrCochainComplexCategory );

DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );

###################################################
#
#  Constructors of (Co)chain complexes categories
#
###################################################

DeclareAttribute( "ChainComplexCategory", IsCapCategory );
DeclareAttribute( "CochainComplexCategory", IsCapCategory );

DeclareAttribute( "UnderlyingCategory", IsChainOrCochainComplexCategory );

DeclareAttribute( "ComplexCategory", IsCapCategory );
DeclareAttribute( "CocomplexCategory", IsCapCategory );

#########################################
#
#  Constructors of (Co)chain complexes 
#
#########################################

#n
DeclareOperation( "ChainComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ChainComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );

DeclareOperation( "CochainComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "CochainComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
##

#c
# The following two operations are exactly the same as ChainComplexByDifferentialList.
# I 
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
##


DeclareOperation( "FiniteComplex", [ IsAbelianCategory, IsDenseList ] );
DeclareOperation( "StalkComplex", [ IsAbelianCategory, IsObject ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCategory ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCategory, IsObject, IsObject ] );
DeclareOperation( "InductiveComplex", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Resolution", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Coresolution", [ IsAbelianCategory, IsObject, IsFunction ] );

DeclareOperation( "Shift", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "YonedaProduct", [ IsChainComplex, IsChainComplex ] );

DeclareOperation( "GoodTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "BrutalTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "SyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "CosyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "SyzygyCosyzygyTruncation", [ IsChainComplex, IsInt, IsInt ] );
#DeclareOperation( "CutComplexAbove", [ IsChainComplex ] );
#DeclareOperation( "CutComplexBelow", [ IsChainComplex ] );


##############################################
#
# Attributes of (co)chain complexes
#
##############################################

#c
DeclareAttribute( "DifferentialsOfComplex", IsChainOrCochainComplex );
##
#c
DeclareAttribute( "ObjectsOfComplex", IsChainOrCochainComplex );
##

DeclareAttribute( "CatOfComplex", IsChainOrCochainComplex );

##############################################
#
# operations derived from Attributes
#
##############################################

#c
DeclareOperation( "ObjectOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "\^", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "\[\]", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "CyclesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "HomologyOfChainComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "CohomologyOfCochainComplex", [ IsCochainComplex, IsInt ] );
##

DeclareOperation( "HomologyOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "UpperBound", [ IsChainComplex ] );
DeclareOperation( "LowerBound", [ IsChainComplex ] );
#DeclareOperation( "IsFiniteComplex", [ IsChainComplex ] );
DeclareOperation( "IsBoundedComplex", [ IsChainComplex ] );
DeclareOperation( "LengthOfComplex", [ IsChainComplex ] );
DeclareOperation( "HighestKnownDegree", [ IsChainComplex ] );
DeclareOperation( "LowestKnownDegree", [ IsChainComplex ] );
DeclareProperty( "IsExactSequence", IsChainComplex );
DeclareOperation( "IsExactInDegree", [ IsChainComplex, IsInt ] );
DeclareProperty( "IsShortExactSequence", IsChainComplex );
DeclareOperation( "ForEveryDegree", [ IsChainComplex, IsFunction ] );
