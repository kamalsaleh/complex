#######################################################################
##
#F  ChainMap( <M>, <v> ) 
##
##  TODO: documentation for all chain map-functions
##  
InstallGlobalFunction( "ChainMap",
function( source, range, basePosition, middle, positive, negative )
    local cat, fam, map, positiveL, negativeL, numZeroMaps, i,
          correctDomainAt, correctCodomainAt, commutesAt,
          checkDomainAndCodomain, checkCommutes, checkNewMorphism,
          morphisms, firstCheckDegree, lastCheckDegree;

    cat := CatOfComplex( source );
    if cat <> CatOfComplex( range ) then
        Error( "source and range of chain map must be complexes over the same cat" );
    fi;

    fam := NewFamily( "ChainMapsFamily", IsChainMap );
    map := Objectify( NewType( fam, IsChainMap and IsChainMapDefaultRep ),
                      rec( ) );

    SetSource( map, source );
    SetRange( map, range );

    if positive = "zero" then
        positiveL := [ "pos",
                       i -> ZeroMorphism( cat,
                                          ObjectOfComplex( source, i ),
                                          ObjectOfComplex( range, i ) ),
                       false ];
    elif positive[ 1 ] = "pos" then
        positiveL := ShallowCopy( positive );
        positiveL[ 2 ] := function( i )
            return positive[ 2 ]( map, i );
        end;
    else
        positiveL := positive;
    fi;
    if negative = "zero" then
        negativeL := [ "pos",
                       i -> ZeroMorphism( cat,
                                          ObjectOfComplex( source, i ),
                                          ObjectOfComplex( range, i ) ),
                       false ];
    elif negative[ 1 ] = "pos" then
        negativeL := ShallowCopy( negative );
        negativeL[ 2 ] := function( i )
            return negative[ 2 ]( map, i );
        end;
    else
        negativeL := negative;
    fi;

    # if positive = "zero" then
    #     numZeroMaps := 0;
    #     for i in [ Length( middle ), Length( middle ) - 1 .. 1 ] do
    #         if cat.isZeroMapping( middle[ i ] ) then
    #             numZeroMaps := numZeroMaps + 1;
    #         else
    #             break;
    #         fi;
    #     od;
    #     SetUpperBound( map, basePosition + Length( middle ) - 1 - numZeroMaps );
    # fi;
    # if negative = "zero" then
    #     numZeroMaps := 0;
    #     for i in [ 1 .. Length( middle ) ] do
    #         if cat.isZeroMapping( middle[ i ] ) then
    #             numZeroMaps := numZeroMaps + 1;
    #         else
    #             break;
    #         fi;
    #     od;
    #     SetLowerBound( map, basePosition + numZeroMaps );
    # fi;

    correctDomainAt := function( i )
        return Source( map^i ) = ObjectOfComplex( source, i );
    end;
    correctCodomainAt := function( i )
        return Range( map^i ) = ObjectOfComplex( range, i );
    end;

    commutesAt := function( i )
        return Compose( cat, range^i, map^i ) = Compose( cat, map^(i-1), source^i );
    end;

    checkDomainAndCodomain := function( i )
        if not correctDomainAt( i ) then
            Error( "incorrect source of chain map morphism in degree ", i, "\n" );
        fi;
        if not correctCodomainAt( i ) then
            Error( "incorrect range of chain map morphism in degree ", i, "\n" );
        fi;
    end;

    checkCommutes := function( i )
        if not commutesAt( i ) then
            Error( "chain map morphisms at degrees (", i, ",", i-1, ") ",
                   "do not commute with complex differentials\n" );
        fi;
    end;

    checkNewMorphism := function( i, dir, type )
        local topDegreeOfNewSquare;
        if dir = 1 then
            topDegreeOfNewSquare := i;
        else
            topDegreeOfNewSquare := i + 1;
        fi;
        checkDomainAndCodomain( i );
        checkCommutes( topDegreeOfNewSquare );
    end;

    morphisms := MakeInfList( basePosition, middle, positiveL, negativeL,
                              checkNewMorphism );
    SetMorphismsOfChainMap( map, morphisms );

    # for i in [ LowestKnownDegree( map ) .. HighestKnownDegree( map ) ] do
    #     checkDomainAndCodomain( i );
    # od;
    # for i in [ LowestKnownDegree( map ) + 1 .. HighestKnownDegree( map ) ] do
    #     checkCommutes( i );
    # od;

    # TODO: hvor mye som må sjekkes (må se på kompleksene)
    if IsRepeating( NegativePart( morphisms ) ) then
        firstCheckDegree := StartPosition( NegativePart( morphisms ) )
                            - Length( RepeatingList( NegativePart( morphisms ) ) );
    else
        firstCheckDegree := MiddleStart( morphisms );
    fi;
    if IsRepeating( PositivePart( morphisms ) ) then
        lastCheckDegree := StartPosition( PositivePart( morphisms ) )
                           + Length( RepeatingList( PositivePart( morphisms ) ) );
    else
        lastCheckDegree := MiddleEnd( morphisms );
    fi;
    for i in [ firstCheckDegree .. lastCheckDegree ] do
        checkDomainAndCodomain( i );
    od;
    for i in [ firstCheckDegree + 1 .. lastCheckDegree ] do
        checkCommutes( i );
    od;

    return map;

end );

