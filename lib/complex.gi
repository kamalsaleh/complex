#######################################################################
##
#F  FiniteComplex( <cat>, <basePosition>, <differentials> ) 
##
##  This function returns a finite complex with objects in <cat>.  The
##  differentials are given in the list <differentials> = [d1, ..., dN],
##  an <basePosition> is some integer i. The returned complex has the 
##  map d1 from degree (i) to degree (i-1).
##  
InstallGlobalFunction( FiniteComplex,
function( cat, basePosition, differentials )
    return Complex( cat, basePosition, differentials, "zero", "zero" );
end );

#######################################################################
##
#F  ZeroComplex( <cat> ) 
##
##  Returns the complex in which all objects are the zero object in
##  <cat>.
##  
InstallGlobalFunction( ZeroComplex,
function( cat )
    local fam, C;
    fam := NewFamily( "ComplexesFamily", IsComplex );
    fam!.cat := cat;
    C := Objectify( NewType( fam, IsZeroComplex and IsComplexDefaultRep ),
                    rec( ) );
    SetCatOfComplex( C, cat );
    SetDifferentialsOfComplex( C, ConstantInfList( cat.zeroMap( cat.zeroObj, cat.zeroObj ) ) );
    return C;
end );

#######################################################################
##
#F  StalkComplex( <cat>, <obj>, <degree> ) 
##
##  Returns the stalk complex with the object <obj> from <cat> in
##  degree <degree>.
##  
InstallGlobalFunction( StalkComplex,
function( cat, obj, degree )
    return FiniteComplex( cat, degree,
                          [ cat.zeroMap( obj, cat.zeroObj ),
                            cat.zeroMap( cat.zeroObj, obj ) ] );
end );

#######################################################################
##
#F  ShortExactSequence( <cat>, <f>, <g> ) 
##
##  Returns a complex with three non-zero consecutive objects, and zero
##  objects elsewhere, such that the complex is exact: The image of <f>
##  should be the kernel of <g>, and <f> should be injective, and <g>
##  should be surjective. The function checks that this is the case, 
##  and returns an error otherwise.
##  
InstallGlobalFunction( ShortExactSequence,
function( cat, f, g )
    local SES;
    SES := FiniteComplex( cat, 0, [ g, f ] );
    if not IsShortExactSequence( SES ) then
        Error( "not exact\n" );
    fi;
    return SES;
end );

