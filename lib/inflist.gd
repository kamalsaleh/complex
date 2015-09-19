DeclareInfoClass( "InfoInfList" );

DeclareCategory( "IsInfiniteNumber", IsObject );
DeclareGlobalVariable( "PositiveInfinity" );
DeclareGlobalVariable( "NegativeInfinity" );

DeclareCategory( "IsInfList", IsObject );
DeclareCategory( "IsInfListImp", IsObject );
DeclareCategory( "IsNList", IsInfList );
DeclareCategory( "IsNListImp", IsInfListImp );
DeclareCategory( "IsZList", IsInfList );
DeclareCategory( "IsZListImp", IsInfListImp );

DeclareCategory( "IsInductiveNListImp", IsNListImp );
DeclareCategory( "IsRepeatingNListImp", IsNListImp );
DeclareCategory( "IsPositionalNListImp", IsNListImp );
DeclareCategory( "IsArithmeticNListImp", IsNListImp );
DeclareCategory( "IsDerivedNListImp", IsNListImp );
DeclareCategory( "IsCutNListImp", IsDerivedNListImp );
DeclareCategory( "IsMapNListImp", IsDerivedNListImp );
DeclareCategory( "IsConcatNListImp", IsDerivedNListImp );
DeclareCategory( "IsCombinationNListImp", IsNListImp );
DeclareCategory( "IsLiftingNListImp", IsNListImp );

DeclareOperation( "\[\]", [ IsNList, IsPosInt ] );
DeclareOperation( "\[\]", [ IsZList, IsInt ] );
DeclareOperation( "LookupInfListImp", [ IsNListImp, IsPosInt ] );
DeclareOperation( "LookupInfListImp", [ IsZListImp, IsInt ] );

DeclareGlobalVariable( "InfListStringDefaultOptions" );
DeclareOperation( "InfListString", [ IsInfList ] );
DeclareOperation( "InfListString", [ IsInfListImp ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfList ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfList, IsBool ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfListImp ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsPosInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsDenseList ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsPosInt, IsDenseList ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfListImp, IsBool ] );
DeclareOperation( "InfListString", [ IsRecord, IsInfListImp, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsPosInt, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsDenseList, IsBool, IsInt, IsInt ] );
DeclareOperation( "InfListString", [ IsRecord, IsNListImp, IsPosInt, IsDenseList, IsBool, IsDenseList ] );

DeclareOperation( "MakeInfList", [ IsInfListImp ] );
DeclareOperation( "Implementation", [ IsInfList ] );
DeclareOperation( "SetImplementation", [ IsInfList, IsInfListImp ] );
DeclareOperation( "MakeInfListImp", [ IsOperation, IsRecord, IsDenseList ] );

#DeclareOperation( "Normalized", [ IsInfListImp ] );

DeclareOperation( "NotifyBetterImplementation", [ IsInfListImp, IsObject ] );
DeclareOperation( "BetterImplementationAvailable", [ IsObject, IsInfListImp ] );
DeclareAttribute( "BetterImplementation", IsInfListImp );

DeclareOperation( "AddAssertion", [ IsInfList, IsInfListAssertion ] );
DeclareOperation( "AddAssertion", [ IsInfListImp, IsInfListAssertion ] );
DeclareOperation( "CheckSingleAssertions", [ IsInfListImp, IsInt, IsObject ] );
DeclareOperation( "CheckDoubleAssertions", [ IsInfListImp, IsInt, IsObject, IsObject ] );

DeclareOperation( "KnownIndicesImp", [ IsInfListImp ] );

DeclareAttribute( "InitialValue", IsInductiveNListImp );
#DeclareAttribute( "InductionFunction", IsInductiveNListImp );
#DeclareAttribute( "RepeatingList", IsRepeatingNListImp );
DeclareAttribute( "ElementFunction", IsPositionalNListImp );
DeclareProperty( "IsStoringValues", IsPositionalNListImp );
DeclareAttribute( "InitialValue", IsArithmeticNListImp );
DeclareAttribute( "Increment", IsArithmeticNListImp );
DeclareAttribute( "BaseList", IsDerivedNListImp );
DeclareAttribute( "CutIndex", IsCutNListImp );
DeclareAttribute( "ConcatList", IsConcatNListImp );
DeclareAttribute( "MapFunction", IsMapNListImp );
DeclareAttribute( "Lists", IsCombinationNListImp );
DeclareAttribute( "InitialValues", IsLiftingNListImp );
DeclareAttribute( "LiftingFunction", IsLiftingNListImp );

DeclareOperation( "Repeatify", [ IsInductiveNListImp, IsPosInt, IsPosInt ] );
DeclareOperation( "Repeatify", [ IsLiftingNListImp, IsPosInt, IsPosInt ] );

DeclareProperty( "IsInductive", IsNList );
DeclareProperty( "IsEventuallyInductive", IsNList );
DeclareAttribute( "InductiveFromIndex", IsNList );
DeclareAttribute( "InductivePart", IsNList );
DeclareAttribute( "InductionFunction", IsNList );

DeclareProperty( "IsRepeating", IsNList );
DeclareProperty( "IsEventuallyRepeating", IsNList );
DeclareAttribute( "RepeatingFromIndex", IsNList );
DeclareAttribute( "RepeatingPart", IsNList );
DeclareAttribute( "RepeatingList", IsNList );

