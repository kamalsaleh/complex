# This file should be renamed an moved to the QPA package in due time …

createrepQI := function( alg )
    local properties, objInCat, morphInCat, compose, isIsomorphism, inverse,
          isomorphic, isomorphism, zeroMorph, addMorph, negateMorph,
          direkteSum, kernel, cokernel,
          kernelFactorization, cokernelFactorization;

    objInCat := function( M )
        return IsPathAlgebraMatModule( M ) and ( RightActingAlgebra( M ) = alg );
    end;

# har kommet hit …
    
    properties := rec( objInCat := objInCat,
                       # morphInCat := morphInCat,
                       # domain := Source,
                       # codomain := Range,
                       # compose := compose,
                       # identityMorph := IdentityMapping,
                       # isIsomorphism := isIsomorphism,
                       # inverse := inverse,
                       # isomorphic := isomorphic,
                       # isomorphism := isomorphism,
                       # zeroMorph := zeroMorph,
                       # addMorph := addMorph,
                       # negateMorph := negateMorph,
                       # zeroObj := TrivialGroup(),
                       # directSum := direkteSum,
                       # kernel := kernel,
                       # cokernel := cokernel,
                       # kernelFactorization := kernelFactorization,
                       # cokernelFactorization := cokernelFactorization );
                       );
    return AbelianCat( [alg, "right modules"], "right modules over algebra", properties );

end;


InstallValue( repQI, createrepQI() );