#######################################################################
##
#F  Complex( <cat>, <basePosition>, <middle>, <positive>, <negative> ) 
##
##  Constructs a complex, not necessarily finite, from the given data.
##  See the QPA manual for detailed information on the input data.
##  
InstallGlobalFunction( Complex,
function( cat, basePosition, middle, positive, negative )
    local checkDifferentials, checkDifferentialList, checkDifferentialListWithRepeat,
          positiveRepeat, negativeRepeat,
          fam, C, basePositionL, middleL, positiveL, negativeL,
          firstMiddleObj, lastMiddleObj, checkNewDifferential;

    # check that all consecutive differentials compose to zero
    checkDifferentials := function( topDegree, indices, lists, listNames )
        local degrees, diffs, diffNames;
        degrees := [ topDegree, topDegree - 1 ];
        diffs := List( [1,2], i -> lists[ i ][ indices[ i ] ] );
        diffNames := List( [1,2], i -> Concatenation(
          "differential ", String( degrees[ i ] ),
          " (element ", String( indices[ i ] ), " in ", String( listNames[ i ] ), " list)" ) );
        if Range( diffs[ 1 ] ) <> Source( diffs[ 2 ] ) then
            Error( "range of ", diffNames[ 1 ], " is not the same as source of ",
                   diffNames[ 2 ], ".\n" );
        fi;
        if not cat.isZeroMapping( cat.composeMaps( diffs[ 2 ], diffs[ 1 ] ) ) then
            Error( "non-zero composition of ", diffNames[ 2 ],
                   " and ", diffNames[ 1 ], ".\n" );
        fi;
    end;

    checkDifferentialList := function( list, startDegree, listName )
        local i;
        for i in [ 2 .. Length( list ) ] do
            checkDifferentials( startDegree + i - 1,
                                [ i, i - 1 ],
                                [ list, list ],
                                [ listName, listName ] );
        od;
    end;

    checkDifferentialListWithRepeat := function( list, startDegree, listName,
                                                 repeatDirection )
                                       checkDifferentialList( list, startDegree, listName );
        checkDifferentials( startDegree + Length( list ) * repeatDirection,
                            [ 1, Length( list ) ],
                            [ list, list ], [ listName, listName ] );
    end;

    checkDifferentialList( middle, basePosition, "middle" );
    if positive[ 1 ] = "repeat" then
        positiveRepeat := positive[ 2 ];
        checkDifferentialListWithRepeat( positiveRepeat, basePosition + Length( middle ),
                                         "positive", 1 );
        if Length( middle ) > 0 then
            checkDifferentials( basePosition + Length( middle ),
                                [ 1, Length( middle ) ],
                                [ positiveRepeat, middle ],
                                [ "positive", "middle" ] );
        fi;
    fi;
    if negative[ 1 ] = "repeat" then
        negativeRepeat := Reversed( negative[ 2 ] );
        checkDifferentialListWithRepeat( negativeRepeat, basePosition + Length( middle ),
                                         "negative", 1 );
        if Length( middle ) > 0 then
            checkDifferentials( basePosition,
                                [ 1, Length( negativeRepeat ) ],
                                [ middle, negativeRepeat ],
                                [ "middle", "negative" ] );
        fi;
    fi;
    if positive[ 1 ] = "repeat" and negative[ 1 ] = "repeat" and Length( middle ) = 0 then
        checkDifferentials( basePosition,
                            [ 1, Length( negativeRepeat ) ],
                            [ positiveRepeat, negativeRepeat ],
                            [ "positive", "negative" ] );
    fi;

    # Create the complex object

    fam := NewFamily( "family of complexes", IsComplex );
    fam!.cat := cat;

    C := Objectify( NewType( fam, IsComplex and IsComplexDefaultRep ),
                    rec( ) );
    SetCatOfComplex( C, cat );

    # Normalize middle list if positive or negative is zero

    basePositionL := basePosition;
    middleL := middle;
    if positive = "zero" or negative = "zero" then
        firstMiddleObj := Range( middle[ 1 ] );
        lastMiddleObj := Source( middle[ Length( middle ) ] );
    fi;
    if positive = "zero" then
        # add zero object at the end if necessary:
        if not cat.isZeroObj( lastMiddleObj ) then
            middleL := Concatenation( middleL,
                                      [ cat.zeroMap( cat.zeroObj, lastMiddleObj ) ] );
        fi;
        # cut away superfluous zero objects:
        while cat.isZeroObj( Range( middleL[ Length( middleL ) ] ) ) do
            middleL := middleL{ [ 1 .. Length( middleL ) - 1 ] };
        od;
    fi;
    if negative = "zero" then
        # add zero object at the end if necessary:
        if not cat.isZeroObj( lastMiddleObj ) then
            middleL := Concatenation( [ cat.zeroMap( firstMiddleObj, cat.zeroObj ) ],
                                      middleL );
            basePositionL := basePositionL - 1;
        fi;
        # cut away superfluous zero objects:
        while cat.isZeroObj( Source( middleL[ 1 ] ) ) do
            middleL := middleL{ [ 2 .. Length( middleL ) ] };
            basePositionL := basePositionL + 1;
        od;
    fi;

    if positive = "zero" then
        positiveL := [ "repeat", [ cat.zeroMap( cat.zeroObj, cat.zeroObj ) ] ];
    elif positive[ 1 ] = "pos" then
        positiveL := ShallowCopy( positive );
        positiveL[ 2 ] := function( i )
            return positive[ 2 ]( C, i );
        end;
    else
        positiveL := positive;
    fi;
    if negative = "zero" then
        negativeL := [ "repeat", [ cat.zeroMap( cat.zeroObj, cat.zeroObj ) ] ];
    elif negative[ 1 ] = "pos" then
        negativeL := ShallowCopy( negative );
        negativeL[ 2 ] := function( i )
            return negative[ 2 ]( C, i );
        end;
    else
        negativeL := negative;
    fi;
            
    checkNewDifferential := function( i, dir, type )
        local degrees, diffs;
        if dir = 1 then
            degrees := [ i - 1, i ];
        else
            degrees := [ i, i + 1 ];
        fi;
        diffs := [ DifferentialOfComplex( C, degrees[ 1 ] ),
                   DifferentialOfComplex( C, degrees[ 2 ] ) ];
        if Source( diffs[ 1 ] ) <> Range( diffs[ 2 ] ) then
            Error( "source of differential ", degrees[ 1 ],
                   " is not the same as range of differential ",
                   degrees[ 2 ], " in complex\n   ", C, "\n" );
        fi;
        if not cat.isZeroMapping( cat.composeMaps( diffs[ 1 ], diffs[ 2 ] ) ) then
            Error( "nonzero composition of differentials ", degrees[ 1 ],
                   " and ", degrees[ 2 ], " in complex\n   ", C, "\n" );
        fi;
    end;

    SetDifferentialsOfComplex( C,
                               MakeInfList( basePositionL, middleL, positiveL, negativeL,
                                            checkNewDifferential ) );

    return C;

end );

