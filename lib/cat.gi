
InstallMethod( Cat,
[ IsObject, IsString, IsRecord ],
function( identity, name, properties )
    local catProps, givenProps;
    
    catProps := [ "objInCat", "morphInCat",
                  "domain", "codomain",
                  "compose", "identityMorph",
                  "isIsomorphism", "inverse", "isomorphic", "isomorphism",
                  "objString" ];
    givenProps := RecNames( properties );
    if not ForAll( catProps, prop -> prop in givenProps ) then
        Error( "Missing properties for cat" );
    fi;

    return Objectify( NewType( NewFamily( "CatFamily", IsCat ),
                               IsCat and IsCatDefaultRep ),
                      rec( identity := identity,
                           name := name,
                           properties := properties ));
end );

# I will not buy this category, it is scratched.
InstallMethod( AdditiveCat,
[ IsObject, IsString, IsRecord ],
function( identity, name, properties )
    local catProps, givenProps;
    
    catProps := [ "objInCat", "morphInCat",
                  "domain", "codomain",
                  "compose", "identityMorph",
                  "isIsomorphism", "inverse", "isomorphic", "isomorphism",
                  "objString",
                  # for additive cat:
                  "zeroMorph", "addMorph", "negateMorph", "zeroObj", "directSum" ];
    givenProps := RecNames( properties );
    if not ForAll( catProps, prop -> prop in givenProps ) then
        Error( "Missing properties for cat" );
    fi;

    return Objectify( NewType( NewFamily( "CatFamily", IsCat ),
                               IsAdditiveCat and IsCatDefaultRep ),
                      rec( identity := identity,
                           name := name,
                           properties := properties ));
end );

# My category is full of eels
InstallMethod( AbelianCat,
[ IsObject, IsString, IsRecord ],
function( identity, name, properties )
    local catProps, givenProps;
    
    catProps := [ "objInCat", "morphInCat",
                  "domain", "codomain",
                  "compose", "identityMorph",
                  "isIsomorphism", "inverse", "isomorphic", "isomorphism",
                  "objString",
                  # for additive cat:
                  "zeroMorph", "addMorph", "negateMorph", "zeroObj", "directSum",
                  # for abelian cat:
                  "kernel", "cokernel", "kernelFactorization", "cokernelFactorization" ];
    givenProps := RecNames( properties );
    if not ForAll( catProps, prop -> prop in givenProps ) then
        Error( "Missing properties for cat" );
    fi;

    properties := ShallowCopy( properties );
    if not "image" in givenProps then
        properties.image := function( f )
            return properties.kernel( properties.cokernel( f ) );
        end;
    fi;

    if not "isExact" in givenProps then
        properties.isExact := function( g,f ) #  f: A ---> B , g: B ---> C
            local h, cok;
            h := properties.kernelFactorization( g, properties.image( f ) );
            cok := properties.codomain( properties.cokernel( h ) );
            return properties.isomorphic( properties.zeroObj, cok );

        end;
    fi;

    return Objectify( NewType( NewFamily( "CatFamily", IsCat ),
                               IsAbelianCat and IsCatDefaultRep ),
                      rec( identity := identity,
                           name := name,
                           properties := properties ));
end );

#######################################################################
##
#M  \.( <cat>, <propName> ) 
##
##  Method for retrieving properties from a category, where <propName>
##  is one of the properties listed in the Cat() documentation above.
##  
InstallMethod( \.,
[ IsCat, IsPosInt ],
function( cat, propName )
    return cat!.properties.( NameRNam( propName ) );
end );

#######################################################################
##
#M  \=( <cat1>, <cat2> ) 
##
##  Equality test for two categories. Two categories are equal if
##  and only if their identity are the same.
##  
InstallMethod( \=,
[ IsCat, IsCat ],
function( cat1, cat2 )
    return cat1!.identity = cat2!.identity;
end );

#######################################################################
##
##  PrintObj( <cat> ) 
##
##  Printing a category, using its name.
##  
InstallMethod( PrintObj,
[ IsCat ],
function( cat )
    Print( "<cat: ", cat!.name, ">" );
end );

