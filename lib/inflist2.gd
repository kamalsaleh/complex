

DeclareCategory( "IsMapZList", IsZList );
DeclareCategory( "IsCombinationZList", IsZList );

#############################
#
#   Attributes
#
#############################

DeclareAttribute( "MapFunction", IsMapZList );
DeclareAttribute( "BaseList", IsMapZList );
DeclareAttribute( "BaseLists", IsCombinationZList );

#############################
#
# Operations
#
#############################

DeclareOperation( "CombineZLazy", [ IsDenseList ] );

DeclareOperation( "MapLazy", [ IsZList, IsFunction ] );
DeclareOperation( "MapLazy", [ IsDenseList, IsFunction ] );