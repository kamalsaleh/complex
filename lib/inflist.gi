InstallValue( PositiveInfinity,
              Objectify( NewType( FamilyObj(0),
                                  IsInfiniteNumber and IsPositionalObjectRep ),
                         [] ) );

InstallValue( NegativeInfinity,
              Objectify( NewType( FamilyObj(0),
                                  IsInfiniteNumber and IsPositionalObjectRep ),
                         [] ) );

InstallMethod( \=,
    [ IsInfiniteNumber, IsInfiniteNumber ],
    IsIdenticalObj );
InstallMethod( \=,
    [ IsInfiniteNumber, IsObject ],
    ReturnFalse );
InstallMethod( \=,
    [ IsObject, IsInfiniteNumber ],
    ReturnFalse );

InstallMethod( \<,
[ IsInfiniteNumber, IsInt ],
function( infnum, num )
    return infnum = NegativeInfinity;
end );
InstallMethod( \<,
[ IsInt, IsInfiniteNumber ],
function( num, infnum )
        return infnum = PositiveInfinity;
    end );
InstallMethod( \<,
[ IsInfiniteNumber, IsInfiniteNumber ],
function( n1, n2 )
        return n1 = NegativeInfinity and n2 = PositiveInfinity;
    end );

InstallMethod( PrintObj, [ IsInfiniteNumber ],
function( n )
  if n = PositiveInfinity then
    Print( "+inf" );
  else
    Print( "-inf" );
  fi;
end );


BindGlobal( "FamilyOfInfLists",
            NewFamily( "infinite lists" ) );

DeclareRepresentation( "IsInfListRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ "implementation",
                         "users", "derivations",
                         "values",
                         "single_assertions", "double_assertions" ] );

InstallMethod( MakeInfList, [ IsOperation, IsRecord, IsDenseList ],
function( C, obj, attributes )
  local type;
  obj.implementation := fail;
  obj.users := WeakPointerObj( [] );
  obj.derivations := WeakPointerObj( [] );
  obj.single_assertions := [];
  obj.double_assertions := [];
  if not IsBound( obj.values ) then
    obj.values := [];
  fi;
  type := NewType( FamilyOfInfLists, C and IsInfListRep );
  CallFuncList( ObjectifyWithAttributes,
                Concatenation( [ obj, type ], attributes ) );
  return obj;
end );

InstallMethod( \[\], [ IsNList, IsPosInt ],
function( L, i )
  if HasImplementation( L ) then
    return Implementation( L )[ i ];
  else
    return LookupInfList( L, i );
  fi;
end );

InstallMethod( \[\], [ IsZList, IsInt ],
function( L, i )
  if HasImplementation( L ) then
    return Implementation( L )[ i ];
  else
    return LookupInfList( L, i );
  fi;
end );

InstallMethod( HasImplementation, [ IsInfList ],
function( L )
  # (this should never need to be called,
  # since we set HasImplementation in SetImplementation)
  return L!.implementation <> fail;
end );

InstallMethod( Implementation, [ IsInfList and IsInfListRep ],
               GETTER_FLAGS + 1, # to override system getter
function( L )
  return L!.implementation;
end );

InstallMethod( SetImplementation, [ IsInfList, IsInfList ],
function( L, imp )
  local i, u, d;
  Info( InfoInfList, 1,
        "SetImplementation( ", L, ", ", imp, ")" );
  L!.implementation := imp;
  SetFilterObj( L, HasImplementation );
  AddImplementationUser( imp, L );
  for i in [ 1 .. LengthWPObj( L!.users ) ] do
    u := ElmWPObj( L!.users, i );
    if u <> fail and IsIdenticalObj( Implementation( u ), L ) then
      # u is now using L as its implementation, but L got the new implementation imp.
      # Make u bypass L and use imp directly:
      SetImplementation( u, imp );
      UnbindElmWPObj( L!.users, i );
    fi;
  od;
  for i in [ 1 .. LengthWPObj( L!.derivations ) ] do
    d := ElmWPObj( L!.derivations, i );
    if d <> fail then
      ImplementationNotification( d, L );
      UnbindElmWPObj( L!.derivations, i );
    fi;
  od;
end );

InstallMethod( String, [ IsInfList ],
function( L )
  return Concatenation( "8[ ", InfListString( L ), " ]" );
end );

InstallMethod( SetString, [ IsInfList, IsString ],
               function( L, str ) end );
#n
InstallMethod( ViewObj, 
                [ IsInfList ],
   function( l )
   Print( "<An infinite list>" );
end );
##

InstallMethod( AddImplementationUser, [ IsInfList, IsInfList ],
function( L, userL )
  SetElmWPObj( L!.users,
               LengthWPObj( L!.users ) + 1,
               userL );
end );

InstallMethod( AddDerivation, [ IsNList, IsInfList ],
function( L, derL )
  if HasImplementation( L ) then
    ImplementationNotification( derL, L );
  else
    SetElmWPObj( L!.derivations,
                 LengthWPObj( L!.derivations ) + 1,
                 derL );
  fi;
end );

InstallMethod( AddAssertion, [ IsInfList, IsInfListSingleAssertion ],
function( L, A )
  local values, i;
  # remember the assertion for checking values that are computed later:
  Add( L!.single_assertions, A );
  # check the values that have been computed:
  values := L!.values;
  for i in [ 1 .. Length( values ) ] do
    if IsBound( values[ i ] ) then
      CheckAssertion( A, i, values[ i ] );
    fi;
  od;
end );

InstallMethod( AddAssertion, [ IsInfList, IsInfListDoubleAssertion ],
function( L, A )
  local i, values;
  # remember the assertion for checking values that are computed later:
  Add( L!.double_assertions, A );
  # check the values that have been computed:
  values := L!.values;
  for i in [ 1 .. Length( values ) - 1 ] do
    if IsBound( values[ i ] ) and IsBound( values[ i + 1 ] ) then
      CheckAssertion( A, i, values[ i ], values[ i + 1 ] );
    fi;
  od;
end );

