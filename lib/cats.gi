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
                       objString := StringView,
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


InstallMethod( Vec,
[ IsField ],
function( K )
    local properties, objInCat, morphInCat, compose, domain, codomain,
          identityMorph, isIsomorphism, inverse, isomorphic, objString, zeroMorph,
          isomorphism, addMorph, negateMorph, directSum, kernel, cokernel,
          kernelFactorization, cokernelFactorization;

    objInCat := function( X )
        return IsVectorSpace( X ) and
               LeftActingDomain( X ) = K;
    end;

    morphInCat := function( f )
        return IsMapping( f ) and
               objInCat( Source( f ) ) and
               objInCat( Range( f ) ) and
               RespectsScalarMultiplication( f ) and
               RespectsAddition( f );
        
    end;

    domain := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return Source( f );
    end;

    codomain := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return Range( f );
    end;

    compose := function( g,f ) # V --f--> W --g--> U
        if ( not morphInCat( g ) ) or ( not morphInCat( f ) ) then
            Error( "one or both morphisms are not in the category" );
        fi;
        if Range( f ) = Source( g ) then
            return f * g;
        else
            Error( "not composable morphisms" );
        fi;
    end;

    identityMorph := function( V )
        if not objInCat( V ) then
            Error( "object is not in the category" );
        fi;
        return IdentityMapping(V);
    end;

    isIsomorphism := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return IsBijective( f );
    end;

    inverse := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        elif not isIsomorphism( f ) then
            Error( "morphism is not an isomorphism" );
        fi;
        return LeftModuleHomomorphismByMatrix( Basis( Range( f ) ),
                                               Inverse( f!.matrix ),
                                               Basis( Source( f ) ) );
    end;

    isomorphic := function( V, W )
        if ( not objInCat( V ) ) or ( not objInCat( W ) ) then
            Error( "one or both objects are not in the category" );
        fi;
        return Dimension( V ) = Dimension( W );
    end;

    isomorphism := function( V, W )
        local identityMatrix;
        if ( not isomorphic( V, W ) ) then
            Error( "the objects are not isomorphic" );
        fi;
        identityMatrix := DiagonalMat( List( [1..Dimension(V)], x -> 1 ) );
        return LeftModuleHomomorphismByMatrix( Basis( W ),
                                               identityMatrix,
                                               Basis( V ) );
    end;

    zeroMorph := function( V, W )
        if ( not objInCat( V ) ) or ( not objInCat( W ) ) then
            Error( "one or both objects are not in the category" );
        fi;
        return ZeroMapping( V, W );
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

    directSum := function( V, W )
        local newDim, newGens, i, j, basisMapped, dirSum, identityMatrix, inc1mat, inc2mat,
              proj1mat, proj2mat, inc1, inc2, proj1, proj2;
        newDim := Dimension(V) + Dimension(W);
        newGens := [];
        if Dimension(V) = 1 then
            Append( newGens, [ Concatenation( BasisVectors( Basis( V ) ), List( [1..Dimension(W)], x -> 0 ) ) ] );
        else
            for i in [1..Dimension(V)] do
                basisMapped := Concatenation( BasisVectors( Basis( V ) )[i], List( [1..Dimension(W)], x -> 0 ) );
                Append( newGens, [basisMapped] );
            od;
        fi;
        if Dimension(W) = 1 then
            Append( newGens, [ Concatenation( List( [1..Dimension(V)], x -> 0 ), BasisVectors( Basis( W ) ) ) ] );
        else
            for j in [1..Dimension(W)] do
                basisMapped := Concatenation(  List( [1..Dimension(V)], x -> 0 ), BasisVectors( Basis( W ) )[j] );
                Append( newGens, [basisMapped] );
            od;
        fi;
        dirSum :=  VectorSpace( K, newGens );

        identityMatrix := DiagonalMat( List( [1..Dimension(dirSum)], x -> 1 ) );        

        inc1mat := List( [1..Dimension(V)], x -> identityMatrix[x] );
        inc2mat := List( [1..Dimension(W)], x -> identityMatrix[x + Dimension(V)] );
        proj1mat := TransposedMat(inc1mat);
        proj2mat := TransposedMat(inc2mat);
        
        inc1 := LeftModuleHomomorphismByMatrix( Basis(V), inc1mat, Basis(dirSum) );
        inc2 := LeftModuleHomomorphismByMatrix( Basis(W), inc2mat, Basis(dirSum) );
        proj1 := LeftModuleHomomorphismByMatrix( Basis(dirSum), proj1mat, Basis(V) );
        proj2 := LeftModuleHomomorphismByMatrix( Basis(dirSum), proj2mat, Basis(W) );

        return [inc1, inc2, proj1, proj2];
    end;

    kernel := function( f )
        local ker, basis;
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        ker := Kernel( f );
        basis := BasisVectors( Basis( ker ) );
        if IsEmpty( basis ) then
            return ZeroMapping( ker, Source( f ) );
        fi;
        return LeftModuleHomomorphismByImages( ker, Source( f ), basis, basis );
    end;

    cokernel := function( f )
        if not morphInCat( f ) then
            Error( "morphism is not in the category" );
        fi;
        return NaturalHomomorphismBySubspace( Range( f ), Image( f ) );
    end;

    kernelFactorization := function( f, g ) # V --g--> U --f--> W, fg = 0
        return true;
    end;


    cokernelFactorization := function( f, g ) # A --f--> B --g--> C, gf = 0
        return true;
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
                       isomorphism := isomorphism,
                       objString := StringView,
                       zeroMorph := zeroMorph,
                       addMorph := addMorph,
                       negateMorph := negateMorph,
                       zeroObj := TrivialSubspace( K ),
                       directSum := directSum,
                       kernel := kernel,
                       cokernel := cokernel,
                       kernelFactorization := kernelFactorization,
                       cokernelFactorization := cokernelFactorization );

    return AbelianCat( [ "Vec", K ],
                       Concatenation( "Vec(", String( K ), ")" ),
                       properties );

end );