#######################################################################
##
#O  HighestKnownDegree( <map> ) 
##
##  Returns the highest degree that has been computed (or is otherwise
##  known) of the chain map <map>.  
##  
InstallMethod( HighestKnownDegree,
[ IsChainMap ],
function( map )
    return HighestKnownPosition( MorphismsOfChainMap( map ) );
end );

#######################################################################
##
#O  LowestKnownDegree( <map> ) 
##
##  Returns the lowest degree that has been computed (or is otherwise)
##  known) of the chain map <map>.
##  
InstallMethod( LowestKnownDegree,
[ IsChainMap ],
function( map )
    return LowestKnownPosition( MorphismsOfChainMap( map ) );
end );

#######################################################################
##
#O  MorphismOfChainMap( <map>, <i> ) 
##
##  Returns the morhpism in degree <i> of the map <map>.
##  
InstallMethod( MorphismOfChainMap,
[ IsChainMap, IsInt ],
function( map, i )
    return MorphismsOfChainMap( map )^i;
end );

#######################################################################
##
#O  \^( <map>, <i> ) 
##
##  Returns the morphism in degree <i> of the map <map>.
##  
InstallMethod( \^,
[ IsChainMap, IsInt ],
function( map, i )
    return MorphismsOfChainMap( map )^i;
end );

#######################################################################
##
#O  PrintObj( <map> ) 
##
##  Prints the chain map <map>.
##  
InstallMethod( PrintObj,
[ IsChainMap ],
function( map )
    Print( "<chain map>" );
end );

