
#######################################################################
##
##  GoodTruncationBelow( <C>, <i> ) 
##
##  Not working at the moment.  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function should return the complex
##    ... --> C_{i+1} --> Z_i --> 0 --> 0 --> ...
##
##  where Z_i is the i-cycle of C.
##  
InstallMethod( GoodTruncationBelow,
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart, zeropart, newdifflist, kerinc;

    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := PositivePartFrom( difflist, i+2 );
    kerinc := KernelOfMorphism( cat, DifferentialOfComplex( C, i ) );
    newpart := FiniteInfList( i, [ ZeroMorphism( cat, DomainOfMorphism( cat, kerinc ), ZeroObject( cat ) ),
                                   KernelFactorization( cat, DifferentialOfComplex( C, i ), DifferentialOfComplex( C, i+1 ) ) ] );
    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-1 );
    newdifflist := InfConcatenation( truncpart, newpart, zeropart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  GoodTruncationAbove( <C>, <i> ) 
##
##  Not working at the moment.  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function should return the complex
##    ... --> 0 --> C_i/Z_i --> C_{i-1} --> 0 --> ...
##
##  where Z_i is the i-cycle of C.
##  
InstallMethod( GoodTruncationAbove,
 [ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart, zeropart, newdifflist, factorinclusion,
          zeromap, kerinc;

    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := NegativePartFrom( difflist, i-1 );
    kerinc := KernelOfMorphism( cat, DifferentialOfComplex( C, i ) );
    factorinclusion := CokernelFactorization( cat, kerinc, DifferentialOfComplex( C, i ) );
    zeromap := ZeroMorphism( cat, ZeroObject( cat ), DomainOfMorphism( cat, factorinclusion ) );
    newpart := FiniteInfList( i, [ factorinclusion, zeromap ] );
    zeropart := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+2 );
    newdifflist := InfConcatenation( zeropart, newpart, truncpart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  GoodTruncation( <C>, <i>, <j> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> C_i --> C_{i-1} --> ... --> C_j --> 0 --> ...
##
InstallMethod( GoodTruncation, 
[ IsComplex, IsInt, IsInt ],
function( C, i, j )
    local cat, difflist, middlediffs, truncpart, newpart1, zeropart1, 
          newpart2, zeropart2, newdifflist;
    
    if( j > i ) then
        Error( "First input integer must be greater than or equal to the second" );
    fi;
    
    if( i = j ) then
        return ZeroComplex( CatOfComplex( C ) );
    fi;
    return GoodTruncationAbove( GoodTruncationBelow( C, j ), i );
end );

#######################################################################
##
##  BrutalTruncationBelow( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> C_{i+1} --> C_i --> 0 --> 0 --> ...
##
InstallMethod( BrutalTruncationBelow,
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart, zeropart, newdifflist;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := PositivePartFrom( difflist, i+1 );
    newpart := FiniteInfList( i, [ ZeroMorphism( cat,
                                                 ObjectOfComplex( C, i), 
                                                 ZeroObject( cat )) ] );
    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-1 );
    newdifflist := InfConcatenation( truncpart, newpart, zeropart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  BrutalTruncationAbove( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> C_i --> C_{i-1} --> 
##
InstallMethod( BrutalTruncationAbove,
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart, zeropart, newdifflist;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := NegativePartFrom( difflist, i );
    newpart := FiniteInfList( i+1, [ ZeroMorphism( cat,
                                                   ZeroObject( cat ),
                                                   ObjectOfComplex( C, i )) ] );
    zeropart := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+2 );
    newdifflist := InfConcatenation( zeropart, newpart, truncpart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  BrutalTruncation( <C>, <i>, <j> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> C_i --> C_{i-1} --> ... --> C_j --> 0 --> ...
##
InstallMethod( BrutalTruncation, 
[ IsComplex, IsInt, IsInt ],
function( C, i, j )
    local cat, difflist, middlediffs, truncpart, newpart1, zeropart1, 
          newpart2, zeropart2, newdifflist;
    
    if( j > i ) then
        Error( "First input integer must be greater than or equal to the second" );
    fi;
    
    return BrutalTruncationAbove( BrutalTruncationBelow( C, j ), i );
end );

#######################################################################
##
##  KernelTruncation( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> ker(d_i) --> C_i --> C_{i-1} --> ...
##
InstallMethod( KernelTruncation, 
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, kernelinc, newpart, kernel,
          zeropart, newdifflist;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := NegativePartFrom( difflist, i );
    
    kernelinc := KernelOfMorphism( cat, DifferentialOfComplex( C, i ) );
    kernel := DomainOfMorphism( cat, kernelinc );
    newpart := FiniteInfList( i+1, [ kernelinc, 
                                     ZeroMorphism( cat, ZeroObject( cat ), kernel ) ] );
    zeropart := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+3 );

    newdifflist := InfConcatenation( zeropart, newpart, truncpart );

    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  CokernelTruncation( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> C_i --> C_{i-1} --> cok(d_i) --> 0 --> ...
##
InstallMethod( CokernelTruncation, 
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart,
          zeropart, newdifflist, cokerproj, coker;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := PositivePartFrom( difflist, i );

    cokerproj := CokernelOfMorphism( cat, DifferentialOfComplex( C, i ) );
    coker := CodomainOfMorphism( cat, cokerproj );
    newpart := FiniteInfList( i-2, [ ZeroMorphism( cat, coker, ZeroObject( cat ) ),
                                     cokerproj ] );

    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-3 );

    newdifflist := InfConcatenation( truncpart, newpart, zeropart );

    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
##  KernelCokernelTruncation( <C>, <i>, <j> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> ker(d_i) --> C_i --> ... --> C_{j+1} --> cok(d_j) --> 0 --> ...
##
InstallMethod( KernelCokernelTruncation, 
[ IsComplex, IsInt, IsInt ],
function( C, i, j )
    local cat, difflist, truncpart, newdifflist, cokerproj, coker, 
          kernelinc, kernel, newpart1, zeropart1, newpart2, zeropart2, middlediffs;
    
    if( j > i ) then
        Error( "First input integer must be greater than or equal to the second" );
    fi;

    return KernelTruncation( CokernelTruncation ( C, j ), i );
    
end );