InstallMethod( CheckSingleAssertions, [ IsInfList, IsInt, IsObject ],
function( L, i, elem )
  local A;
  for A in L!.single_assertions do
    CheckAssertion( A, i, elem );
  od;
end );

InstallMethod( CheckDoubleAssertions, [ IsInfList, IsInt, IsObject, IsObject ],
function( L, i, elem1, elem2 )
  local A;
  for A in L!.double_assertions do
    CheckAssertion( A, i, elem1, elem2 );
  od;
end );

InstallValue( InfListStringDefaultOptionsN,
              rec( format_value := function( i, v )
                     return String( v );
                   end,
                   separator := ", ",
                   repeat_start_left := "( ",
                   repeat_start_right := " )",
                   repeat_end_left := "*( ",
                   repeat_end_right := " )*",
                   ellipsis := "..." ) );
InstallValue( InfListStringDefaultOptionsZ,
              rec( format_value := function( i, v )
                     return Concatenation( String( i ), ":", String( v ) );
                   end,
                   separator := ", ",
                   repeat_start_left := "( ",
                   repeat_start_right := " )",
                   repeat_end_left := "*( ",
                   repeat_end_right := " )*",
                   ellipsis := "..." ) );

InstallMethod( InfListString, [ IsInfList and HasImplementation ],
function( L )
  return InfListString( Implementation( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList and HasImplementation ],
function( opt, L )
  return InfListString( opt, Implementation( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList and HasImplementation, IsBool ],
function( opt, L, reversed )
  return InfListString( opt, Implementation( L ), reversed );
end );

InstallMethod( InfListString, [ IsNList ],
function( L )
  return InfListString( InfListStringDefaultOptionsN, L );
end );

InstallMethod( InfListString, [ IsZList ],
function( L )
  return InfListString( InfListStringDefaultOptionsZ, L );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList ],
function( opt, L )
  return InfListString( opt, L, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsPosInt ],
function( opt, L, i )
  return InfListString( opt, L, i, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsDenseList ],
function( opt, L, indices )
  return InfListString( opt, L, indices, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsPosInt, IsDenseList ],
function( opt, L, start_index, indices )
  return InfListString( opt, L, start_index, indices, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList, IsBool ],
function( opt, L, reversed )
  return InfListString( opt, L, reversed, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return InfListString( opt, L, 1, reversed, shift, incr );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, Cut( L, i - 1 ), reversed, shift, incr );
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsDenseList, IsBool, IsInt, IsInt ],
function( opt, L, indices, reversed, shift, incr )
  if IsEmpty( indices ) then
    return opt.ellipsis;
  else
    return InfListString( opt, L, indices[ 1 ], indices, reversed, [ shift, incr ] );
  fi;
end );

InstallMethod( InfListString, [ IsRecord, IsNList, IsPosInt, IsDenseList, IsBool, IsDenseList ],
function( opt, L, start_index, indices, reversed, shift_and_incr )
  local shift, incr, str, add_str, add_commas, i, j;
  shift := shift_and_incr[ 1 ];
  incr := shift_and_incr[ 2 ];
  if not IsSSortedList( indices ) or not ForAll( indices, IsPosInt ) then
    Error( "List of indices must be a strictly sorted list of positive integers" );
  fi;
  indices := Filtered( indices, i -> i >= start_index );
  if IsEmpty( indices ) then
    return opt.ellipsis;
  fi;
  str := "";
  add_str := function( s )
    if reversed then
      str := Concatenation( s, str );
    else
      str := Concatenation( str, s );
    fi;
  end;
  add_commas := function( n )
    add_str( Concatenation( RepeatedString( ',', n ), " " ) );
  end;
  if indices[ 1 ] > start_index then
    add_str( opt.ellipsis );
    add_str( opt.separator );
  fi;
  for j in [ 1 .. Length( indices ) - 1 ] do
    i := indices[ j ];
    add_str( opt.format_value( i * incr + shift, L[ i ] ) );
    add_str( opt.separator );
    if indices[ j + 1 ] > 1 + i then
      add_str( opt.ellipsis );
      add_str( opt.separator );
    fi;
  od;
  i := indices[ Length( indices ) ];
  add_str( opt.format_value( i * incr + shift, L[ i ] ) );
  add_str( opt.separator );
  add_str( opt.ellipsis );
  return str;
end );

InstallMethod( \=, [ IsInfList, IsObject ], ReturnFalse );
InstallMethod( \=, [ IsObject, IsInfList ], ReturnFalse );

InstallMethod( InductiveList, [ IsObject, IsFunction ],
function( init, f )
  return InductiveListWithImplementation( init, f, InductiveListImp( init, f ) );
end );

InstallMethod( InductiveListWithImplementation, [ IsObject, IsFunction, IsNList ],
function( init, f, imp )
  return MakeInfList( IsInductiveNListDef,
                      rec( ),
                      [ InitialValue, init,
                        InductionFunction, f,
                        Implementation, imp ] );
end );

InstallMethod( InductiveListImp, [ IsObject, IsFunction ],
function( init, f )
  return MakeInfList( IsInductiveNListImp,
                      rec( values := [ init ] ),
                      [ InitialValue, init,
                        InductionFunction, f ] );
end );

InstallMethod( \=, [ IsInductiveNList, IsInductiveNList ],
function( L1, L2 )
  return InitialValue( L1 ) = InitialValue( L2 )
         and InductionFunction( L1 ) = InductionFunction( L2 );
end );

InstallMethod( LookupInfList, [ IsInductiveNListImp, IsPosInt ],
function( list, i )
  local v, f, l;
  v := list!.values;
  f := InductionFunction( list );
  while i > Length( v ) do
    l := Length( v );
    v[ l + 1 ] := f( v[ l ] );
    CheckSingleAssertions( list, l + 1, v[ l + 1 ] );
    CheckDoubleAssertions( list, l, v[ l ], v[ l + 1 ] );
    if l mod 2 = 1 then
      if v[ l + 1 ] = v[ ( l + 1 ) / 2 ] then
        SetImplementation( list, Repeatify( list, ( l + 1 ) / 2, l + 1 ) );
        return Implementation( list )[ i ];
      fi;
    fi;
  od;
  return v[ i ];
end );

