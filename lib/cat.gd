# category.

DeclareCategory( "IsCat", IsRecord );
DeclareCategory( "IsAdditiveCat", IsCat );
DeclareCategory( "IsAbelianCat", IsAdditiveCat );

DeclareRepresentation( "IsCatDefaultRep", IsComponentObjectRep,
                       [ "identity", "properties" ] );

DeclareOperation( "Cat", [ IsObject, IsString, IsRecord ] );
DeclareOperation( "AdditiveCat", [ IsObject, IsString, IsRecord ] );
DeclareOperation( "AbelianCat", [ IsObject, IsString, IsRecord ] );
