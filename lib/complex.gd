DeclareCategory( "IsComplex", IsObject );
DeclareCategoryFamily( "IsComplex" );

DeclareCategory( "IsZeroComplex", IsComplex );

DeclareRepresentation( "IsComplexDefaultRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ "differentials" ] );

DeclareAttribute( "CatOfComplex", IsComplex );
DeclareOperation( "ObjectOfComplex", [ IsComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsComplex, IsInt ] );
DeclareOperation( "\^", [ IsComplex, IsInt ] );
DeclareAttribute( "DifferentialsOfComplex", IsComplex );
DeclareOperation( "CyclesOfComplex", [ IsComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsComplex, IsInt ] );
DeclareOperation( "HomologyOfComplex", [ IsComplex, IsInt ] );
DeclareOperation( "UpperBound", [ IsComplex ] );
DeclareOperation( "LowerBound", [ IsComplex ] );
DeclareOperation( "IsFiniteComplex", [ IsComplex ] );
DeclareOperation( "LengthOfComplex", [ IsComplex ] );
DeclareOperation( "HighestKnownDegree", [ IsComplex ] );
DeclareOperation( "LowestKnownDegree", [ IsComplex ] );
DeclareProperty( "IsExactSequence", IsComplex );
DeclareOperation( "IsExactInDegree", [ IsComplex, IsInt ] );
DeclareProperty( "IsShortExactSequence", IsComplex );
DeclareOperation( "ForEveryDegree", [ IsComplex, IsFunction ] );
DeclareOperation( "IsPositiveRepeating", [ IsComplex ] );
DeclareOperation( "IsNegativeRepeating", [ IsComplex ] );
DeclareOperation( "PositiveRepeatDegrees", [ IsComplex ] );
DeclareOperation( "NegativeRepeatDegrees", [ IsComplex ] );

DeclareOperation( "Shift", [ IsComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsComplex, IsInt ] );
DeclareOperation( "YonedaProduct", [ IsComplex, IsComplex ] );

DeclareOperation( "GoodTruncationBelow", [ IsComplex, IsInt ] );
DeclareOperation( "GoodTruncationAbove", [ IsComplex, IsInt ] );
DeclareOperation( "GoodTruncation", [ IsComplex, IsInt, IsInt ] );
DeclareOperation( "BrutalTruncationBelow", [ IsComplex, IsInt ] );
DeclareOperation( "BrutalTruncationAbove", [ IsComplex, IsInt ] );
DeclareOperation( "BrutalTruncation", [ IsComplex, IsInt, IsInt ] );
DeclareOperation( "SyzygyTruncation", [ IsComplex, IsInt ] );
DeclareOperation( "CosyzygyTruncation", [ IsComplex, IsInt ] );
DeclareOperation( "SyzygyCosyzygyTruncation", [ IsComplex, IsInt, IsInt ] );
DeclareOperation( "CutComplexAbove", [ IsComplex ] );
DeclareOperation( "CutComplexBelow", [ IsComplex ] );

DeclareOperation( "Complex", [ IsAbelianCat, IsInt, IsList, IsObject, IsObject ] );
# Complex( cat, basePosition, differentials, [ "repeat", [ f, g, h ] ], "zero" );
# Complex( cat, basePosition, differentials, [ "next", function( d ) ... end ], "zero" );
# Complex( cat, basePosition, differentials, [ "pos", function( C, i ) ... end,  ], "zero" );
# - If positive or negative is "zero", then middle must be nonempty.

DeclareOperation( "FiniteComplex", [ IsAbelianCat, IsInt, IsList ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCat ] );
DeclareOperation( "StalkComplex", [ IsAbelianCat, IsObject, IsInt ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCat, IsObject, IsObject ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCat, IsInfList ] );

DeclareOperation( "ProjectiveResolution", [ IsAlgebraModule ] );