DeclareProperty( "IsInductive", IsNListImp );
DeclareProperty( "IsEventuallyInductive", IsNListImp );
DeclareAttribute( "InductiveFromIndex", IsNListImp );
DeclareAttribute( "InductivePart", IsNListImp );
DeclareAttribute( "InductionFunction", IsNListImp );

DeclareProperty( "IsRepeating", IsNListImp );
DeclareProperty( "IsEventuallyRepeating", IsNListImp );
DeclareAttribute( "RepeatingFromIndex", IsNListImp );
DeclareAttribute( "RepeatingPart", IsNListImp );
DeclareAttribute( "RepeatingList", IsNListImp );

#DeclareAttribute( "ElementFunction", IsInfList );

DeclareOperation( "RepeatList", [ IsDenseList ] );
DeclareOperation( "RepeatListImp", [ IsDenseList ] );
DeclareOperation( "ZRepeatList", [ IsDenseList ] );
DeclareOperation( "ZRepeatListImp", [ IsDenseList ] );
DeclareOperation( "InductiveList", [ IsObject, IsFunction ] );
DeclareOperation( "InductiveListImp", [ IsObject, IsFunction ] );
DeclareOperation( "PositionalList", [ IsFunction ] );
DeclareOperation( "PositionalList", [ IsFunction, IsBool ] );
DeclareOperation( "PositionalListImp", [ IsFunction, IsBool ] );
DeclareOperation( "ArithmeticSequence", [ IsInt, IsInt ] );
DeclareOperation( "ArithmeticSequenceImp", [ IsInt, IsInt ] );
DeclareOperation( "ZArithmeticSequence", [ IsInt, IsInt ] );
DeclareOperation( "ZArithmeticSequenceImp", [ IsInt, IsInt ] );
DeclareOperation( "Concatenate", [ IsDenseList, IsNList ] );
# concatenate to ZList.
# middle list is placed in degrees [0, 1, ...]
DeclareOperation( "Concatenate", [ IsNList, IsDenseList, IsNList ] );
DeclareOperation( "Concatenate", [ IsNList, IsNList ] );
DeclareOperation( "ConcatenateImp", [ IsDenseList, IsNListImp ] );
DeclareOperation( "MakeConcatNListImp", [ IsDenseList, IsNListImp ] );
DeclareOperation( "MakeConcatZListImp", [ IsNListImp, IsDenseList, IsNListImp, IsInt ] );
DeclareOperation( "ConcatenateImp", [ IsNListImp, IsDenseList, IsNListImp ] );
DeclareGlobalFunction( "Concat" );
DeclareOperation( "Cut", [ IsNList, IsInt ] );
DeclareOperation( "CutImp", [ IsNListImp, IsInt ] );
DeclareOperation( "Map", [ IsInfList, IsFunction ] );
DeclareOperation( "MapImp", [ IsInfListImp, IsFunction ] );
DeclareOperation( "Combine", [ IsDenseList ] );
DeclareOperation( "CombineImp", [ IsDenseList ] );
DeclareOperation( "LiftList", [ IsObject, IsNList, IsFunction ] );
DeclareOperation( "LiftListImp", [ IsDenseList, IsNListImp, IsFunction ] );

# Sublist( L, a, b ) -> [ L[ a ], ..., L[ ( b - 1 ) ] ]
DeclareOperation( "Sublist", [ IsNList, IsPosInt, IsPosInt ] );
DeclareOperation( "SublistImp", [ IsNListImp, IsPosInt, IsPosInt ] );
DeclareOperation( "Sublist", [ IsZList, IsInt, IsInt ] );
#DeclareOperation( "Sublist", [ IsZList, IsInt, IsInfiniteNumber ] );
DeclareOperation( "SublistImp", [ IsZListImp, IsInt, IsInt ] );

DeclareOperation( "PositivePartFrom", [ IsZList, IsInt ] );
DeclareOperation( "NegativePartFrom", [ IsZList, IsInt ] );

DeclareCategory( "IsConcatZListImp", IsZListImp );
DeclareCategory( "IsRepeatingZListImp", IsZListImp );
DeclareCategory( "IsArithmeticZListImp", IsZListImp );

DeclareAttribute( "BasePosition", IsZListImp );
DeclareAttribute( "PositiveList", IsConcatZListImp );
DeclareAttribute( "NegativeList", IsConcatZListImp );
DeclareAttribute( "MiddleList", IsConcatZListImp );
DeclareAttribute( "RepeatingList", IsRepeatingZListImp );

DeclareProperty( "IsInductiveUp", IsZList );
DeclareProperty( "IsInductiveDown", IsZList );
DeclareProperty( "IsRepeatingUp", IsZList );
DeclareProperty( "IsRepeatingDown", IsZList );

DeclareOperation( "Shift", [ IsZList, IsInt ] );
DeclareOperation( "ShiftImp", [ IsZListImp, IsInt ] );
DeclareOperation( "Splice", [ IsZList, IsZList, IsInt ] );

DeclareOperation( "Intersection2", [ IsList, IsNList ] );
DeclareOperation( "Intersection2", [ IsNList, IsList ] );
DeclareOperation( "Intersection2", [ IsNList, IsNList ] );

DeclareGlobalVariable( "IntegersList" );
DeclareGlobalVariable( "PositiveIntegersList" );
DeclareGlobalVariable( "AlternatingSignList" );

DeclareOperation( "RotateLeft", [ IsList, IsInt ] );
DeclareOperation( "RotateRight", [ IsList, IsInt ] );