InstallMethod( KnownIndices, [ IsInductiveNListImp ],
function( L )
  return [ 1 .. Length( L!.values ) ];
end );

InstallMethod( InfListString, [ IsRecord, IsInductiveNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  local values, len, str_values;
  values := L!.values;
  len := Length( values );
  if i > len then
    return opt.ellipsis;
  fi;
  str_values := Concatenation( ListN( [ i .. len ] * incr + shift,
                                      values{ [ i .. len ] },
                                      opt.format_value ),
                               [ opt.ellipsis ] );
  if reversed then
    str_values := Reversed( str_values );
  fi;
  return JoinStringsWithSeparator( str_values, opt.separator );
end );

InstallMethod( Repeatify,
               [ IsInductiveNListImp, IsPosInt, IsPosInt ],
function( list, collisionIndex1, collisionIndex2 )
  local values, i1, i2, i, repeatStartIndex, repeatEndIndex,
        tail, repeatedList, newList;
  values := list!.values;
  i1 := collisionIndex1;
  i2 := collisionIndex2;
  while i1 > 0 and values[ i1 ] = values[ i2 ] do
    i1 := i1 - 1;
    i2 := i2 - 1;
  od;
  repeatStartIndex := i1 + 1;
  i := repeatStartIndex + 1;
  while values[ i ] <> values[ repeatStartIndex ] do
    i := i + 1;
  od;
  repeatEndIndex := i - 1;
  tail := values{ [ 1 .. ( repeatStartIndex - 1 ) ] };
  repeatedList := values{ [ repeatStartIndex .. repeatEndIndex ] };
  newList := Concatenate( tail, RepeatListN( repeatedList ) );
  return newList;
end );

InstallMethod( RepeatListN, [ IsDenseList ],
function( list )
  return MakeInfList( IsRepeatingNList,
                      rec(),
                      [ RepeatingList, Unrepeat( list ) ] );
end );

InstallMethod( Unrepeat, [ IsDenseList ],
function( list )
  local n, r, i, ok;
  n := Length( list );
  for r in [ 1 .. QuoInt( n, 2 ) ] do
    if n mod r = 0 and list[ r + 1 ] = list[ 1 ] then
      ok := true;
      for i in [ 0 .. ( n - r - 1 ) ] do
        if list[ r + 1 + i ] <> list[ 1 + i mod r ] then
          ok := false;
          break;
        fi;
      od;
      if ok then
        return list{ [ 1 .. r ] };
      fi;
    fi;
  od;
  return list;
end );

InstallMethod( \=, [ IsRepeatingNList, IsRepeatingNList ],
function( L1, L2 )
  return RepeatingList( L1 ) = RepeatingList( L2 );
end );

InstallMethod( LookupInfList, [ IsRepeatingNList, IsPosInt ],
function( L, i )
  local r, l, v;
  r := RepeatingList( L );
  l := Length( r );
  v := r[ ( ( i - 1 ) mod l ) + 1 ];
  return v;
end );

InstallMethod( KnownIndices, [ IsRepeatingNList ],
function( L )
  return PositiveIntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsRepeatingNList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  local list, str_list, str;
  list := RepeatingList( L );
  str_list := ListN( [ 1 .. Length( list ) ] * incr + shift,
                     list,
                     opt.format_value );
  if reversed then str_list := Reversed( str_list ); fi;
  str := JoinStringsWithSeparator( str_list, opt.separator );
  if reversed then
    return Concatenation( opt.repeat_end_left, str, opt.repeat_start_right );
  else
    return Concatenation( opt.repeat_start_left, str, opt.repeat_end_right );
  fi;
end );

InstallMethod( AddAssertion, [ IsRepeatingNList, IsInfListSingleAssertion ],
function( L, A )
  # can check all assertions immediately, since all the objects are already known
  local i, rep_list;
  rep_list := RepeatingList( L );
  for i in [ 1 .. Length( rep_list ) ] do
    CheckAssertion( A, i, rep_list[ i ] );
  od;
end );

InstallMethod( AddAssertion, [ IsRepeatingNList, IsInfListDoubleAssertion ],
function( L, A )
  local rep_list, n, i;
  rep_list := RepeatingList( L );
  n := Length( rep_list );
  for i in [ 1 .. n - 1 ] do
    CheckAssertion( A, i, rep_list[ i ], rep_list[ i + 1 ] );
  od;
  CheckAssertion( A, n, rep_list[ n ], rep_list[ 1 ] );
end );

InstallMethod( ArithmeticSequenceN, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfList( IsArithmeticNList,
                      rec(),
                      [ InitialValue, init,
                        Increment, incr ] );
end );

InstallMethod( \=, [ IsArithmeticNList, IsArithmeticNList ],
function( L1, L2 )
  return InitialValue( L1 ) = InitialValue( L2 )
         and Increment( L1 ) = Increment( L2 );
end );

InstallMethod( LookupInfList, [ IsArithmeticNList, IsPosInt ],
function( L, i )
  return InitialValue( L ) + ( i - 1 ) * Increment( L );
end );

InstallMethod( KnownIndices, [ IsArithmeticNList ],
function( L )
  return PositiveIntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsArithmeticNList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return InfListString( opt, L, [ 1, 2, 3 ], reversed, shift, incr );
end );

InstallMethod( MakeConcatNList, [ IsDenseList, IsNList ],
function( tail, baseL )
  local L;
  L := MakeInfList( IsConcatNList,
                    rec(),
                    [ BaseList, baseL,
                      ConcatList, tail ] );
  AddDerivation( baseL, L );
  return L;
end );

InstallMethod( \=, [ IsConcatNList, IsNList ],
function( L1, L2 )
  local c, n;
  c := ConcatList( L1 );
  n := Length( c );
  return c = Sublist( L2, 1, n + 1 )
         and BaseList( L1 ) = Cut( L2, n );
end );

InstallMethod( \=, [ IsNList, IsConcatNList ],
function( L1, L2 )
  return L2 = L1;
end );

InstallMethod( \=, [ IsConcatNList, IsConcatNList ],
function( L1, L2 )
  local n1, n2, n;
  n1 := Length( ConcatList( L1 ) );
  n2 := Length( ConcatList( L2 ) );
  n := Maximum( n1, n2 );
  return Sublist( L1, 1, n + 1 ) = Sublist( L2, 1, n + 2 )
         and Cut( L1, n ) = Cut( L2, n );
end );

InstallMethod( Concatenate, [ IsDenseList, IsNList ],
               MakeConcatNList );

InstallMethod( Concatenate, [ IsDenseList, IsConcatNList ],
function( tail, base_list )
  return Concatenate( Concatenation( tail, ConcatList( base_list ) ),
                      BaseList( base_list ) );
end );

InstallMethod( Concatenate, [ IsDenseList and IsEmpty, IsNList ],
function( tail, base_list )
  return base_list;
end );

InstallMethod( Concatenate, [ IsDenseList, IsRepeatingNList ],
function( tail, base_list )
  local rep, rep_len, overlap_len, tail_len;
  rep := RepeatingList( base_list );
  rep_len := Length( rep );
  overlap_len := 0;
  tail_len := Length( tail );
  while overlap_len < tail_len
    and tail[ tail_len - overlap_len ] = rep[ rep_len - overlap_len mod rep_len ] do
    overlap_len := overlap_len + 1;
  od;
  if overlap_len > 0 then
    tail := tail{ [ 1 .. tail_len - overlap_len ] };
    rep := RotateRight( rep, overlap_len );
    return Concatenate( tail, RepeatListN( rep ) );
  else
    return MakeConcatNList( tail, base_list );
  fi;
end );

InstallMethod( ImplementationNotification, [ IsConcatNList, IsNList ],
function( L, BL )
  if ( not HasImplementation( L ) )
     and IsIdenticalObj( BL, BaseList( L ) ) then
    SetImplementation( L, Concatenate( ConcatList( L ),
                                       Implementation( BL ) ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsConcatNList, IsPosInt ],
function( list, i )
  local l, v;
  l := Length( ConcatList( list ) );
  if i <= l then
    return ConcatList( list )[ i ];
  else
    return BaseList( list )[ i - l ];
  fi;
end );

InstallMethod( KnownIndices, [ IsConcatNList ],
function( L )
  local concat_len;
  concat_len := Length( ConcatList( L ) );
  return Concatenation( [ 1 .. concat_len ],
                        KnownIndices( BaseList( L ) ) + concat_len );
end );

InstallMethod( InfListString, [ IsRecord, IsConcatNList, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  local list, str_list, str1, str2;
  list := ConcatList( L );
  str_list := ListN( [ 1 .. Length( list ) ] * incr + shift,
                     list,
                     opt.format_value );
  if reversed then str_list := Reversed( str_list ); fi;
  str1 := JoinStringsWithSeparator( str_list, opt.separator );
  str2 := InfListString( opt, BaseList( L ), reversed, shift + incr * Length( list ), incr );
  if reversed then
    return Concatenation( str2, opt.separator, str1 );
  else
    return Concatenation( str1, opt.separator, str2 );
  fi;
end );

InstallMethod( AddAssertion, [ IsConcatNList, IsInfListSingleAssertion ],
function( L, A )
  local list, n, i;
  list := ConcatList( L );
  n := Length( list );
  AddAssertion( BaseList( L ), Shift( A, n ) );
  for i in [ 1 .. n ] do
    CheckAssertion( A, i, list[ i ] );
  od;
end );

InstallMethod( AddAssertion, [ IsConcatNList, IsInfListDoubleAssertion ],
function( L, A )
  local list, n, i;
  list := ConcatList( L );
  n := Length( list );
  AddAssertion( BaseList( L ), Shift( A, n ) );
  for i in [ 1 .. n - 1 ] do
    CheckAssertion( A, i, list[ i ], list[ i + 1 ] );
  od;
  CheckAssertion( A, n, list[ n ], BaseList( L )[ 1 ] );
end );

InstallMethod( Cut, [ IsNList, IsInt ],
function( list, i )
  local L;
  L := MakeInfList( IsCutNList,
                    rec(),
                    [ BaseList, list,
                      CutIndex, i ] );
  AddDerivation( list, L );
  return L;
end );

InstallMethod( \=, [ IsCutNList, IsNList ],
function( L1, L2 )
  Error( "cannot compare cut lists" );
end );

InstallMethod( \=, [ IsNList, IsCutNList ],
function( L1, L2 )
  Error( "cannot compare cut lists" );
end );

InstallMethod( Cut, [ IsNList, IsInt and IsZero ],
function( list, i )
  return list;
end );

InstallMethod( Cut, [ IsCutNList, IsPosInt ],
function( list, i )
  return Cut( BaseList( list ),
              CutIndex( list ) + i );
end );

InstallMethod( Cut, [ IsConcatNList, IsPosInt ],
function( list, i )
  local tail;
  tail := ConcatList( list );
  if i < Length( tail ) then
    return Concatenate( tail{ [ ( i + 1 ) .. Length( tail ) ] },
                        BaseList( list ) );
  elif i = Length( tail ) then
    return BaseList( list );
  else
    return Cut( BaseList( list ), i - Length( tail ) );
  fi;
end );

InstallMethod( Cut, [ IsInductiveNListDef, IsPosInt ],
function( L, i )
  return InductiveListWithImplementation
         ( L[ i + 1 ], InductionFunction( L ),
           Cut( Implementation( L ), i ) );
end );

InstallMethod( Cut, [ IsLiftingNListDef, IsPosInt ],
function( L, i )
  return LiftListWithImplementation
         ( L[ i + 1 ], Cut( BaseList( L ), i ), LiftingFunction( L ),
           Cut( Implementation( L ), i ) );
end );

InstallMethod( Cut, [ IsRepeatingNList, IsPosInt ],
function( list, i )
  local rep_list;
  rep_list := RepeatingList( list );
  rep_list := RotateLeft( rep_list,
                          i mod Length( rep_list ) );
  return RepeatListN( rep_list );
end );

InstallMethod( Cut, [ IsMapNList, IsPosInt ],
function( list, i )
  return Map( Cut( BaseList( list ), i ),
              MapFunction( list ) );
end );

InstallMethod( Cut, [ IsArithmeticNList, IsPosInt ],
function( L, i )
  return ArithmeticSequenceN( BasePosition( L ) + i * Increment( L ),
                              Increment( L ) );
end );

InstallMethod( ImplementationNotification, [ IsCutNList, IsNList ],
function( L, BL )
  if ( not HasImplementation( L ) )
     and IsIdenticalObj( BL, BaseList( L ) ) then
    SetImplementation( L, Cut( Implementation( BL ), CutIndex( L ) ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsCutNList, IsPosInt ],
function( L, i )
  return BaseList( L )[ i + CutIndex( L ) ];
end );

InstallMethod( KnownIndices, [ IsCutNList ],
function( L )
  return Filtered( KnownIndices( BaseList( L ) ) - CutIndex( L ),
                   IsPosInt );
end );

InstallMethod( InfListString, [ IsRecord, IsCutNList, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, BaseList( L ), i + CutIndex( L ),
                        reversed, shift - incr * CutIndex( L ), incr );
end );

InstallMethod( AddAssertion, [ IsCutNList, IsInfListAssertion ],
function( L, A )
  # TODO assertion should not apply to the whole base list
  AddAssertion( BaseList( L ), Shift( A, - CutIndex( L ) ) );
end );

InstallMethod( Map, [ IsDenseList, IsFunction ],
function( lists, f )
  local num_args;
  # TODO check that lists are appropriate?
  #      (or is it enough that Combine checks this?)
  num_args := NumberArgumentsFunction( f );
  if num_args <> Length( lists ) and num_args <> -1 then
    Error( "Number of arguments for function must match number of lists" );
  fi;
  return Map( Combine( lists ),
              items -> CallFuncList( f, items ) );
end );

# changed
# [ IsInfList, IsFunction ] --> [ IsInfList and IsNList, IsFunction ]
# because in code there is "IsMapNList".
InstallMethod( Map, [ IsInfList and IsNList, IsFunction ],
function( list, f )
  local L;
  L := MakeInfList( IsMapNList,
                    rec(),
                    [ BaseList, list,
                      MapFunction, f ] );
  AddDerivation( list, L );
  return L;
end );
##

InstallMethod( \=, [ IsMapNList, IsMapNList ],
function( L1, L2 )
  return BaseList( L1 ) = BaseList( L2 )
         and MapFunction( L1 ) = MapFunction( L2 );
end );

InstallMethod( Map, [ IsRepeatingNList, IsFunction ],
function( list, f )
  return RepeatListN( List( RepeatingList( list ), f ) );
end );

InstallMethod( Map, [ IsConcatNList, IsFunction ],
function( list, f )
  return Concatenate( List( ConcatList( list ), f ),
                      Map( BaseList( list ), f ) );
end );

InstallMethod( ImplementationNotification, [ IsMapNList, IsNList ],
function( L, BL )
  if ( not HasImplementation( L ) )
     and IsIdenticalObj( BL, BaseList( L ) ) then
    SetImplementation( L, Map( Implementation( BL ),
                               MapFunction( L ) ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsMapNList, IsPosInt ],
function( L, i )
  return MapFunction( L )( BaseList( L )[ i ] );
end );

InstallMethod( KnownIndices, [ IsMapNList ],
function( L )
  return KnownIndices( BaseList( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsMapNList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return Concatenation( "f( ", InfListString( opt, BaseList( L ), reversed, shift, incr ), " )" );
end );

InstallMethod( Combine, [ IsDenseList ],
function( lists )
  if ForAny( lists, IsNList ) then
    return CombineN( lists );
  else
    return CombineZ( lists );
  fi;
end );

InstallMethod( CombineN, [ IsDenseList ],
function( lists )
  local L, list, i, cut_index, rep_len, rep_list;
  if not ForAll( lists, IsNList ) then
    Error( "lists must be NList objects" );
  fi;
  if ForAny( lists, IsConcatNList ) then
    cut_index := 0;
    for i in [ 1 .. Length( lists ) ] do
      if IsConcatNList( lists[ i ] ) then
        cut_index := Maximum( cut_index,
                              Length( ConcatList( lists[ i ] ) ) );
      fi;
    od;
    return Concatenate( List( [ 1 .. cut_index ],
                              i -> List( lists, l -> l[ i ] ) ),
                        Combine( List( lists, l -> Cut( l, cut_index ) ) ) );
  fi;
  if ForAll( lists, IsRepeatingNList ) then
    rep_len := Lcm( List( lists, l -> Length( RepeatingList( l ) ) ) );
    rep_list := List( [ 1 .. rep_len ],
                      i -> List( lists, l -> l[ i ] ) );
    return RepeatListN( rep_list );
  fi;
  L := MakeInfList( IsCombinationNList,
                    rec(),
                    [ Lists, lists ] );
  for list in lists do
    AddDerivation( list, L );
  od;
  return L;
end );

InstallMethod( \=, [ IsCombinationNList, IsCombinationNList ],
function( L1, L2 )
  return Lists( L1 ) = Lists( L2 );
end );

InstallMethod( CombineZ, [ IsDenseList ],
function( lists )
  local concat_base_positions, base_pos, neg, pos;
  if not ForAll( lists, IsZList ) then
    Error( "lists must be ZList objects" );
  fi;
  concat_base_positions := List( Filtered( lists, IsConcatZList ),
                                 BasePosition );
  if IsEmpty( concat_base_positions ) then
    base_pos := 0;
  else
    base_pos := Minimum( concat_base_positions );
  fi;
  neg := CombineN( List( lists, L -> NegativePartFrom( L, base_pos - 1 ) ) );
  pos := CombineN( List( lists, L -> PositivePartFrom( L, base_pos ) ) );
  return Concatenate( neg, base_pos, [], pos );
end );

InstallMethod( ImplementationNotification, [ IsCombinationNList, IsNList ],
function( L, BL )
  local i, lists, change;
  if HasImplementation( L ) then
    return;
  fi;
  lists := ShallowCopy( Lists( L ) );
  change := false;
  for i in [ 1 .. Length( lists ) ] do
    if IsIdenticalObj( BL, lists[ i ] ) then
      lists[ i ] := Implementation( BL );
      change := true;
    fi;
  od;
  if change then
    SetImplementation( L, Combine( lists ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsCombinationNList, IsPosInt ],
function( L, i )
  return List( Lists( L ), l -> l[ i ] );
end );

InstallMethod( KnownIndices, [ IsCombinationNList ],
function( L )
  return Intersection( List( Lists( L ), KnownIndices ) );
end );

InstallMethod( InfListString, [ IsRecord, IsCombinationNList, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, L, i, KnownIndices( L ), reversed, [ shift, incr ] );
end );

InstallMethod( LiftList, [ IsObject, IsNList, IsFunction ],
function( init, L, f )
  return LiftListWithImplementation
         ( init, L, f, LiftListImp( [ init ], L, f ) );
end );

InstallMethod( LiftListWithImplementation, [ IsObject, IsNList, IsFunction, IsNList ],
function( init, BL, f, imp )
  local L;
  L := MakeInfList( IsLiftingNListDef,
                    rec( ),
                    [ BaseList, BL,
                      InitialValue, init,
                      LiftingFunction, f,
                      Implementation, imp ] );
  return L;
end );

InstallMethod( LiftListImp, [ IsDenseList, IsNList, IsFunction ],
function( init_list, BL, f )
  local L;
  L := MakeInfList( IsLiftingNListImp,
                    rec( values := init_list ),
                    [ BaseList, BL,
                      InitialValue, init_list[ 1 ],
                      LiftingFunction, f ] );
  AddDerivation( BL, L );
  return L;
end );

InstallMethod( LiftList, [ IsObject, IsConcatNList, IsFunction ],
function( init, BL, f )
  local tail, new_tail, l, new_init;
  tail := ConcatList( BL );
  new_tail := [ init ];
  l := 1;
  while l < Length( tail ) do
    new_tail[ l + 1 ] := f( new_tail[ l ], tail[ l + 1 ] );
    l := l + 1;
  od;
  new_init := f( new_tail[ l ], BL[ l + 1 ] );
  return Concatenate( new_tail, LiftList( new_init, BaseList( BL ), f ) );
end );

InstallMethod( LiftListImp, [ IsDenseList, IsConcatNList, IsFunction ],
function( init_list, BL, f )
  local tail, new_tail, new_init_list, l;
  tail := ConcatList( BL );
  if Length( tail ) < Length( init_list ) then
    new_tail := init_list{ [ 1 .. Length( tail ) ] };
    new_init_list := init_list{ [ Length( tail ) + 1 .. Length( init_list ) ] };
  else
    new_tail := init_list;
    while Length( new_tail ) < Length( tail ) do
      l := Length( new_tail );
      new_tail[ l + 1 ] := f( new_tail[ l ], tail[ l + 1 ] );
    od;
    new_init_list := [ f( new_tail[ Length( new_tail ) ],
                          BaseList( BL )[ 1 ] ) ];
  fi;
  return Concatenate( new_tail, LiftListImp( new_init_list, BaseList( BL ), f ) );
end );

InstallMethod( ImplementationNotification, [ IsLiftingNList, IsNList ],
function( L, BL )
  if ( not HasImplementation( L ) )
     and IsIdenticalObj( BL, BaseList( L ) ) then
    SetImplementation( L, LiftListImp( L!.values, Implementation( BL ),
                                       LiftingFunction( L ) ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsLiftingNList, IsPosInt ],
function( L, i )
  local v, f, l, m, check_repeating, i1, i2;
  v := L!.values;
  f := LiftingFunction( L );
  if IsRepeatingNList( BaseList( L ) ) then
    m := Length( RepeatingList( BaseList( L ) ) );
    check_repeating := true;
  else
    m := 0;
    check_repeating := false;
  fi;
  while i > Length( v ) do
    l := Length( v );
    v[ l + 1 ] := f( v[ l ], BaseList( L )[ l + 1 ] );
    if check_repeating
       and ( l mod m ) = 0
       and ( l / m ) mod 2 = 1 then
      i1 := ( l + m ) / 2 - m + 1;
      i2 := l + 1;
      if v[ i1 ] = v[ i2 ] then
        SetImplementation( L, Repeatify( L, i1, i2 ) );
        return Implementation( L )[ i ];
      fi;
    fi;
  od;
  return v[ i ];
end );

InstallMethod( Repeatify, [ IsLiftingNListImp, IsPosInt, IsPosInt ],
function( L, collisionIndex1, collisionIndex2 )
  local m, values, i1, i2, i, repeatStartIndex, repeatEndIndex,
        tail, repeatedList, newList;
  m := Length( RepeatingList( BaseList( L ) ) );
  values := L!.values;
  i1 := collisionIndex1;
  i2 := collisionIndex2;
  while i1 > 0 and values[ i1 ] = values[ i2 ] do
    i1 := i1 - 1;
    i2 := i2 - 1;
  od;
  repeatStartIndex := i1 + 1;
  i := repeatStartIndex + m;
  while values[ i ] <> values[ repeatStartIndex ] do
    i := i + m;
  od;
  repeatEndIndex := i - 1;
  tail := values{ [ 1 .. ( repeatStartIndex - 1 ) ] };
  repeatedList := values{ [ repeatStartIndex .. repeatEndIndex ] };
  newList := Concatenate( tail, RepeatListN( repeatedList ) );
  return newList;
end );

InstallMethod( KnownIndices, [ IsLiftingNList ],
function( L )
  return [ 1 .. Length( L!.values ) ];
end );

InstallMethod( InfListString, [ IsRecord, IsLiftingNList, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, L, i, KnownIndices( L ), reversed, [ shift, incr ] );
end );

# TODO implement L{ list }

InstallMethod( Sublist, [ IsNList, IsPosInt, IsPosInt ],
function( L, a, b )
  return List( [ a .. ( b - 1 ) ], i -> L[ i ] );
end );

InstallMethod( Sublist, [ IsZList, IsInt, IsInt ],
function( L, a, b )
  return List( [ a .. ( b - 1 ) ], i -> L[ i ] );
end );

InstallValue( PositiveIntegersList, ArithmeticSequenceN( 1, 1 ) );

# TODO implement \in

InstallMethod( \in, [ IsObject, IsInfList ],
function( obj, L )
  if IsIdenticalObj( L, PositiveIntegersList ) then
    return IsPosInt( obj );
  fi;
  TryNextMethod();
end );

InstallMethod( Intersection2, [ IsList, IsNList ],
function( list, inflist )
  if IsIdenticalObj( inflist, PositiveIntegersList ) then
    return Filtered( list, IsPosInt );
  fi;
  TryNextMethod();
end );

InstallMethod( Intersection2, [ IsNList, IsList ],
function( inflist, list )
  if IsIdenticalObj( inflist, PositiveIntegersList ) then
    return Filtered( list, IsPosInt );
  fi;
  TryNextMethod();
end );

InstallMethod( Intersection2, [ IsNList, IsNList ],
function( L1, L2 )
  if IsIdenticalObj( L1, L2 ) then
    return L1;
  fi;
  TryNextMethod();
end );

# InstallMethod( Union2, [ IsList, IsNList ],
# function( list, inflist )
#   if IsIdenticalObj( inflist, PositiveIntegersList ) then
#     return PositiveIntegersList
#   fi;
#   TryNextMethod();
# end );

# InstallMethod( Union2, [ IsNList, IsList ],
# function( inflist, list )
#   if IsIdenticalObj( inflist, PositiveIntegersList ) then
#     return Filtered( list, IsPosInt );
#   fi;
#   TryNextMethod();
# end );

# InstallMethod( Union2, [ IsNList, IsNList ],
# function( L1, L2 )
#   if IsIdenticalObj( L1, L2 ) then
#     return L1;
#   fi;
#   TryNextMethod();
# end );


InstallMethod( RotateLeft, [ IsList, IsInt ],
function( list, n )
  n := n mod Length( list );
  return Concatenation( list{ [ ( n + 1 ) .. Length( list ) ] },
                        list{ [ 1 .. n ] } );
end );

InstallMethod( RotateRight, [ IsList, IsInt ],
function( list, n )
  return RotateLeft( list, -n );
end );



# ZList

InstallMethod( Concatenate, [ IsNList, IsNList ],
function( neg, pos )
  return Concatenate( neg, [], pos );
end );

InstallMethod( MakeConcatZList, [ IsNList, IsDenseList, IsNList, IsInt ],
function( neg, mid, pos, base )
  local L;
  L := MakeInfList( IsConcatZList,
                    rec(),
                    [ BasePosition, base,
                      NegativeList, neg,
                      MiddleList, mid,
                      PositiveList, pos ] );
  AddDerivation( neg, L );
  AddDerivation( pos, L );
  return L;
end );

InstallMethod( Concatenate, [ IsNList, IsDenseList, IsNList ],
function( neg, mid, pos )
  return MakeConcatZList( neg, mid, pos, 0 );
end );

InstallMethod( Concatenate, [ IsNList, IsInt, IsDenseList, IsNList ],
function( neg, i, mid, pos )
  return MakeConcatZList( neg, mid, pos, i );
end );

InstallMethod( Concatenate, [ IsConcatNList, IsDenseList, IsNList ],
function( L1, middle, L2 )
  local middle_extra, C;
  middle_extra := Reversed( ConcatList( L1 ) );
  C := Concatenate( BaseList( L1 ),
                    Concatenation( middle_extra, middle ),
                    L2 );
  return Shift( C, Length( middle_extra ) );
end );

InstallMethod( Concatenate, [ IsNList, IsDenseList, IsConcatNList ],
function( L1, middle, L2 )
  local middle_extra, C;
  middle_extra := ConcatList( L2 );
  return Concatenate( L1, Concatenation( middle, middle_extra ),
                      BaseList( L2 ) );
end );

InstallMethod( ImplementationNotification, [ IsConcatZList, IsNList ],
function( L, NL )
  local pos, neg, change;
  pos := PositiveList( L );
  neg := NegativeList( L );
  change := false;
  if IsIdenticalObj( NL, pos ) then
    pos := Implementation( NL );
    change := true;
  fi;
  if IsIdenticalObj( NL, neg ) then
    neg := Implementation( NL );
    change := true;
  fi;
  if change then
    SetImplementation( L, MakeConcatZList( neg, MiddleList( L ), pos,
                                           BasePosition( L ) ) );
  fi;
end );

InstallMethod( LookupInfList, [ IsConcatZList, IsInt ],
function( L, i )
  local b, mid;
  b := BasePosition( L );
  mid := MiddleList( L );
  if i >= b + Length( mid ) then
    return PositiveList( L )[ i - ( b + Length( mid ) ) + 1 ];
  elif i >= b then
    return mid[ i - b + 1 ];
  else
    return NegativeList( L )[ b - i ];
  fi;
end );

InstallMethod( KnownIndices, [ IsConcatZList ],
function( L )
  return []; #TODO
end );

InstallMethod( InfListString, [ IsRecord, IsConcatZList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  local b, mid_len, mid_str_list, mid, neg, pos;
  b := BasePosition( L );
  mid_len := Length( MiddleList( L ) );
  if IsEmpty( MiddleList( L ) ) then
    mid := opt.separator;
  else
    mid_str_list := ListN( [ b .. ( b + mid_len - 1 ) ] * incr + shift,
                           MiddleList( L ),
                           opt.format_value );
    if reversed then mid_str_list := Reversed( mid_str_list ); fi;
    mid := JoinStringsWithSeparator( mid_str_list, opt.separator );
    mid := Concatenation( opt.separator, mid, opt.separator );
  fi;
  neg := InfListString( opt, NegativeList( L ), not reversed,
                        b + shift, -incr );
  pos := InfListString( opt, PositiveList( L ), reversed,
                        b + incr * ( mid_len - 1 ) + shift, incr );
  if reversed then
    return Concatenation( pos, mid, neg );
  else
    return Concatenation( neg, mid, pos );
  fi;
end );

InstallMethod( PositivePartFrom, [ IsConcatZList, IsInt ],
function( L, i )
  local pos_start;
  pos_start := BasePosition( L ) + Length( MiddleList( L ) );
  if i >= pos_start then
    return Cut( PositiveList( L ), i - pos_start );
  else
    return Concatenate( Sublist( L, i, pos_start ),
                        PositiveList( L ) );
  fi;
end );

InstallMethod( NegativePartFrom, [ IsConcatZList, IsInt ],
function( L, i )
  local b;
  b := BasePosition( L );
  if i < b then
    return Cut( NegativeList( L ), b - i - 1 );
  else
    return Concatenate( Reversed( Sublist( L, b, i + 1 ) ),
                        NegativeList( L ) );
  fi;
end );

InstallMethod( Shift, [ IsConcatZList, IsInt ],
function( L, i )
  return MakeConcatZList( NegativeList( L ), MiddleList( L ), PositiveList( L ),
                          BasePosition( L ) - i );
end );

InstallMethod( Map, [ IsConcatZList, IsFunction ],
function( L, f )
  return MakeConcatZList
         ( Map( NegativeList( L ), f ),
           List( MiddleList( L ), f ),
           Map( PositiveList( L ), f ),
           BasePosition( L ) );
end );

InstallMethod( RepeatListZ, [ IsDenseList ],
function( list )
  return MakeInfList( IsRepeatingZList,
                      rec(),
                      [ BasePosition, 0,
                        RepeatingList, Unrepeat( list ) ] );
end );

InstallMethod( LookupInfList, [ IsRepeatingZList, IsInt ],
function( L, i )
  local rep_list, base;
  rep_list := RepeatingList( L );
  base := BasePosition( L );
  return rep_list[ ( i - base ) mod Length( rep_list ) + 1 ];
end );

InstallMethod( KnownIndices, [ IsRepeatingZList ],
function( L )
  return IntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsRepeatingZList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  local b, list, len, str_list, str;
  b := BasePosition( L );
  list := RepeatingList( L );
  len := Length( list );
  str_list := ListN( [ b .. ( b + len - 1 ) ] * incr + shift,
                     list,
                     opt.format_value );
  if reversed then str_list := Reversed( str_list ); fi;
  str := JoinStringsWithSeparator( str_list, opt.separator );
  return Concatenation( opt.repeat_end_left, str, opt.repeat_end_right );
end );

InstallMethod( PositivePartFrom, [ IsRepeatingZList, IsInt ],
function( L, i )
  return RepeatListN( RotateLeft( RepeatingList( L ), i ) );
end );

InstallMethod( NegativePartFrom, [ IsRepeatingZList, IsInt ],
function( L, i )
  return RepeatListN( RotateLeft( Reversed( RepeatingList( L ) ), -1 - i ) );
end );

InstallMethod( Shift, [ IsRepeatingZList, IsInt ],
function( L, i )
  return RepeatListZ( RotateLeft( RepeatingList( L ), i ) );
end );

InstallMethod( Shift, [ IsRepeatingZList, IsInt and IsZero ],
function( L, i )
  return L;
end );

InstallValue( AlternatingSignList, RepeatListZ( [ 1, -1 ] ) );

InstallMethod( ArithmeticSequenceZ, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfList( IsArithmeticZList,
                      rec(),
                      [ InitialValue, init,
                        Increment, incr ] );
end );

InstallMethod( LookupInfList, [ IsArithmeticZList, IsInt ],
function( L, i )
  return InitialValue( L ) + i * Increment( L );
end );

InstallMethod( KnownIndices, [ IsArithmeticZList ],
function( L )
  return IntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsArithmeticZList, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  local str_list, str;
  str_list := ListN( [ -2 .. 3 ] * incr + shift,
                     Sublist( L, -2, 3 + 1 ),
                     opt.format_value );
  if reversed then str_list := Reversed( str_list ); fi;
  str := JoinStringsWithSeparator( str_list, opt.separator );
  return Concatenation( opt.ellipsis, opt.separator,
                        str,
                        opt.separator, opt.ellipsis );
end );

InstallMethod( PositivePartFrom, [ IsArithmeticZList, IsInt ],
function( L, i )
  return ArithmeticSequenceN( L[ i ], Increment( L ) );
end );

InstallMethod( NegativePartFrom, [ IsArithmeticZList, IsInt ],
function( L, i )
  return ArithmeticSequenceN( L[ i ], - Increment( L ) );
end );

InstallMethod( Shift, [ IsArithmeticZList, IsInt ],
function( L, i )
  return ArithmeticSequenceZ( InitialValue( L ) + i * Increment( L ),
                              Increment( L ) );
end );

InstallValue( IntegersList, ArithmeticSequenceZ( 0, 1 ) );

InstallMethod( Replace, [ IsZList, IsInt, IsDenseList ],
function( L, i, values )
  return Concatenate( NegativePartFrom( L, i - 1 ),
                      i, values,
                      PositivePartFrom( L, i + Length( values ) ) );
end );