#######################################################################
##
#M  DifferentialOfComplex( <C>, <i> ) 
##
##  Returns the differential in degree <i> of the complex <C>.
##  
InstallMethod( DifferentialOfComplex,
[ IsComplex, IsInt ],
function( C, i )
    return DifferentialsOfComplex( C )^i;
end );

#######################################################################
##
#M  ObjectOfComplex( <C>, <i> ) 
##
##  Returns the object in degree <i> of the complex <C>.
##  
InstallMethod( ObjectOfComplex,
[ IsComplex, IsInt ],
function( C, i )
    return Source( DifferentialOfComplex( C, i ) );
end );

#######################################################################
##
#M  \^( <C>, <i> ) 
##
##  Is this in use??
##  
InstallMethod( \^,
[ IsComplex, IsInt ],
function( C, i )
    return DifferentialOfComplex( C, i );
end );

#######################################################################
##
#M  CyclesOfComplex( <C>, <i> ) 
##
##  For a complex <C> and an integer <i>. Returns the i-cycle of the
##  complex, that is the subobject Ker(d_i) of the object in degree i.
##  
InstallMethod( CyclesOfComplex,
[ IsComplex, IsInt ],
function( C, i )
    return Kernel( DifferentialOfComplex( C, i ) );
end );

#######################################################################
##
#M  BoundariesOfComplex( <C>, <i> ) 
##
##  For a complex <C> and an integer <i>. Returns the i-boundary of the
##  complex, that is the subobject Im(d_{i+1}) of the object in degree i.
##  
InstallMethod( BoundariesOfComplex,
[ IsComplex, IsInt ],
function( C, i )
    return Image( DifferentialOfComplex( C, i + 1 ) );
end );

#######################################################################
##
#M  HomologyOfComplex( <C>, <i> ) 
##
##  For a complex <C> and an integer <i>. Returns the ith homology of 
##  the complex.
##
##  TODO: Does not currently work (see the documentation).
##  
InstallMethod( HomologyOfComplex, # TODO: this does not work
[ IsComplex, IsInt ],
function( C, i )
    return CyclesOfComplex( C, i ) / BoundariesOfComplex( C, i );
end );

#######################################################################
##
#M  IsFiniteComplex( <C> ) 
##
##  Returns true if the complex <C> is a finite complex, false otherwise.
##  
InstallMethod( IsFiniteComplex,
[ IsComplex ],
function( C )
    local upbound, lowbound;

    upbound := UpperBound( C );
    lowbound := LowerBound( C );

    if IsZeroComplex( C ) then
        return true;
    elif IsInt( upbound ) and IsInt( lowbound ) then
        return true;
    elif IsInfiniteNumber( upbound ) or IsInfiniteNumber( lowbound ) then
        return false;
    else
        return fail;
    fi;
end );

#######################################################################
##
#M  LengthOfComplex( <C> ) 
##
##  Returns the length of the complex <C>. If C is a zero complex, then
##  the length is zero. If C is a finite complex, the length is the
##  upper bound - the lower bound + 1. If C is an infinite complex, the
##  lenght is infinity.
##  
InstallMethod( LengthOfComplex,
[ IsComplex ],
function( C )
    local finiteness;
    finiteness := IsFiniteComplex( C );
    if IsZeroComplex( C ) then
        return 0;
    elif finiteness = true then
        return UpperBound( C ) - LowerBound( C ) + 1;
    elif finiteness = false then
        return PositiveInfinity;
    else
        return fail;
    fi;
end );

