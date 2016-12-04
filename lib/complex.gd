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

#n
DeclareAttribute( "ChainComplexCategory", IsCapCategory );
DeclareAttribute( "CochainComplexCategory", IsCapCategory );
##

DeclareAttribute( "UnderlyingCategory", IsChainOrCochainComplexCategory );

# DeclareAttribute( "ComplexCategory", IsCapCategory );
# DeclareAttribute( "CocomplexCategory", IsCapCategory );

#########################################
#
#   Functors
#
########################################

#n
DeclareOperation( "HomologyAsFunctor", [ IsCapCategory, IsInt ] );
DeclareOperation( "CohomologyAsFunctor", [ IsCapCategory, IsInt ] );
DeclareOperation( "ShiftAsFunctor", [ IsCapCategory, IsInt ] );
DeclareOperation( "UnsignedShiftAsFunctor", [ IsCapCategory, IsInt ] );
DeclareOperation( "ChainToCochainComplexAsFunctor", [ IsCapCategory ] );
DeclareOperation( "CochainToChainComplexAsFunctor", [ IsCapCategory ] );
##

#########################################
#
#  Constructors of (Co)chain complexes 
#
#########################################

#n
DeclareOperation( "ChainComplexByDifferentialList", [ IsCapCategory, IsZList, IsBool ] );
DeclareOperation( "ChainComplexByDifferentialList", [ IsCapCategory, IsZList ] );

DeclareOperation( "CochainComplexByDifferentialList", [ IsCapCategory, IsZList, IsBool ] );
DeclareOperation( "CochainComplexByDifferentialList", [ IsCapCategory, IsZList ] );

DeclareOperation( "FiniteChainComplex", [ IsDenseList ] );
DeclareOperation( "FiniteChainComplex", [ IsDenseList, IsInt ] );

DeclareOperation( "FiniteCochainComplex", [ IsDenseList ] );
DeclareOperation( "FiniteCochainComplex", [ IsDenseList, IsInt ] );

DeclareOperation( "StalkChainComplex", [ IsCapCategoryObject ] );
DeclareOperation( "StalkCochainComplex", [ IsCapCategoryObject ] );

DeclareOperation( "ChainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );
DeclareOperation( "CochainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );
DeclareOperation( "ChainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "ChainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "CochainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "CochainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );
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
#c
DeclareOperation( "Shift", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainOrCochainComplex, IsInt ] );
##

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
DeclareAttribute( "Differentials", IsChainOrCochainComplex );

##
#c
# This is supposed to be called ObjectsOfComplex, but it
# causes a conflict with an operation in homalg
DeclareAttribute( "Objects", IsChainOrCochainComplex );
# DeclareAttribute( "ObjectsOfComplex", IsChainOrCochainComplex );
##

#n
DeclareAttribute( "ObjectsOfChainComplex", IsChainComplex );
DeclareAttribute( "ObjectsOfCochainComplex", IsCochainComplex );
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
DeclareOperation( "DefectOfExactness", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "IsExactInIndex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex, IsPosInt ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex, IsPosInt ] );
DeclareOperation( "SetUpperBound", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "SetLowerBound", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "Display", [ IsChainOrCochainComplex, IsInt, IsInt ] );
##

DeclareOperation( "HomologyOfComplex", [ IsChainComplex, IsInt ] );

#c
DeclareOperation( "UpperBound", [ IsChainComplex ] );
# DeclareOperation( "LowerBound", [ IsChainComplex ] );
##
#DeclareOperation( "IsFiniteComplex", [ IsChainComplex ] );
DeclareOperation( "IsBoundedComplex", [ IsChainComplex ] );
DeclareOperation( "LengthOfComplex", [ IsChainComplex ] );
DeclareOperation( "HighestKnownDegree", [ IsChainComplex ] );
DeclareOperation( "LowestKnownDegree", [ IsChainComplex ] );
DeclareProperty( "IsExactSequence", IsChainComplex );
DeclareOperation( "IsExactInDegree", [ IsChainComplex, IsInt ] );
DeclareProperty( "IsShortExactSequence", IsChainComplex );
DeclareOperation( "ForEveryDegree", [ IsChainComplex, IsFunction ] );
