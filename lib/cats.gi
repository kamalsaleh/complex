# Ab
createAb := function()
    local properties, morphInCat, compose, isIsomorphism, inverse,
          isomorphic, isomorphism, zeroMorph, addMorph, negateMorph,
          direkteSum, kernel, cokernel,
          kernelFactorization, cokernelFactorization;

    morphInCat := function( f )
        return IsGroupHomomorphism( f ) and
               IsAbelian( Source( f ) ) and
               IsAbelian( Range( f ) );
    end;

    compose := function( g, f ) #  A --f--> B --g--> C
        if Range( f ) = Source( g ) then
            return f * g;
        else
            Error( "not composable morphisms: ", [g, f] );
        fi;
    end;

    isIsomorphism := function( f )
        return IsGroupHomomorphism( InverseGeneralMapping( f ) );
    end;

    inverse := function( f )
        local inv;
        inv := InverseGeneralMapping( f );
        if IsGroupHomomorphism( inv ) then
            return inv;
        else
            Error( "not an isomorphism: ", f );
        fi;
    end;

    isomorphic := function( G, H )
        return IsomorphismGroups( G, H ) <> fail;
    end;

    isomorphism := function( G, H )
        local iso;
        iso := IsomorphismGroups( G, H );
        if iso <> fail then
            return iso;
        else
            Error( "not isomorphic groups: ", [G,H] );
        fi;
    end;

    zeroMorph := function( G, H )
        local gens, zero, zeroList;

        gens := GeneratorsOfGroup( G );
        zero := One( H );
        zeroList := List( [ 1 .. Length( gens ) ],
                          x -> zero );

        return GroupHomomorphismByImages( G, H, gens, zeroList );
    end;

    addMorph := function( f, g )
        local gens, images;
        
        if Range(f) <> Range(g) or Source(f) <> Source(g) then
            Error( "functions must have same domain and codomain" );
        fi;

        gens := GeneratorsOfGroup( Source(g) );
        images := List( gens, x -> ImageElm(f,x)*ImageElm(g,x) );

        return GroupHomomorphismByImages( Source(g), Range(g), gens, images );
    end;

    negateMorph := function( f )
        local gens, images;
        
        gens := GeneratorsOfGroup( Source(f) );
        images := List( gens, x -> Inverse(f,x) );

        return GroupHomomorphismByImages( Source(f), Range(f), gens, images );
    end;

    direkteSum := function( G, H )
        local sum;

        sum := DirectProduct( G, H );
        return [ Embedding( sum, 1 ), Embedding( sum, 2 ),
                 Projection( sum, 1 ), Projection( sum, 2 ) ];
    end;

    kernel := function( f )
        local K, gens;
        K := Kernel( f );
        gens := GeneratorsOfGroup( K );
        return GroupHomomorphismByImages( K, Source( f ), gens, gens );
    end;

    cokernel := function( f )
        return NaturalHomomorphismByNormalSubgroup( Range( f ), Image( f ) );
    end;

    kernelFactorization := function( f, g ) # A --g--> B --f--> C, fg = 0
        local gens, images;
        if compose( f, g ) <> zeroMorph( Source( g ), Range( f ) ) then
            Error( "composition must be zero for kernel factorization" );
        fi;
        gens := GeneratorsOfGroup( Source( g ) );
        images := List( gens, x -> Image( g, x ) );
        return GroupHomomorphismByImages( Source( g ), Kernel( f ), gens, images );
    end;

    cokernelFactorization := function( f, g ) # A --f--> B --g--> C, gf = 0
        local cokerProj, Coker, gens, images;
        if compose( g, f ) <> zeroMorph( Source( f ), Range( g ) ) then
            Error( "composition must be zero for cokernel factorization" );
        fi;
        cokerProj := cokernel( f );
        Coker := Range( cokerProj );
        gens := GeneratorsOfGroup( Coker );
        images := List( gens, x -> Image( g, Representative( PreImages( cokerProj, x ) ) ) );
        return GroupHomomorphismByImages( Coker, Range( g ), gens, images );
    end;

    properties := rec( objInCat := IsGroup and IsAbelian,
                       morphInCat := morphInCat,
                       domain := Source,
                       codomain := Range,
                       compose := compose,
                       identityMorph := IdentityMapping,
                       isIsomorphism := isIsomorphism,
                       inverse := inverse,
                       isomorphic := isomorphic,
                       isomorphism := isomorphism,
                       zeroMorph := zeroMorph,
                       addMorph := addMorph,
                       negateMorph := negateMorph,
                       zeroObj := TrivialGroup(),
                       directSum := direkteSum,
                       kernel := kernel,
                       cokernel := cokernel,
                       kernelFactorization := kernelFactorization,
                       cokernelFactorization := cokernelFactorization );

    return AbelianCat( "Niels Henrik",
                       "Ab",
                       properties );

end;

InstallValue( Ab, createAb() );
#InstallValue( Ab, 42 );