#######################################################################
##
#M  HighestKnownDegree( <C> ) 
##
##  Returns the greatest integer i such that the object at position i 
##  is known (or computed). For a finite complex, this will be infinity.
##  
InstallMethod( HighestKnownDegree,
[ IsComplex ],
function( C )
    return HighestKnownPosition( DifferentialsOfComplex( C ) );
end );

#######################################################################
##
#M  LowestKnownDegree( <C> ) 
##
##  Returns the smallest integer i such that the object at position i 
##  is known (or computed). For a finite complex, this will be negative
##  infinity.
##  
InstallMethod( LowestKnownDegree,
[ IsComplex ],
function( C )
    return LowestKnownPosition( DifferentialsOfComplex( C ) );
end );

#######################################################################
##
#M  IsExactSequence( <C> ) 
##
##  True if the complex <C> is exact in every degree. If the complex
##  is not finite and not repeating, the function fails.
##  
InstallMethod( IsExactSequence,
[ IsComplex ],
function( C )
    return ForEveryDegree( C, CatOfComplex( C ).isExact );
end );

#######################################################################
##
#M  IsExactInDegree( <C>, <i> ) 
##
##  Returns true if the complex <C> is exact in degree <i>.
##  
InstallMethod( IsExactInDegree,
[ IsComplex, IsInt ],
function( C, i )
    return CatOfComplex( C ).isExact( DifferentialOfComplex( C, i ),
                                      DifferentialOfComplex( C, i + 1 ) );
end );

#######################################################################
##
#M  IsShortExactSequence( <C> ) 
##
##  Returns true if the complex <C> is exact and has only three non-zero
##  objects, which are consecutive.
##  
InstallMethod( IsShortExactSequence,
[ IsComplex ],
function( C )
    local length;
    length := LengthOfComplex( C );
    if length = fail then return fail; fi;
    if length = 3 then
        return IsExactSequence( C );
    else
        return false;
    fi;
end );

#######################################################################
##
#M  ForEveryDegree( <C>, <func> ) 
##
##  <C> is a complex, and <func> is a function operating on two conse-
##  cutive differentials, returning either true or false.
##
##  Returns true if func(d_i, d_{i+1}) is true for all i. Fails if this
##  is uknown, i.e. if the complex is infinite and not repeating.
##  
InstallMethod( ForEveryDegree, # TODO: misleading name?
[ IsComplex, IsFunction ],
function( C, func )
    local diffs, pos, neg, i;
    diffs := DifferentialsOfComplex( C );
    pos := PositivePart( diffs );
    neg := NegativePart( diffs );
    if not (IsRepeating( PositivePart( diffs ) ) and
            IsRepeating( NegativePart( diffs ) ) ) then
        return fail;
    fi;
    for i in [ StartPosition( neg ) - Length( RepeatingList( neg ) )
               .. StartPosition( pos ) + Length( RepeatingList( pos ) ) ] do
        if not func( diffs^i, diffs^(i+1) ) then
            return false;
        fi;
    od;
    return true;
end );

#######################################################################
##
#M  UpperBound( <C> ) 
##
##  Returns: 
##  If it exists: The smallest integer i such that the object at 
##  position i is non-zero, but for all j > i the object at position j 
##  is zero. If C is not a finite complex, the operation will return 
##  fail or infinity, depending on how C was defined.
##  
InstallMethod( UpperBound,
[ IsComplex ],
function( C )
    local cat, diffs, positive, i;

    cat := CatOfComplex( C );
    diffs := DifferentialsOfComplex( C );
    positive := PositivePart( diffs );

    if IsZeroComplex( C ) then
        return NegativeInfinity;
    elif IsRepeating( positive ) and Length( RepeatingList( positive ) ) = 1
      and cat.isZeroObj( ObjectOfComplex( C, StartPosition( positive ) ) ) then
        i := MiddleEnd( diffs ) - 1;
        while cat.isZeroObj( ObjectOfComplex( C, i ) ) do
            i := i - 1;
            if i < MiddleStart( diffs ) then
                return fail;
            fi;
        od;
        return i;
    elif IsRepeating( positive ) then
        return PositiveInfinity;
    else
        return fail;
    fi;
end );

