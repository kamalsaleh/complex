DeclareInfoClass( "InfoInfList" );

DeclareCategory( "IsInfiniteNumber", IsObject );
DeclareGlobalVariable( "PositiveInfinity" );
DeclareGlobalVariable( "NegativeInfinity" );

DeclareCategory( "IsInfList", IsObject );
DeclareCategory( "IsNList", IsInfList );
DeclareCategory( "IsZList", IsInfList );

DeclareCategory( "IsInductiveNList", IsNList );
DeclareCategory( "IsInductiveNListDef", IsInductiveNList );
DeclareCategory( "IsInductiveNListImp", IsInductiveNList );
DeclareCategory( "IsRepeatingInfList", IsInfList );
DeclareSynonym( "IsRepeatingNList", IsRepeatingInfList and IsNList );
DeclareSynonym( "IsRepeatingZList", IsRepeatingInfList and IsZList );
DeclareCategory( "IsArithmeticInfList", IsInfList );
DeclareSynonym( "IsArithmeticNList", IsArithmeticInfList and IsNList );
DeclareSynonym( "IsArithmeticZList", IsArithmeticInfList and IsZList );
DeclareCategory( "IsDerivedNList", IsNList );
DeclareCategory( "IsCutNList", IsDerivedNList );
DeclareCategory( "IsConcatNList", IsDerivedNList );
DeclareCategory( "IsMapNList", IsDerivedNList );
DeclareCategory( "IsLiftingNList", IsDerivedNList );
DeclareCategory( "IsLiftingNListDef", IsLiftingNList );
DeclareCategory( "IsLiftingNListImp", IsLiftingNList );
DeclareCategory( "IsCombinationNList", IsNList );
DeclareCategory( "IsConcatZList", IsZList );

DeclareAttribute( "ItemEqualityFunction", IsInfList );

DeclareOperation( "MakeInfList", [ IsOperation, IsRecord, IsDenseList ] );

DeclareOperation( "AddDerivation", [ IsNList, IsInfList ] );
DeclareOperation( "AddImplementationUser", [ IsInfList, IsInfList ] );

DeclareAttribute( "Implementation", IsInfList );
# notify a (derived/combined/concat) list that a list it depends on
# has got an implementation:
DeclareOperation( "ImplementationNotification", [ IsInfList, IsInfList ] );

DeclareOperation( "\[\]", [ IsNList, IsPosInt ] );

# Now CertainEntry is kind of attribute for any inflist l and integer i.
KeyDependentOperation( "CertainEntry", IsZList, IsInt, ReturnTrue );
DeclareOperation( "\[\]", [ IsZList, IsInt ] );
DeclareOperation( "LookupInfList", [ IsNList, IsPosInt ] );
DeclareOperation( "LookupInfList", [ IsZList, IsInt ] );

DeclareGlobalVariable( "InfListStringDefaultOptionsN" );
DeclareGlobalVariable( "InfListStringDefaultOptionsZ" );
DeclareOperation( "InfListString", [ IsInfList ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfList ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfList, IsBool ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsPosInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsDenseList ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsPosInt, IsDenseList ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfList, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsPosInt, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsDenseList, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNList, IsPosInt, IsDenseList, IsBool, IsDenseList ] );

# TODO: print tree structure of list construction

DeclareOperation( "AddAssertion", [ IsInfList, IsInfListAssertion ] );
DeclareOperation( "CheckSingleAssertions", [ IsInfList, IsInt, IsObject ] );
DeclareOperation( "CheckDoubleAssertions", [ IsInfList, IsInt, IsObject, IsObject ] );

DeclareOperation( "KnownIndices", [ IsInfList ] );

