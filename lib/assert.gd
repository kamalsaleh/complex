DeclareCategory( "IsInfListAssertion", IsObject );
DeclareCategory( "IsInfListSingleAssertion", IsInfListAssertion );
DeclareCategory( "IsInfListDoubleAssertion", IsInfListAssertion );

DeclareAttribute( "AssertionFunction", IsInfListAssertion );
DeclareAttribute( "AssertionMessage", IsInfListAssertion );
DeclareAttribute( "AssertionOffset", IsInfListAssertion );
DeclareAttribute( "AssertionObject", IsInfListAssertion );
DeclareAttribute( "AssertionDirection", IsInfListAssertion );
DeclareAttribute( "IsReversed", IsInfListAssertion );

DeclareOperation( "CheckAssertion", [ IsInfListSingleAssertion, IsInt, IsObject ] );
DeclareOperation( "CheckAssertion", [ IsInfListDoubleAssertion, IsInt, IsObject, IsObject ] );

DeclareOperation( "MakeSingleAssertion", [ IsObject, IsFunction, IsString ] );
DeclareOperation( "MakeDoubleAssertion", [ IsObject, IsFunction, IsString ] );
DeclareOperation( "MakeAssertion", [ IsFunction, IsObject, IsFunction, IsString, IsInt, IsBool ] );

DeclareOperation( "Shift", [ IsInfListAssertion, IsInt ] );
DeclareOperation( "Reverse", [ IsInfListAssertion ] );