#######################################################################
##
#M  LowerBound( <C> ) 
##
##  Returns:
##  If it exists: The greatest integer i such that the object at 
##  position i is non-zero, but for all j < i the object at position j 
##  is zero. If C is not a finite complex, the operation will return 
##  fail or negative infinity, depending on how C was defined.
##
InstallMethod( LowerBound,
[ IsComplex ],
function( C )
    local cat, diffs, negative, i;

    cat := CatOfComplex( C );
    diffs := DifferentialsOfComplex( C );
    negative := NegativePart( diffs );

    if IsZeroComplex( C ) then
        return PositiveInfinity;
    elif IsRepeating( negative ) and Length( RepeatingList( negative ) ) = 1
      and cat.isZeroObj( ObjectOfComplex( C, StartPosition( negative ) ) ) then
        i := MiddleStart( diffs );
        while cat.isZeroObj( ObjectOfComplex( C, i ) ) do
            i := i + 1;
            if i > MiddleEnd( diffs ) then
                return fail;
            fi;
        od;
        return i;
    elif IsRepeating( negative ) then
        return NegativeInfinity;
    else
        return fail;
    fi;
end );

#######################################################################
##
#M  IsPositiveRepeating( <C> ) 
##
##  Returns true if the positive part of the differential list of the
##  complex <C> is repeating.
##
InstallMethod( IsPositiveRepeating,
[ IsComplex ],
function( C )
    return IsRepeating( PositivePart( DifferentialsOfComplex( C ) ) );
end );

#######################################################################
##
#M  IsNegativeRepeating( <C> ) 
##
##  Returns true if the negative part of the differential list of the
##  complex <C> is repeating.
##
InstallMethod( IsNegativeRepeating,
[ IsComplex ],
function( C )
    return IsRepeating( NegativePart( DifferentialsOfComplex( C ) ) );
end );

#######################################################################
##
#M  PositiveRepeatDegrees( <C> ) 
##
##  Returns a list describing the positions of the positive repeating
##  differentials.  The returned list is of the form [first .. last], 
##  where 'first' is the smallest degree such that the differential
##  ending there is in the positive repeating part. After the degree 
##  'last', the same differentials start repeating. Fails if
##  IsPositiveRepeating(C) is false.
##
InstallMethod( PositiveRepeatDegrees,
[ IsComplex ],
function( C )
    local positive, first, last;
    positive := PositivePart( DifferentialsOfComplex( C ) );
    if not IsRepeating( positive ) then
        return fail;
    fi;
    first := StartPosition( positive );
    last := first + Length( RepeatingList( positive ) ) - 1;
    return [ first .. last ];
end );

#######################################################################
##
#M  NegativeRepeatDegrees( <C> ) 
##
##  Returns a list describing the positions of the negative repeating
##  differentials.  The returned list is of the form [last .. first], 
##  where 'last' is the greatest degree such that the differential
##  starting there is in the negative repeating part. After the degree 
##  'first', the same differentials start repeating. Fails if
##  IsNegativeRepeating(C) is false.
##
InstallMethod( NegativeRepeatDegrees,
[ IsComplex ],
function( C )
    local negative, first, last;
    negative := NegativePart( DifferentialsOfComplex( C ) );
    if not IsRepeating( negative ) then
        return fail;
    fi;
    first := StartPosition( negative );
    last := first - Length( RepeatingList( negative ) ) + 1;
    return [ last .. first ];
end );

#######################################################################
##
#M  Shift( <C>, <i> ) 
##
##  Returns the complex C[i].  Note that the signs of the differentials
##  change if i is odd.
##
InstallMethod( Shift,
[ IsComplex, IsInt ],
function( C, shift )
    local newDifferentials;

    newDifferentials := Shift( DifferentialsOfComplex( C ), shift );
    if shift mod 2 = 1 then
        newDifferentials := InfList( newDifferentials, d -> -d );
    fi;

    return ComplexByDifferentialList( CatOfComplex( C ), newDifferentials );

end );

