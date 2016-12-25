

DeclareCategory( "IsMapZList", IsZList );
DeclareCategory( "IsCombinationZList", IsZList );
DeclareCategory( "IsShiftedZList", IsZList );
DeclareCategory( "IsReflectedZList", IsZList );

#############################
#
#   Attributes
#
#############################

DeclareAttribute( "MapFunction", IsMapZList );
DeclareAttribute( "BaseList", IsMapZList );
DeclareAttribute( "NrArg", IsMapZList );

DeclareAttribute( "BaseList", IsShiftedZList );
DeclareAttribute( "ShiftIndex", IsShiftedZList );

DeclareAttribute( "BaseLists", IsCombinationZList );

DeclareAttribute( "BaseList", IsReflectedZList );
DeclareAttribute( "Reflection", IsZList );

#############################
#
# Operations
#
#############################

DeclareOperation( "CombineZLazy", [ IsDenseList ] );

DeclareOperation( "MapLazy", [ IsZList, IsFunction, IsInt ] );
KeyDependentOperation( "ShiftLazy", IsZList, IsInt, ReturnTrue );
DeclareOperation( "MapLazy", [ IsDenseList, IsFunction, IsInt ] );
