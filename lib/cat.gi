
InstallMethod( Cat,
[ IsObject, IsString, IsRecord ],
function( identity, name, properties )
    local catProps, givenProps;
    
    catProps := [ "objInCat", "morphInCat", "domain", "codomain",
                  "compose", "identityMorph", "isIsomorphism", "inverse", "isomorphic", "isomorphism" ];
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
    
    catProps := [ "objInCat", "morphInCat", "domain", "codomain",
                  "compose", "identityMorph", "isIsomorphism", "inverse", "isomorphic", "isomorphism",
                  "zeroMorph", "addMorph", "invMorph", "zeroObj", "directSum" ];
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

# My category is full of eels
InstallMethod( AbelianCat,
[ IsObject, IsString, IsRecord ],
function( identity, name, properties )
    local catProps, givenProps;
    
    catProps := [ "objInCat", "morphInCat", "domain", "codomain",
                  "compose", "identityMorph", "isIsomorphism", "inverse", "isomorphic", "isomorphism",
                  "zeroMorph", "addMorph", "negateMorph", "zeroObj", "directSum",
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
        properties.isExact := function( f,g ) #  f: A ---> B , g: B ---> C
            return properties.isomorphic( properties.image( f ), properties.kernel( g ) );
        end;
    fi;

    return Objectify( NewType( NewFamily( "CatFamily", IsCat ),
                               IsCat and IsCatDefaultRep ),
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
#M  PrintObj( <cat> ) 
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
#M  ViewObj( <cat> ) 
##
##  Viewing a cateory, adding no more information than the PrintObj.
##  
InstallMethod( ViewObj,
[ IsCat ],
function( cat )
    Print( cat );
end );

