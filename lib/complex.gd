DeclareCategory( "IsChainComplex", IsObject );

DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );

DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCat, IsZList, IsBool ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCat, IsZList ] );
DeclareOperation( "FiniteComplex", [ IsAbelianCat, IsDenseList ] );
DeclareOperation( "StalkComplex", [ IsAbelianCat, IsObject ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCat ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCat, IsObject, IsObject ] );
DeclareOperation( "InductiveComplex", [ IsAbelianCat, IsObject, IsFunction ] );
DeclareOperation( "Resolution", [ IsAbelianCat, IsObject, IsFunction ] );
DeclareOperation( "Coresolution", [ IsAbelianCat, IsObject, IsFunction ] );

DeclareOperation( "Shift", [ IsChainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainComplex, IsInt ] );
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

DeclareAttribute( "CatOfComplex", IsChainComplex );
DeclareOperation( "ObjectOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "\^", [ IsChainComplex, IsInt ] );
DeclareOperation( "\[\]", [ IsChainComplex, IsInt ] );
DeclareAttribute( "DifferentialsOfComplex", IsChainComplex );
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
