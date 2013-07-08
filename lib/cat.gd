# category.

DeclareCategory( "IsCat", IsRecord );
DeclareCategory( "IsAdditiveCat", IsCat );
DeclareCategory( "IsAbelianCat", IsAdditiveCat );

DeclareRepresentation( "IsCatDefaultRep", IsComponentObjectRep,
                       [ "identity", "name", "properties" ] );

DeclareOperation( "Cat", [ IsObject, IsString, IsRecord ] );
DeclareOperation( "AdditiveCat", [ IsObject, IsString, IsRecord ] );
DeclareOperation( "AbelianCat", [ IsObject, IsString, IsRecord ] );

DeclareOperation( "ObjectInCat", [ IsCat, IsObject ] );
DeclareOperation( "MorphismInCat", [ IsCat, IsObject ] );
DeclareOperation( "Domain", [ IsCat, IsObject ] );
DeclareOperation( "Codomain", [ IsCat, IsObject ] );
DeclareOperation( "Compose", [ IsCat, IsObject, IsObject ] );
DeclareOperation( "IdentityMorphism", [ IsCat, IsObject ] );
DeclareOperation( "IsIsomorphism", [ IsCat, IsObject ] );
DeclareOperation( "Inverse", [ IsCat, IsObject ] );
DeclareOperation( "Isomorphic", [ IsCat, IsObject, IsObject ] );
DeclareOperation( "Isomorphism", [ IsCat, IsObject, IsObject ] );

DeclareOperation( "ZeroMorphism", [ IsAdditiveCat, IsObject, IsObject ] );
DeclareOperation( "AddMorphisms", [ IsAdditiveCat, IsObject, IsObject ] );
DeclareOperation( "NegateMorphism", [ IsAdditiveCat, IsObject ] );
DeclareOperation( "ZeroObject", [ IsAdditiveCat ] );
DeclareOperation( "DirectSum", [ IsAdditiveCat, IsObject, IsObject ] );

DeclareOperation( "KernelOfMorphism", [ IsAbelianCat, IsObject ] );
DeclareOperation( "CokernelOfMorphism", [ IsAbelianCat, IsObject ] );
DeclareOperation( "KernelFactorization", [ IsAbelianCat, IsObject, IsObject ] );
DeclareOperation( "CokernelFactorization", [ IsAbelianCat, IsObject, IsObject ] );