#######################################################################
##
#M  ShiftUnsigned( <C>, <i> ) 
##
##  Returns a complex with the same objects as C[i], but with the 
##  differentials of C shifted without changing the signs.  A 'non-
##  algebraic' operation, but useful for manipulating complexes.
##
InstallMethod( ShiftUnsigned,
[ IsComplex, IsInt ],
function( C, shift )
    local newDifferentials;
    
    newDifferentials := Shift( DifferentialsOfComplex( C ), shift );
    return ComplexByDifferentialList( CatOfComplex( C ), newDifferentials );

end );

#######################################################################
##
#M  YonedaProduct( <C1>, <C2> ) 
##
##  <C1> and <C2> are complexes such that the object in degree LowerBound(C)
##  equals the object in degree UpperBound(D).  The returned complex
##  is the Yoneda product of <C1> and <C2> (see the QPA documentation
##  for a more precise definition).
##  
InstallMethod( YonedaProduct,
[ IsComplex, IsComplex ],
function( C1, C2 )
    local cat, lowbound1, upbound2, diff1, diff2, connection, diffs;

    cat := CatOfComplex( C1 );

    lowbound1 := LowerBound( C1 );
    upbound2 := UpperBound( C2 );

    if not IsInt( lowbound1 ) then
        Error( "first argument in Yoneda product must be bounded below" );
    fi;
    if not IsInt( upbound2 ) then
        Error( "second argument in Yoneda product must be bounded above" );
    fi;
    if ObjectOfComplex( C1, lowbound1 ) <> ObjectOfComplex( C2, upbound2 ) then
        Error( "non-compatible complexes for Yoneda product" );
    fi;

    diff1 := Shift( DifferentialsOfComplex( C1 ), lowbound1 - upbound2 + 1 );
    diff2 := DifferentialsOfComplex( C2 );
    connection := cat.composeMaps( C2^upbound2, C1^(lowbound1+1) );

    diffs := InfConcatenation( PositivePartFrom( diff1, upbound2 + 1 ),
                               FiniteInfList( 0, [ connection ] ),
                               NegativePartFrom( diff2, upbound2 - 1 ) );

    return ComplexByDifferentialList( cat, diffs );

end );

#######################################################################
##
#M  GoodTruncationBelow( <C>, <i> ) 
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
    kerinc := KernelInclusion( DifferentialOfComplex( C, i ) );
    newpart := FiniteInfList( i, [ cat.zeroMap( Source(kerinc), cat.zeroObj ),
                                   LiftingInclusionMorphisms( kerinc, DifferentialOfComplex( C, i+1 ) ) ] );
    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-1 );
    newdifflist := InfConcatenation( truncpart, newpart, zeropart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
#M  GoodTruncationAbove( <C>, <i> ) 
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
    local cat, difflist, truncpart, newpart, zeropart, newdifflist, factor, factorinclusion,
          kerinc, factorproj;

    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := NegativePartFrom( difflist, i-1 );
    kerinc := KernelInclusion( DifferentialOfComplex( C, i ) );
    factorproj := CoKernelProjection( kerinc );
    factor := Range( factorproj );
    factorinclusion := cat.zeroMap( factor, ObjectOfComplex( C, i-1 ) ); #TODO
    newpart := FiniteInfList( i, [ factorinclusion, cat.zeroMap( cat.zeroObj, factor ) ] );

    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+2 );
    newdifflist := InfConcatenation( zeropart, newpart, truncpart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

# TODO!
# InstallMethod( GoodTruncation, [ IsComplex, IsInt, IsInt ] );

#######################################################################
##
#M  BrutalTruncationBelow( <C>, <i> ) 
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
    newpart := FiniteInfList( i, [ cat.zeroMap( ObjectOfComplex( C, i), 
                                                cat.zeroObj) ] );
    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-1 );
    newdifflist := InfConcatenation( truncpart, newpart, zeropart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
#M  BrutalTruncationAbove( <C>, <i> ) 
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
    newpart := FiniteInfList( i+1, [ cat.zeroMap( cat.zeroObj,
                                                ObjectOfComplex( C, i )) ] );
    zeropart := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+2 );
    newdifflist := InfConcatenation( zeropart, newpart, truncpart );
    
    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