#######################################################################
##
#F  ComplexAndChainMAps( <sourceComplexes>, <rangeComplexes>,
##                       <basePosition>, <middle>, <positive>,
##                       <negative> ) 
##
##  Returns a list consisting of a newly created complex, togeher with
##  one or more newly created chain maps.  The new complex is either
##  source or range for the new chain map(s).
##
##  <sourceComplexes> is a list of the complexes to be sources of the
##  chain maps which will have the new complex as range.  Similarly,
##  <rangeComplexes> is a list of the complexes to be ranges of the new
##  chain maps which will have the new complex as source.
##  
InstallGlobalFunction( ComplexAndChainMaps,
function( sourceComplexes, rangeComplexes,
          basePosition, middle, positive, negative )

    local cat, C, inMaps, outMaps, numInMaps, numOutMaps,
          positiveL, negativeL, list,
          positiveDiffs, positiveInMaps, positiveOutMaps,
          negativeDiffs, negativeInMaps, negativeOutMaps,
          middleDiffs, middleInMaps, middleOutMaps;

    cat := CatOfComplex( Concatenation( sourceComplexes, rangeComplexes )[ 1 ] );

    if positive = "zero" then
        positiveL := [ "repeat", [ fail ] ];
    elif positive[ 1 ] = "pos" then
        positiveL := ShallowCopy( positive );
        positiveL[ 2 ] := function( i )
            return CallFuncList( positive[ 2 ],
                                 Concatenation( [ C ], inMaps, outMaps, [ i ] ) );
        end;
    else
        positiveL := positive;
    fi;
    if negative = "zero" then
        negativeL := [ "repeat", [ fail ] ];
    elif negative[ 1 ] = "pos" then
        negativeL := ShallowCopy( negative );
        negativeL[ 2 ] := function( i )
            return CallFuncList( negative[ 2 ],
                                 Concatenation( [ C ], inMaps, outMaps, [ i ] ) );
        end;
    else
        negativeL := negative;
    fi;

    list := MakeInfList( basePosition, middle, positiveL, negativeL, false );

    numInMaps := Length( sourceComplexes );
    numOutMaps := Length( rangeComplexes );

    if positive = "zero" then
        positiveDiffs := "zero";
        positiveInMaps := List( [ 1 .. numInMaps ], i -> "zero" );
        positiveOutMaps := List( [ 1 .. numOutMaps ], i -> "zero" );
    else
        positiveDiffs := [ "pos",
                           function( C, i ) return \^(list, i)[ 1 ]; end ];
        positiveInMaps :=
          List( [ 1 .. numInMaps ],
                i -> [ "pos", function( map, pos ) return \^(list, pos)[ 1 + i ]; end ] );
        positiveOutMaps :=
          List( [ 1 .. numOutMaps ],
                i -> [ "pos", function( map, pos )
                                 return  \^(list, pos)[ 1 + numInMaps + i ]; end ] );
    fi;
    if negative = "zero" then
        negativeDiffs := "zero";
        negativeInMaps := List( [ 1 .. numInMaps ], i -> "zero" );
        negativeOutMaps := List( [ 1 .. numOutMaps ], i -> "zero" );
    else
        negativeDiffs := [ "pos", function( C, i ) return \^(list, i)[ 1 ]; end ];
        negativeInMaps :=
          List( [ 1 .. numInMaps ],
                i -> [ "pos", function( map, pos ) return \^(list, pos)[ 1 + i ]; end ] );
        negativeOutMaps :=
          List( [ 1 .. numOutMaps ],
                i -> [ "pos", function( map, pos )
                                 return \^(list, pos)[ 1 + numInMaps + i ]; end ] );
    fi;

    middleDiffs := List( middle, L -> L[ 1 ] );
    middleInMaps := List( [ 1 .. numInMaps ],
                          i -> List( middle, L -> L[ 1 + i ] ) );
    middleOutMaps := List( [ 1 .. numOutMaps ],
                           i -> List( middle, L -> L[ 1 + numInMaps + i ] ) );

    C := Complex( cat, basePosition, middleDiffs, positiveDiffs, negativeDiffs );
    inMaps := List( [ 1 .. numInMaps ],
                    i -> ChainMap( sourceComplexes[ i ],
                                   C,
                                   basePosition,
                                   middleInMaps[ i ],
                                   positiveInMaps[ i ],
                                   negativeInMaps[ i ] ) );
    outMaps := List( [ 1 .. numOutMaps ],
                     i -> ChainMap( C,
                                    rangeComplexes[ i ],
                                    basePosition,
                                    middleOutMaps[ i ],
                                    positiveOutMaps[ i ],
                                    negativeOutMaps[ i ] ) );

    return Concatenation( [ C ], inMaps, outMaps );
                       
end );