#######################################################################
##
##  ViewObj( <cat> ) 
##
##  Viewing a cateory, adding no more information than the PrintObj.
##  
InstallMethod( ViewObj,
[ IsCat ],
function( cat )
    Print( cat );
end );

InstallMethod( ObjectInCat,
[ IsCat, IsObject ],
function( cat, X )
    return cat.objInCat( X );
end );

InstallMethod( MorphismInCat,
[ IsCat, IsObject ],
function( cat, f )
    return cat.morphInCat( f );
end );

InstallMethod( DomainOfMorphism,
[ IsCat, IsObject ],
function( cat, f )
    return cat.domain( f );
end );

InstallMethod( CodomainOfMorphism,
[ IsCat, IsObject ],
function( cat, f )
    return cat.codomain( f );
end );

InstallMethod( Compose,
[ IsCat, IsObject, IsObject ],
function( cat, f, g )
    return cat.compose( f, g );
end );

InstallMethod( IdentityMorphism,
[ IsCat, IsObject ],
function( cat, X )
    return cat.identityMorph( X );
end );

InstallMethod( MorphismIsIsomorphism,
[ IsCat, IsObject ],
function( cat, f )
    return cat.isIsomorphism( f );
end );

InstallMethod( Inverse,
[ IsCat, IsObject ],
function( cat, f )
    return cat.inverse( f );
end );

InstallMethod( Isomorphic,
[ IsCat, IsObject, IsObject ],
function( cat, X, Y )
    return cat.isomorphic( X, Y );
end );

InstallMethod( Isomorphism,
[ IsCat, IsObject, IsObject ],
function( cat, X, Y )
    return cat.isomorphism( X, Y );
end );

InstallMethod( ObjectAsString,
[ IsCat, IsObject ],
function( cat, X )
    return cat.objString( X );
end );

InstallMethod( ZeroMorphism,
[ IsAdditiveCat, IsObject, IsObject ],
function( cat, X, Y )
    return cat.zeroMorph( X, Y );
end );

InstallMethod( AddMorphisms,
[ IsAdditiveCat, IsObject, IsObject ],
function( cat, f, g )
    return cat.addMorph( f, g );
end );

InstallMethod( NegateMorphism,
[ IsAdditiveCat, IsObject ],
function( cat, f )
    return cat.negateMorph( f );
end );

InstallMethod( ZeroObject,
[ IsAdditiveCat ],
function( cat )
    return cat.zeroObj;
end );

InstallMethod( DirectSumOfObjects,
[ IsAdditiveCat, IsObject, IsObject ],
function( cat, X, Y )
    return cat.directSum( X, Y );
end );

InstallMethod( IsZeroObject,
[ IsAdditiveCat, IsObject ],
function( cat, X )
    return Isomorphic( cat, X, ZeroObject( cat ) );
end );

InstallMethod( IsZeroMorphism,
[ IsAdditiveCat, IsObject ],
function( cat, f )
    if not MorphismInCat( cat, f ) then
        return false;
    fi;
    return f = ZeroMorphism( cat,
                             DomainOfMorphism( cat, f ),
                             CodomainOfMorphism( cat, f ) );
end );

InstallMethod( KernelOfMorphism,
[ IsAbelianCat, IsObject ],
function( cat, f )
    return cat.kernel( f );
end );

InstallMethod( CokernelOfMorphism,
[ IsAbelianCat, IsObject ],
function( cat, f )
    return cat.cokernel( f );
end );

InstallMethod( KernelFactorization,
[ IsAbelianCat, IsObject, IsObject ],
function( cat, f, g )
    return cat.kernelFactorization( f, g );
end );

InstallMethod( CokernelFactorization,
[ IsAbelianCat, IsObject, IsObject ],
function( cat, f, g )
    return cat.cokernelFactorization( f, g );
end );

InstallMethod( ImageOfMorphism,
[ IsAbelianCat, IsObject ],
function( cat, f )
    return cat.image( f );
end );

InstallMethod( IsExact,
[ IsAbelianCat, IsObject, IsObject ],
function( cat, f, g )
    return cat.isExact( f, g );
end );