#M  BrutalTruncation( <C>, <i>, <j> ) 
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
#O  SyzygyTruncation( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> ker(d_i) --> C_i --> C_{i-1} --> ...
##
InstallMethod( SyzygyTruncation, 
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, kernelinc, newpart, kernel,
          zeropart, newdifflist;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := NegativePartFrom( difflist, i );

    kernelinc := KernelInclusion( DifferentialOfComplex( C, i ) );
    kernel := Source( kernelinc );
    newpart := FiniteInfList( i+1, [ kernelinc, 
                                     cat.zeroMap( cat.zeroObj, kernel ) ] );
    zeropart := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+3 );

    newdifflist := InfConcatenation( zeropart, newpart, truncpart );

    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
#O  CosyzygyTruncation( <C>, <i> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> C_i --> C_{i-1} --> cok(d_i) --> 0 --> ...
##
InstallMethod( CosyzygyTruncation, 
[ IsComplex, IsInt ],
function( C, i )
    local cat, difflist, truncpart, newpart,
          zeropart, newdifflist, cokerproj, coker;
    
    cat := CatOfComplex( C );
    difflist := DifferentialsOfComplex( C );
    truncpart := PositivePartFrom( difflist, i );

    cokerproj := CoKernelProjection( DifferentialOfComplex( C, i ) );
    coker := Range( cokerproj );
    newpart := FiniteInfList( i-2, [ cat.zeroMap( coker, cat.zeroObj ),
                                     cokerproj ] );

    zeropart := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i-3 );

    newdifflist := InfConcatenation( truncpart, newpart, zeropart );

    return ComplexByDifferentialList( cat, newdifflist );

end );

#######################################################################
##
#O  SyzygyCosyzygyTruncation( <C>, <i>, <j> ) 
##
##  Suppose that C is a complex
##    ... --> C_{i+1} --> C_i --> C_{i-1} --> ...
##
##  then the function returns the complex
##    ... --> 0 --> ker(d_i) --> C_i --> ... --> C_{j+1} --> cok(d_j) --> 0 --> ...
##
InstallMethod( SyzygyCosyzygyTruncation, 
[ IsComplex, IsInt, IsInt ],
function( C, i, j )
    local cat, difflist, truncpart, newdifflist, cokerproj, coker, 
          kernelinc, kernel, newpart1, zeropart1, newpart2, zeropart2, middlediffs;
    
    if( j > i ) then
        Error( "First input integer must be greater than or equal to the second" );
    fi;

    cat := CatOfComplex( C );

    difflist := DifferentialsOfComplex( C );
    middlediffs := FinitePartAsList( difflist, j, i );
    truncpart := FiniteInfList( j, middlediffs );

    kernelinc := KernelInclusion( DifferentialOfComplex( C, i ) );
    kernel := Source( kernelinc );
    newpart1 := FiniteInfList( i+1, [ kernelinc, 
                                     cat.zeroMap( cat.zeroObj, kernel ) ] );
    zeropart1 := PositivePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  i+3 );


    cokerproj := CoKernelProjection( DifferentialOfComplex( C, j ) );
    coker := Range( cokerproj );
    newpart2 := FiniteInfList( j-2, [ cat.zeroMap( coker, cat.zeroObj ),
                                     cokerproj ] );

    zeropart2 := NegativePartFrom( DifferentialsOfComplex( ZeroComplex( cat ) ),
                                  j-3 );

    newdifflist := InfConcatenation( zeropart1, newpart1, truncpart, 
                                     newpart2, zeropart2 );

    return ComplexByDifferentialList( cat, newdifflist );
  
end );

#######################################################################
##
#O  CutComplexAbove( <C> ) 
##
##  For a bounded below complex C which is stored as an infinite complex,
##  but is known to be finite. Returns the same complex, but represented
##  as a finite complex.
##
InstallMethod( CutComplexAbove,
[ IsComplex ],
function( C )
    local i, obj;
    if (IsInt(UpperBound(C))) then
        return C;
    else
       i := LowerBound(C);
       while true do
           obj := ObjectOfComplex(C, i);
           if (IsZero(DimensionVector(obj))) then
               return BrutalTruncationAbove(C, i-1);
           fi;
           i := i+1;
       od;
   fi;

end );               

