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
DeclareOperation( "DomainOfMorphism", [ IsCat, IsObject ] );
DeclareOperation( "CodomainOfMorphism", [ IsCat, IsObject ] );
DeclareOperation( "Compose", [ IsCat, IsObject, IsObject ] );
DeclareOperation( "IdentityMorphism", [ IsCat, IsObject ] );
DeclareOperation( "MorphismIsIsomorphism", [ IsCat, IsObject ] );
DeclareOperation( "Inverse", [ IsCat, IsObject ] );
DeclareOperation( "Isomorphic", [ IsCat, IsObject, IsObject ] );
DeclareOperation( "Isomorphism", [ IsCat, IsObject, IsObject ] );
DeclareOperation( "ObjectAsString", [ IsCat, IsObject ] );

DeclareOperation( "ZeroMorphism", [ IsAdditiveCat, IsObject, IsObject ] );
DeclareOperation( "AddMorphisms", [ IsAdditiveCat, IsObject, IsObject ] );
DeclareOperation( "NegateMorphism", [ IsAdditiveCat, IsObject ] );
DeclareOperation( "ZeroObject", [ IsAdditiveCat ] );
DeclareOperation( "DirectSumOfObjects", [ IsAdditiveCat, IsObject, IsObject ] );
DeclareOperation( "IsZeroObject", [ IsAdditiveCat, IsObject ] );
DeclareOperation( "IsZeroMorphism", [ IsAdditiveCat, IsObject ] );

DeclareOperation( "KernelOfMorphism", [ IsAbelianCat, IsObject ] );
DeclareOperation( "CokernelOfMorphism", [ IsAbelianCat, IsObject ] );
DeclareOperation( "KernelFactorization", [ IsAbelianCat, IsObject, IsObject ] );
DeclareOperation( "CokernelFactorization", [ IsAbelianCat, IsObject, IsObject ] );
DeclareOperation( "ImageOfMorphism", [ IsAbelianCat, IsObject ] );
DeclareOperation( "IsExact", [ IsAbelianCat, IsObject, IsObject ] );
