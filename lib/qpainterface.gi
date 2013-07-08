


# This file should be renamed and moved to the QPA package in due time …

InstallMethod( CatOfRightAlgebraModules,
[ IsAlgebra ],
function( alg )
    local properties, objInCat, morphInCat, compose, 
          #isomorphism,
          addMorph, negateMorph,
          directSum, kernelFactorization, cokernelFactorization;

    objInCat := function( M )
        return IsPathAlgebraMatModule( M ) and ( RightActingAlgebra( M ) = alg );
    end;

    morphInCat := function( f )
        return IsPathAlgebraMatModuleHomomorphism( f ) and objInCat( Source( f ) ) and objInCat( Range( f ) );
    end;

    compose := function( g, f ) #  A --f--> B --g--> C
        if Range( f ) = Source( g ) then
            return f * g;
        else
            Error( "not composable morphisms: ", [g, f] );
        fi;
    end;

    # isomorphism mangler!

    addMorph := function( f, g )
        return f + g;
    end;

    negateMorph := function( f )
        return -f;
    end;

    directSum := function( M, N )
        local sum;
        sum := DirectSumOfModules( [ M, N ] );
        return [ DirectSumInclusions( sum )[1], DirectSumInclusions( sum )[2],
                 DirectSumProjections( sum )[1], DirectSumProjections( sum )[2] ];
    end;

    kernelFactorization := function( f, g ) # A --g--> B --f--> C, fg = 0
        local maps, kerinc;
        
        if compose( f, g ) <> ZeroMapping( Source( g ), Range( f ) ) then
            Error( "composition must be zero for kernel factorization" );
        fi;

        maps := ImageProjectionInclusion( g );
        kerinc := KernelInclusion( f );

        return compose( LiftingInclusionMorphisms( kerinc, maps[2] ), maps[1] );
    end;

    cokernelFactorization := function( f, g ) # A --f--> B --g--> C, gf = 0
        local cokerProj, coker, gens, images;
        if compose( g, f ) <> ZeroMapping( Source( f ), Range( g ) ) then
            Error( "composition must be zero for cokernel factorization" );
        fi;
        cokerProj := CoKernelProjection( f );
        coker := Range( cokerProj );
        gens := BasisVectors( Basis( coker ) );
        images := List( gens, x -> Image( g, PreImagesRepresentative( cokerProj, x ) ) );
        return HomomorphismFromImages( coker, Range( g ), images );
    end;
    
    properties := rec( objInCat := objInCat,
                       morphInCat := morphInCat,
                       domain := Source,
                       codomain := Range,
                       compose := compose,
                       identityMorph := IdentityMapping,
                       isIsomorphism := IsIsomorphism,
                       inverse := InverseOfIsomorphism,
                       isomorphic := IsomorphicModules,
                       isomorphism := false,
                       zeroMorph := ZeroMapping,
                       addMorph := addMorph,
                       negateMorph := negateMorph,
                       zeroObj := ZeroModule( alg ),
                       directSum := directSum,
                       kernel := KernelInclusion,
                       cokernel := CoKernelProjection,
                       kernelFactorization := kernelFactorization,
                       cokernelFactorization := cokernelFactorization
                       );
    return AbelianCat( [alg, "right modules"], "right modules over algebra", properties );

end);