DeclareAttribute( "InitialValue", IsInductiveNList );
DeclareAttribute( "InductionFunction", IsInductiveNList );
DeclareAttribute( "RepeatingList", IsRepeatingInfList );
DeclareAttribute( "InitialValue", IsArithmeticInfList );
DeclareAttribute( "Increment", IsArithmeticInfList );
DeclareAttribute( "BaseList", IsDerivedNList );
DeclareAttribute( "CutIndex", IsCutNList );
DeclareAttribute( "ConcatList", IsConcatNList );
DeclareAttribute( "MapFunction", IsMapNList );
DeclareAttribute( "InitialValue", IsLiftingNList );
DeclareAttribute( "LiftingFunction", IsLiftingNList );
DeclareAttribute( "Lists", IsCombinationNList );
DeclareAttribute( "BasePosition", IsZList );
DeclareAttribute( "PositiveList", IsConcatZList );
DeclareAttribute( "NegativeList", IsConcatZList );
DeclareAttribute( "MiddleList", IsConcatZList );

DeclareOperation( "Repeatify", [ IsInductiveNListImp, IsPosInt, IsPosInt ] );
DeclareOperation( "Repeatify", [ IsLiftingNListImp, IsPosInt, IsPosInt ] );

DeclareOperation( "RepeatListN", [ IsDenseList ] );
DeclareOperation( "RepeatListZ", [ IsDenseList ] );
DeclareOperation( "InductiveList", [ IsObject, IsFunction ] );
DeclareOperation( "InductiveListWithImplementation", [ IsObject, IsFunction, IsNList ] );
DeclareOperation( "InductiveListImp", [ IsObject, IsFunction ] );
DeclareOperation( "ArithmeticSequenceN", [ IsInt, IsInt ] );
DeclareOperation( "ArithmeticSequenceZ", [ IsInt, IsInt ] );
DeclareOperation( "Concatenate", [ IsDenseList, IsNList ] );
# concatenate to ZList.
# middle list is placed in degrees [0, 1, ...]
DeclareOperation( "Concatenate", [ IsNList, IsDenseList, IsNList ] );
# concatenate to ZList.
# Concatenate( neg, i, mid, pos )
# middle list is placed in degrees [i, i + 1, ...]
DeclareOperation( "Concatenate", [ IsNList, IsInt, IsDenseList, IsNList ] );
DeclareOperation( "Concatenate", [ IsNList, IsNList ] );
DeclareOperation( "MakeConcatNList", [ IsDenseList, IsNList ] );
DeclareOperation( "MakeConcatZList", [ IsNList, IsDenseList, IsNList, IsInt ] );
DeclareOperation( "Cut", [ IsNList, IsInt ] );
DeclareOperation( "Map", [ IsInfList, IsFunction ] );
DeclareOperation( "Map", [ IsDenseList, IsFunction ] );
DeclareOperation( "Combine", [ IsDenseList ] );
DeclareOperation( "CombineN", [ IsDenseList ] );
DeclareOperation( "CombineZ", [ IsDenseList ] );
DeclareOperation( "LiftList", [ IsObject, IsNList, IsFunction ] );
DeclareOperation( "LiftListWithImplementation", [ IsObject, IsNList, IsFunction, IsNList ] );
DeclareOperation( "LiftListImp", [ IsDenseList, IsNList, IsFunction ] );

# Sublist( L, a, b ) -> [ L[ a ], ..., L[ ( b - 1 ) ] ]
DeclareOperation( "Sublist", [ IsNList, IsPosInt, IsPosInt ] );
DeclareOperation( "Sublist", [ IsZList, IsInt, IsInt ] );

DeclareOperation( "PositivePartFrom", [ IsZList, IsInt ] );
DeclareOperation( "NegativePartFrom", [ IsZList, IsInt ] );

DeclareOperation( "Shift", [ IsZList, IsInt ] );
DeclareOperation( "Splice", [ IsZList, IsZList, IsInt ] );
DeclareOperation( "Replace", [ IsZList, IsInt, IsDenseList ] );

DeclareOperation( "Intersection2", [ IsList, IsNList ] );
DeclareOperation( "Intersection2", [ IsNList, IsList ] );
DeclareOperation( "Intersection2", [ IsNList, IsNList ] );

DeclareGlobalVariable( "IntegersList" );
DeclareGlobalVariable( "PositiveIntegersList" );
DeclareGlobalVariable( "AlternatingSignList" );

DeclareOperation( "RotateLeft", [ IsList, IsInt ] );
DeclareOperation( "RotateRight", [ IsList, IsInt ] );
DeclareOperation( "Unrepeat", [ IsDenseList ] );
