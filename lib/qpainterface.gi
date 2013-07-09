


# This file should be renamed and moved to the QPA package in due time …

InstallMethod( CatOfRightAlgebraModules,
[ IsAlgebra ],
function( alg )
    local properties, objInCat, morphInCat, compose, domain, codomain,
          identityMorph, isIsomorphism, inverse, isomorphic, objString, zeroMorph,
          #isomorphism,
          addMorph, negateMorph, directSum, kernel, cokernel,
          kernelFactorization, cokernelFactorization;

    objInCat := function( M )
        return IsPathAlgebraMatModule( M ) and ( RightActingAlgebra( M ) = alg );
    end;

    morphInCat := function( f )
        return IsPathAlgebraMatModuleHomomorphism( f ) and objInCat( Source( f ) ) and objInCat( Range( f ) );
    end;

    domain := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return Source(f);
    end;

    codomain := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return Range(f);
    end;

    compose := function( g, f ) #  A --f--> B --g--> C
        if ( not morphInCat( g ) ) or ( not morphInCat( f ) ) then
            Error( "one or both morphisms are not in the cateogory" );
        fi;
        if Range( f ) = Source( g ) then
            return f * g;
        else
            Error( "not composable morphisms," );
        fi;
    end;

    identityMorph := function( M )
        if not objInCat( M ) then
            Error( "object is not in the cateogory" );
        fi;
        return IdentityMapping(M);
    end;

    isIsomorphism := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return IsIsomorphism( f );
    end;

    inverse := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        elif not isIsomorphism( f ) then
            Error( "morphism is not an isomorphism" );
        else
            return InverseOfIsomorphism( f );
        fi;
    end;

    isomorphic := function( M, N )
        if ( not objInCat( M ) ) or ( not objInCat( N ) ) then
            Error( "one or both objects are not in the category" );
        fi;
        return IsomorphicModules( M, N );
    end;

    # isomorphism not written yet

    zeroMorph := function( M, N )
        if ( not objInCat( M ) ) or ( not objInCat( N ) ) then
            Error( "one or both objects are not in the category" );
        fi;
        return ZeroMapping( M, N );
    end;
    
    addMorph := function( f, g )
        if ( not morphInCat( g ) ) or ( not morphInCat( f ) ) then
            Error( "one or both morphisms are not in the cateogory" );
        fi;
        return f + g;
    end;

    negateMorph := function( f )
        if not morphInCat( f ) then
            Error( "the morphism is not in the cateogory" );
        fi;
        return -f;
    end;

    directSum := function( M, N )
        local sum;

        if ( not objInCat( M ) ) or ( not objInCat( N ) ) then
            Error( "one or both objects are not in the category" );
        fi;

        sum := DirectSumOfModules( [ M, N ] );
        return [ DirectSumInclusions( sum )[1], DirectSumInclusions( sum )[2],
                 DirectSumProjections( sum )[1], DirectSumProjections( sum )[2] ];
    end;

    kernel := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return KernelInclusion( f );
    end;

    cokernel := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return CoKernelProjection( f );
    end;

    kernelFactorization := function( f, g ) # A --g--> B --f--> C, fg = 0
        local maps, kerinc;

        if ( not morphInCat( g ) ) or ( not morphInCat( f ) ) then
            Error( "one or both morphisms are not in the cateogory" );
        fi;        

        if compose( f, g ) <> ZeroMapping( Source( g ), Range( f ) ) then
            Error( "composition must be zero for kernel factorization" );
        fi;

        maps := ImageProjectionInclusion( g );
        kerinc := KernelInclusion( f );

        return compose( LiftingInclusionMorphisms( kerinc, maps[2] ), maps[1] );
    end;

    cokernelFactorization := function( f, g ) # A --f--> B --g--> C, gf = 0
        local cokerProj, coker, gens, images;

        if ( not morphInCat( g ) ) or ( not morphInCat( f ) ) then
            Error( "one or both morphisms are not in the cateogory" );
        fi;

        if compose( g, f ) <> ZeroMapping( Source( f ), Range( g ) ) then
            Error( "composition must be zero for cokernel factorization" );
        fi;

        cokerProj := CoKernelProjection( f );
        coker := Range( cokerProj );
        gens := BasisVectors( Basis( coker ) );
        images := List( gens, x -> ImageElm( g, PreImagesRepresentative( cokerProj, x ) ) );
        return HomomorphismFromImages( coker, Range( g ), images );
    end;
    
    objString := function( M )
        local dims;
        dims := JoinStringsWithSeparator( DimensionVector( M ), "," );
        return Concatenation( "(", dims, ")" );
    end;

    properties := rec( objInCat := objInCat,
                       morphInCat := morphInCat,
                       domain := domain,
                       codomain := codomain,
                       compose := compose,
                       identityMorph := identityMorph,
                       isIsomorphism := isIsomorphism,
                       inverse := inverse,
                       isomorphic := isomorphic,
                       isomorphism := false,
                       objString := objString,
                       zeroMorph := zeroMorph,
                       addMorph := addMorph,
                       negateMorph := negateMorph,
                       zeroObj := ZeroModule( alg ),
                       directSum := directSum,
                       kernel := kernel,
                       cokernel := cokernel,
                       kernelFactorization := kernelFactorization,
                       cokernelFactorization := cokernelFactorization
                       );
    return AbelianCat( [alg, "right modules"], "right modules over algebra", properties );

end);