#######################################################################
##
#O  CutComplexBelow( <C> ) 
##
##  For a bounded above complex C which is stored as an infinite complex,
##  but is known to be finite. Returns the same complex, but represented
##  as a finite complex.
##
InstallMethod( CutComplexBelow,
[ IsComplex ],
function( C )
    local i, obj;
    if (IsInt(LowerBound(C))) then
        return C;
    else
       i := UpperBound(C);
       while true do
           obj := ObjectOfComplex(C, i);
           if (IsZero(DimensionVector(obj))) then
               return BrutalTruncationBelow(C, i+1);
           fi;
           i := i-1;
       od;
   fi;

end );               

#######################################################################
##
#O  ComplexByDifferentialList( <cat>, <differentials> ) 
##
##  <cat> is a category, and <differentials> is an InfList of
##  differentials.
##  
InstallGlobalFunction( ComplexByDifferentialList,
[ IsCat, IsInfList ],
function( cat, differentials )
    local C, fam;

    fam := NewFamily( "ComplexesFamily", IsComplex );
    fam!.cat := cat;
    C := Objectify( NewType( fam, IsComplex and IsComplexDefaultRep ),
                    rec( ) );
    SetCatOfComplex( C, cat );
    SetDifferentialsOfComplex( C, differentials );
    return C;

end );

#######################################################################
##
#O  PrintObj( <C> ) 
##
##  Prints the zero complex
##  
InstallMethod( PrintObj,
[ IsZeroComplex ],
function( C )
    Print( "0 -> 0" );
end );

#######################################################################
##
#O  PrintObj( <C> ) 
##
##  Prints a non-zero complex
##  
InstallMethod( PrintObj,
[ IsComplex ],
function( C )
    local cat, diffs, i, upbound, lowbound, top, bottom;

    cat := CatOfComplex( C );

    diffs := DifferentialsOfComplex( C );
    upbound := UpperBound( C );
    lowbound := LowerBound( C );
    if IsInt( upbound ) then
        top := MiddleEnd( diffs ) - 1;
    elif IsPositiveRepeating( C ) then
        top := MiddleEnd( diffs );
    else
        top := HighestKnownDegree( C );
    fi;
    if IsNegativeRepeating( C ) then
        bottom := MiddleStart( diffs );
    else
        bottom := LowestKnownDegree( C );
    fi;
    
    if IsInt( upbound ) then
        Print( "0 -> " );
    else
        Print( "--- -> " );
    fi;

    if IsPositiveRepeating( C ) and upbound = PositiveInfinity then
        Print( "[ " );
        for i in Reversed( PositiveRepeatDegrees( C ) ) do
            Print( i, ":", cat.objStr( ObjectOfComplex( C, i ) ), " -> " );
        od;
        Print( "] " );
    fi;

    for i in [ top, top - 1 .. bottom ] do
        Print( i, ":", cat.objStr( ObjectOfComplex( C, i ) ), " -> " );
    od;

    if IsNegativeRepeating( C ) and lowbound = NegativeInfinity then
        Print( "[ " );
        for i in Reversed( NegativeRepeatDegrees( C ) ) do
            Print( i, ":", cat.objStr( ObjectOfComplex( C, i ) ), " -> " );
        od;
        Print( "] " );
    fi;

    if IsInt( lowbound ) then
        Print( "0" );
    else
        Print( "---" );
    fi;
end );

#######################################################################
##
#O  ProjectiveResolution( <M> ) 
##
##  Returns the projective resolution of M, including M in degree -1.
##  
InstallMethod( ProjectiveResolution,
[ IsPathAlgebraMatModule ],
function( M )
    local nextDifferential, cover;

    nextDifferential := function( d )
        return ProjectiveCover( Kernel( d ) ) * KernelInclusion( d );
    end;

    cover := ProjectiveCover( M );

    return Complex( CatOfRightAlgebraModules( ActingAlgebra( M ) ),
                    0,
                    [ cover ],
                    [ "next", nextDifferential, cover ],
                    "zero" );
end );
