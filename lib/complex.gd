# The commented declarations are now in file complexes.gd 
# {
# DeclareCategory( "IsChainOrCochainComplex", IsCapCategoryObject );
# DeclareCategory( "IsChainComplex", IsChainOrCochainComplex );
# DeclareCategory( "IsCochainComplex", IsChainOrCochainComplex );
# DeclareCategory( "IsChainOrCochainComplexCategory", IsCapCategory );
# DeclareCategory( "IsChainComplexCategory", IsChainOrCochainComplexCategory );
# DeclareCategory( "IsCochainComplexCategory", IsChainOrCochainComplexCategory );
# DeclareAttribute( "UnderlyingCategory", IsChainOrCochainComplexCategory );
# }
DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );

DeclareAttribute( "ComplexCategory", IsCapCategory );
DeclareAttribute( "CocomplexCategory", IsCapCategory );


DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
DeclareOperation( "FiniteComplex", [ IsAbelianCategory, IsDenseList ] );
DeclareOperation( "StalkComplex", [ IsAbelianCategory, IsObject ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCategory ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCategory, IsObject, IsObject ] );
DeclareOperation( "InductiveComplex", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Resolution", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Coresolution", [ IsAbelianCategory, IsObject, IsFunction ] );

DeclareOperation( "Shift", [ IsChainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainComplex, IsInt ] );
DeclareOperation( "YonedaProduct", [ IsChainComplex, IsChainComplex ] );
##c
#DeclareOperation( "GoodTruncationBelow", [ IsChainComplex, IsInt ] );
#DeclareOperation( "GoodTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncation", [ IsChainComplex, IsInt, IsInt ] );
#DeclareOperation( "BrutalTruncationBelow", [ IsChainComplex, IsInt ] );
#DeclareOperation( "BrutalTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "SyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "CosyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "SyzygyCosyzygyTruncation", [ IsChainComplex, IsInt, IsInt ] );
#DeclareOperation( "CutComplexAbove", [ IsChainComplex ] );
#DeclareOperation( "CutComplexBelow", [ IsChainComplex ] );

DeclareAttribute( "CatOfComplex", IsChainComplex );
DeclareOperation( "ObjectOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsChainComplex, IsInt ] );

# The commented declarations are now in file complexes.gd 
# {
# DeclareOperation( "\^", [ IsChainComplex, IsInt ] );
# DeclareOperation( "\[\]", [ IsChainComplex, IsInt ] );
# }

DeclareAttribute( "DifferentialsOfComplex", IsChainComplex );
# This is commented because it cause conflict. 
# Alternative we can use the command: Objects( C );
# DeclareAttribute( "ObjectsOfComplex", IsChainComplex );
DeclareOperation( "CyclesOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsChainComplex, IsInt ] );
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
