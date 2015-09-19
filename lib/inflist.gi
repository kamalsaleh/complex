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


DeclareRepresentation( "IsInfListRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ "imp" ] );

                       # [ "rep_type",
                       #   "init_val",
                       #   "values",
                       #   "base_list",
                       #   "cat_list",
                       #   "cut_index",
                       #   "lists",
                       #   "map_function" ] );

BindGlobal( "FamilyOfInfLists",
            NewFamily( "infinite lists" ) );

DeclareRepresentation( "IsInfListImpRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ "users", "better_implementation",
                         "single_assertions", "double_assertions" ] );
DeclareRepresentation( "IsNListImpRep",
                       IsInfListImpRep,
                       [ "values" ] );
DeclareRepresentation( "IsZListImpRep",
                       IsInfListImpRep,
                       [ "base",
                         "positive", "middle", "negative",
                         "repeat" ] );

BindGlobal( "FamilyOfInfListImps",
            NewFamily( "infinite list implementations" ) );

InstallMethod( MakeInfList, [ IsInfListImp ],
function( imp )
  local cat, type, L;
  if IsNListImp( imp ) then
    cat := IsNList;
  else
    cat := IsZList;
  fi;
  type := NewType( FamilyOfInfLists, cat and IsInfListRep );
  L := Objectify( type, rec( ) );
  SetImplementation( L, imp );
  return L;
end );

InstallMethod( Implementation, [ IsInfList ],
function( L )
  return L!.imp;
end );

InstallMethod( SetImplementation, [ IsInfList, IsInfListImp ],
function( L, imp )
  local copy_attrs, a;
  L!.imp := imp;
  # TODO: is this sensible?
  copy_attrs := [ IsInductive, IsEventuallyInductive, InductiveFromIndex, InductionFunction,
                  IsRepeating, IsEventuallyRepeating, RepeatingFromIndex, RepeatingList ];
  for a in copy_attrs do
    if Tester( a )( imp ) then
      Setter( a )( L, a( imp ) );
    fi;
  od;
  # if HasInductivePart( imp ) then
  #   SetInductivePart( L, MakeInfList( InductivePart( imp ) ) );
  # fi;
  # if HasRepeatingPart( imp ) then
  #   SetRepeatingPart( L, MakeInfList( RepeatingPart( imp ) ) );
  # fi;
  NotifyBetterImplementation( imp, L );
end );

InstallMethod( BetterImplementationAvailable, [ IsInfList, IsInfListImp ],
function( L, imp )
  if IsIdenticalObj( imp, L!.imp ) then
    SetImplementation( L, BetterImplementation( imp ) );
  fi;
end );

InstallMethod( AddAssertion, [ IsInfList, IsInfListAssertion ],
function( L, A )
  AddAssertion( Implementation( L ), A );
end );

InstallMethod( String, [ IsInfListImp ],
function( L )
  return Concatenation( "8i[ ", InfListString( L ), " ]" );
end );

InstallMethod( SetString, [ IsInfListImp, IsString ],
               function( L, str ) end );

InstallMethod( InfListString, [ IsInfList ],
function( L )
  return InfListString( Implementation( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList ],
function( opt, L )
  return InfListString( opt, Implementation( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsInfList, IsBool ],
function( opt, L, reversed )
  return InfListString( opt, Implementation( L ), reversed );
end );

InstallMethod( String, [ IsInfList ],
function( L )
  return Concatenation( "8[ ", InfListString( L ), " ]" );
end );

InstallMethod( SetString, [ IsInfList, IsString ],
               function( L, str ) end );

InstallMethod( MakeInfListImp, [ IsOperation, IsRecord, IsDenseList ],
function( C, obj, attributes )
  local type;
  type := NewType( FamilyOfInfListImps, C and IsInfListImpRep );
  obj.users := WeakPointerObj( [] );
  obj.better_implementation := fail;
  obj.single_assertions := [];
  obj.double_assertions := [];
  if not IsBound( obj.values ) then
    obj.values := [];
  fi;
  CallFuncList( ObjectifyWithAttributes,
                Concatenation( [ obj, type ], attributes ) );
  return obj;
end );

InstallMethod( NotifyBetterImplementation, [ IsInfListImp, IsObject ],
function( L, obj )
  if HasBetterImplementation( L ) then
    BetterImplementationAvailable( obj, L );
  else
    SetElmWPObj( L!.users,
                 LengthWPObj( L!.users ) + 1,
                 obj );
  fi;
end );

InstallMethod( SetBetterImplementation, [ IsInfListImp, IsObject ],
function( L, obj )
  Error( "Value of BetterImplementation attribute must be an IsInfListImp object" );
end );

InstallMethod( SetBetterImplementation, [ IsInfListImp, IsInfListImp ],
function( L, BL )
  local i, u;
  if L!.better_implementation <> fail then
    return;
  fi;
  Info( InfoInfList, 1,
        "SetBetterImplementation( ", L, ", ", BL, ")" );
  L!.better_implementation := BL;
  SetFilterObj( L, HasBetterImplementation );
  for i in [ 1 .. LengthWPObj( L!.users ) ] do
    u := ElmWPObj( L!.users, i );
    if u <> fail then
      BetterImplementationAvailable( u, L );
      UnbindElmWPObj( L!.users, i );
    fi;
  od;
end );

InstallMethod( BetterImplementation, "for InfListImp",
               [ IsInfListImp and IsInfListImpRep ],
               GETTER_FLAGS + 1, # to override system getter
function( L )
  if L!.better_implementation <> fail then
    return L!.better_implementation;
  fi;
  TryNextMethod();
end );

InstallMethod( AddAssertion, [ IsInfListImp, IsInfListSingleAssertion ],
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

InstallMethod( AddAssertion, [ IsInfListImp, IsInfListDoubleAssertion ],
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

InstallMethod( CheckSingleAssertions, [ IsInfListImp, IsInt, IsObject ],
function( L, i, elem )
  local A;
  for A in L!.single_assertions do
    CheckAssertion( A, i, elem );
  od;
end );

InstallMethod( CheckDoubleAssertions, [ IsInfListImp, IsInt, IsObject, IsObject ],
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

InstallMethod( InfListString, [ IsNListImp ],
function( L )
  return InfListString( InfListStringDefaultOptionsN, L );
end );

InstallMethod( InfListString, [ IsZListImp ],
function( L )
  return InfListString( InfListStringDefaultOptionsZ, L );
end );

InstallMethod( InfListString, [ IsRecord, IsInfListImp ],
function( opt, L )
  return InfListString( opt, L, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsPosInt ],
function( opt, L, i )
  return InfListString( opt, L, i, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsDenseList ],
function( opt, L, indices )
  return InfListString( opt, L, indices, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsPosInt, IsDenseList ],
function( opt, L, start_index, indices )
  return InfListString( opt, L, start_index, indices, false, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsInfListImp, IsBool ],
function( opt, L, reversed )
  return InfListString( opt, L, reversed, 0, 1 );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return InfListString( opt, L, 1, reversed, shift, incr );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, CutImp( L, i - 1 ), reversed, shift, incr );
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsDenseList, IsBool, IsInt, IsInt ],
function( opt, L, indices, reversed, shift, incr )
  if IsEmpty( indices ) then
    return opt.ellipsis;
  else
    return InfListString( opt, L, indices[ 1 ], indices, reversed, shift, incr );
  fi;
end );

InstallMethod( InfListString, [ IsRecord, IsNListImp, IsPosInt, IsDenseList, IsBool, IsDenseList ],
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
    add_str( opt.format_value( i * incr + shift, LookupInfListImp( L, i ) ) );
    add_str( opt.separator );
    if indices[ j + 1 ] > 1 + i then
      add_str( opt.ellipsis );
      add_str( opt.separator );
    fi;
  od;
  i := indices[ Length( indices ) ];
  add_str( opt.format_value( i * incr + shift, LookupInfListImp( L, i ) ) );
  add_str( opt.separator );
  add_str( opt.ellipsis );
  return str;
end );

InstallMethod( InductiveList, [ IsObject, IsFunction ],
function( init, f )
  return MakeInfList( InductiveListImp( init, f ) );
end );

InstallMethod( InductiveListImp, [ IsObject, IsFunction ],
function( init, f )
  return MakeInfListImp( IsInductiveNListImp,
                         rec( values := [ init ] ),
                         [ InitialValue, init,
                           InductionFunction, f ] );
end );

InstallMethod( LookupInfListImp, [ IsInductiveNListImp, IsPosInt ],
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
        SetBetterImplementation( list, Repeatify( list, ( l + 1 ) / 2, l + 1 ) );
        return LookupInfListImp( BetterImplementation( list ), i );
      fi;
    fi;
  od;
  return v[ i ];
end );

InstallMethod( KnownIndicesImp, [ IsInductiveNListImp ],
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
  newList := ConcatenateImp( tail, RepeatListImp( repeatedList ) );
  return newList;
end );

InstallMethod( RepeatList, [ IsDenseList ],
function( list )
  return MakeInfList( RepeatListImp( list ) );
end );

InstallMethod( RepeatListImp, [ IsDenseList ],
function( list )
  return MakeInfListImp( IsRepeatingNListImp,
                         rec(),
                         [ RepeatingList, list ] );
end );

InstallMethod( LookupInfListImp, [ IsRepeatingNListImp, IsPosInt ],
function( list, i )
  local r, l, v;
  r := RepeatingList( list );
  l := Length( r );
  v := r[ ( ( i - 1 ) mod l ) + 1 ];
  return v;
end );

InstallMethod( KnownIndicesImp, [ IsRepeatingNListImp ],
function( L )
  return PositiveIntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsRepeatingNListImp, IsBool, IsInt, IsInt ],
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

InstallMethod( AddAssertion, [ IsRepeatingNListImp, IsInfListSingleAssertion ],
function( L, A )
  # can check all assertions immediately, since all the objects are already known
  local i, rep_list;
  rep_list := RepeatingList( L );
  for i in [ 1 .. Length( rep_list ) ] do
    CheckAssertion( A, i, rep_list[ i ] );
  od;
end );

InstallMethod( AddAssertion, [ IsRepeatingNListImp, IsInfListDoubleAssertion ],
function( L, A )
  local rep_list, n, i;
  rep_list := RepeatingList( L );
  n := Length( rep_list );
  for i in [ 1 .. n - 1 ] do
    CheckAssertion( A, i, rep_list[ i ], rep_list[ i + 1 ] );
  od;
  CheckAssertion( A, n, rep_list[ n ], rep_list[ 1 ] );
end );

InstallMethod( PositionalList, [ IsFunction ],
function( f )
  return PositionalList( f, false );
end );

InstallMethod( PositionalList, [ IsFunction, IsBool ],
function( f, store )
  return MakeInfList( PositionalListImp( f, store ) );
end );

InstallMethod( PositionalListImp, [ IsFunction, IsBool ],
function( f, store )
  return MakeInfListImp( IsPositionalNListImp,
                         rec( values := [] ),
                         [ ElementFunction, f,
                           IsStoringValues, store ] );
end );

InstallMethod( LookupInfListImp, [ IsPositionalNListImp, IsPosInt ],
function( L, i )
  local values, f, v;
  values := L!.values;
  if IsBound( values[ i ] ) then
    return values[ i ];
  fi;
  f := ElementFunction( L );
  v := f( i );
  CheckSingleAssertions( L, i, v );
  if IsStoringValues( L ) then
    values[ i ] := v;
    if i > 1 and IsBound( values[ i - 1 ] ) then
      CheckDoubleAssertions( L, i - 1, values[ i - 1 ], values[ i ] );
    fi;
  fi;
  return v;
end );

InstallMethod( KnownIndicesImp, [ IsPositionalNListImp ],
function( L )
  return BoundPositions( L!.values );
end );

InstallMethod( InfListString, [ IsRecord, IsPositionalNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, L, i, KnownIndicesImp( L ), reversed, [ shift, incr ] );
end );

InstallMethod( ArithmeticSequence, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfList( ArithmeticSequenceImp( init, incr ) );
end );

InstallMethod( ArithmeticSequenceImp, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfListImp( IsArithmeticNListImp,
                         rec(),
                         [ InitialValue, init,
                           Increment, incr ] );
end );

InstallMethod( BetterImplementationAvailable, [ IsArithmeticNListImp, IsNListImp ],
function( L, BL ) end );

InstallMethod( LookupInfListImp, [ IsArithmeticNListImp, IsPosInt ],
function( L, i )
  return InitialValue( L ) + ( i - 1 ) * Increment( L );
end );

InstallMethod( KnownIndicesImp, [ IsArithmeticNListImp ],
function( L )
  return PositiveIntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsArithmeticNListImp, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return InfListString( opt, L, [ 1, 2, 3 ], reversed, shift, incr );
end );

InstallMethod( Concatenate, [ IsDenseList, IsNList ],
function( tail, base_list )
  return MakeInfList( ConcatenateImp( tail, Implementation( base_list ) ) );
end );

InstallMethod( MakeConcatNListImp, [ IsDenseList, IsNListImp ],
function( tail, base_list )
  local L;
  L := MakeInfListImp( IsConcatNListImp,
                       rec(),
                       [ BaseList, base_list,
                         ConcatList, tail ] );
  NotifyBetterImplementation( base_list, L );
  return L;
end );

InstallMethod( ConcatenateImp, [ IsDenseList, IsNListImp ],
               MakeConcatNListImp );

InstallMethod( ConcatenateImp, [ IsDenseList, IsConcatNListImp ],
function( tail, base_list )
  return ConcatenateImp( Concatenation( tail, ConcatList( base_list ) ),
                         BaseList( base_list ) );
end );

InstallMethod( ConcatenateImp, [ IsDenseList and IsEmpty, IsNListImp ],
function( tail, base_list )
  return base_list;
end );

InstallMethod( ConcatenateImp, [ IsDenseList, IsRepeatingNListImp ],
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
    return ConcatenateImp( tail, RepeatListImp( rep ) );
  else
    return MakeConcatNListImp( tail, base_list );
  fi;
end );

InstallMethod( BetterImplementationAvailable, [ IsConcatNListImp, IsNListImp ],
function( L, BL )
  if IsIdenticalObj( BL, BaseList( L ) ) then
    SetBetterImplementation( L, ConcatenateImp( ConcatList( L ),
                                                BetterImplementation( BL ) ) );
  fi;
end );
                         

# InstallMethod( Normalized, [ IsConcatInfListImp ],
# function( L )
#   local c, b;
#   c := ConcatList( L );
#   b := BaseList( L );
#   bi := Implementation( b );
#   if Length( c ) = 0 then
#     return Normalized( CopyInfListImp( b ) );
#   elif IsConcatInfListImp( bi ) then
#     return Normalized( Concatenate( Concatenation( c, ConcatList( bi ) ),
#                                     BaseList( b ) ) );
#   else
# end );

InstallMethod( LookupInfListImp, [ IsConcatNListImp, IsPosInt ],
function( list, i )
  local l, v;
  l := Length( ConcatList( list ) );
  if i <= l then
    return ConcatList( list )[ i ];
  else
    return LookupInfListImp( BaseList( list ), i - l );
  fi;
end );

InstallMethod( KnownIndicesImp, [ IsConcatNListImp ],
function( L )
  local concat_len;
  concat_len := Length( ConcatList( L ) );
  return Concatenation( [ 1 .. concat_len ],
                        KnownIndicesImp( BaseList( L ) ) + concat_len );
end );

InstallMethod( InfListString, [ IsRecord, IsConcatNListImp, IsPosInt, IsBool, IsInt, IsInt ],
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

InstallMethod( AddAssertion, [ IsConcatNListImp, IsInfListSingleAssertion ],
function( L, A )
  local list, n, i;
  list := ConcatList( L );
  n := Length( list );
  AddAssertion( BaseList( L ), Shift( A, n ) );
  for i in [ 1 .. n ] do
    CheckAssertion( A, i, list[ i ] );
  od;
end );

InstallMethod( AddAssertion, [ IsConcatNListImp, IsInfListDoubleAssertion ],
function( L, A )
  local list, n, i;
  list := ConcatList( L );
  n := Length( list );
  AddAssertion( BaseList( L ), Shift( A, n ) );
  for i in [ 1 .. n - 1 ] do
    CheckAssertion( A, i, list[ i ], list[ i + 1 ] );
  od;
  CheckAssertion( A, n, list[ n ], LookupInfListImp( BaseList( L ), 1 ) );
end );

InstallMethod( Cut, [ IsNList, IsInt ],
function( list, i )
  return MakeInfList( CutImp( Implementation( list ), i ) );
end );

InstallMethod( CutImp, [ IsNListImp, IsPosInt ],
function( list, i )
  local L;
  L := MakeInfListImp( IsCutNListImp,
                       rec(),
                       [ BaseList, list,
                         CutIndex, i ] );
  NotifyBetterImplementation( list, L );
  return L;
end );

InstallMethod( CutImp, [ IsNListImp, IsInt and IsZero ],
function( list, i )
  return list;
end );

InstallMethod( CutImp, [ IsCutNListImp, IsPosInt ],
function( list, i )
  return CutImp( BaseList( list ),
                 CutIndex( list ) + i );
end );

InstallMethod( CutImp, [ IsConcatNListImp, IsPosInt ],
function( list, i )
  local tail;
  tail := ConcatList( list );
  if i < Length( tail ) then
    return ConcatenateImp( tail{ [ ( i + 1 ) .. Length( tail ) ] },
                           BaseList( list ) );
  elif i = Length( tail ) then
    return BaseList( list );
  else
    return CutImp( BaseList( list ), i - Length( tail ) );
  fi;
end );

InstallMethod( CutImp, [ IsRepeatingNListImp, IsPosInt ],
function( list, i )
  local rep_list;
  rep_list := RepeatingList( list );
  rep_list := RotateLeft( rep_list,
                          i mod Length( rep_list ) );
  return RepeatListImp( rep_list );
end );

InstallMethod( CutImp, [ IsMapNListImp, IsPosInt ],
function( list, i )
  return MapImp( CutImp( BaseList( list ), i ),
                 MapFunction( list ) );
end );

InstallMethod( CutImp, [ IsArithmeticNListImp, IsPosInt ],
function( L, i )
  return ArithmeticSequence( BasePosition( L ) + i * Increment( L ),
                             Increment( L ) );
end );

InstallMethod( BetterImplementationAvailable, [ IsCutNListImp, IsNListImp ],
function( L, BL )
  if IsIdenticalObj( BL, BaseList( L ) ) then
    SetBetterImplementation( L, CutImp( BetterImplementation( BL ), CutIndex( L ) ) );
  fi;
end );

InstallMethod( LookupInfListImp, [ IsCutNListImp, IsPosInt ],
function( L, i )
  return LookupInfListImp( BaseList( L ), i + CutIndex( L ) );
end );

InstallMethod( KnownIndicesImp, [ IsCutNListImp ],
function( L )
  return Filtered( KnownIndicesImp( BaseList( L ) ) - CutIndex( L ),
                   IsPosInt );
end );

InstallMethod( InfListString, [ IsRecord, IsCutNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, BaseList( L ), i + CutIndex( L ),
                        reversed, shift - incr * CutIndex( L ), incr );
end );

InstallMethod( AddAssertion, [ IsCutNListImp, IsInfListAssertion ],
function( L, A )
  AddAssertion( BaseList( L ), Shift( A, - CutIndex( L ) ) );
end );

InstallMethod( Map, [ IsInfList, IsFunction ],
function( list, f )
  return MakeInfList( MapImp( Implementation( list ), f ) );
end );

InstallMethod( MapImp, [ IsNListImp, IsFunction ],
function( list, f )
  local L;
  L := MakeInfListImp( IsMapNListImp,
                       rec(),
                       [ BaseList, list,
                         MapFunction, f ] );
  NotifyBetterImplementation( list, L );
  return L;
end );

InstallMethod( MapImp, [ IsRepeatingNListImp, IsFunction ],
function( list, f )
  return RepeatListImp( List( RepeatingList( list ), f ) );
end );

InstallMethod( MapImp, [ IsConcatNListImp, IsFunction ],
function( list, f )
  return ConcatenateImp( List( ConcatList( list ), f ),
                         MapImp( BaseList( list ), f ) );
end );

InstallMethod( BetterImplementationAvailable, [ IsMapNListImp, IsNListImp ],
function( L, BL )
  if IsIdenticalObj( BL, BaseList( L ) ) then
    SetBetterImplementation( L, MapImp( BetterImplementation( BL ),
                                        MapFunction( L ) ) );
  fi;
end );

InstallMethod( LookupInfListImp, [ IsMapNListImp, IsPosInt ],
function( L, i )
  return MapFunction( L )( LookupInfListImp( BaseList( L ), i ) );
end );

InstallMethod( KnownIndicesImp, [ IsMapNListImp ],
function( L )
  return KnownIndicesImp( BaseList( L ) );
end );

InstallMethod( InfListString, [ IsRecord, IsMapNListImp, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  return Concatenation( "f( ", InfListString( opt, BaseList( L ), reversed, shift, incr ), " )" );
end );

InstallMethod( Combine, [ IsDenseList ],
function( lists )
  return MakeInfList( CombineImp( List( lists, Implementation ) ) );
end );

InstallMethod( CombineImp, [ IsDenseList ],
function( lists )
  local L, list, i, cut_index, rep_len, rep_list;
  if ForAny( lists, IsConcatNListImp ) then
    cut_index := 0;
    for i in [ 1 .. Length( lists ) ] do
      if IsConcatNListImp( lists[ i ] ) then
        cut_index := Maximum( cut_index,
                              Length( ConcatList( lists[ i ] ) ) );
      fi;
    od;
    return ConcatenateImp( List( [ 1 .. cut_index ],
                                 i -> List( lists, l -> LookupInfListImp( l, i ) ) ),
                           CombineImp( List( lists, l -> CutImp( l, cut_index ) ) ) );
  fi;
  if ForAll( lists, IsRepeatingNListImp ) then
    rep_len := Lcm( List( lists, l -> Length( RepeatingList( l ) ) ) );
    rep_list := List( [ 1 .. rep_len ],
                      i -> List( lists, l -> LookupInfListImp( l, i ) ) );
    return RepeatListImp( rep_list );
  fi;
  L := MakeInfListImp( IsCombinationNListImp,
                       rec(),
                       [ Lists, lists ] );
  for list in lists do
    NotifyBetterImplementation( list, L );
  od;
  return L;
end );

InstallMethod( BetterImplementationAvailable, [ IsCombinationNListImp, IsNListImp ],
function( L, BL )
  local i, lists, change;
  lists := ShallowCopy( Lists( L ) );
  change := false;
  for i in [ 1 .. Length( lists ) ] do
    if IsIdenticalObj( BL, lists[ i ] ) then
      lists[ i ] := BetterImplementation( BL );
      change := true;
    fi;
  od;
  if change then
    SetBetterImplementation( L, CombineImp( lists ) );
  fi;
end );

InstallMethod( LookupInfListImp, [ IsCombinationNListImp, IsPosInt ],
function( L, i )
  return List( Lists( L ), l -> LookupInfListImp( l, i ) );
end );

InstallMethod( KnownIndicesImp, [ IsCombinationNListImp ],
function( L )
  return Intersection( List( Lists( L ), KnownIndicesImp ) );
end );

InstallMethod( InfListString, [ IsRecord, IsCombinationNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, L, i, KnownIndicesImp( L ), reversed, [ shift, incr ] );
end );

InstallMethod( LiftList, [ IsObject, IsNList, IsFunction ],
function( init, L, f )
  return MakeInfList( LiftListImp( [ init ], Implementation( L ), f ) );
end );

InstallMethod( LiftListImp, [ IsDenseList, IsNListImp, IsFunction ],
function( init_list, BL, f )
  local L;
  L := MakeInfListImp( IsLiftingNListImp,
                       rec( values := ShallowCopy( init_list ) ),
                       [ BaseList, BL,
                         InitialValues, init_list,
                         LiftingFunction, f ] );
  NotifyBetterImplementation( BL, L );
  return L;
end );

InstallMethod( LiftListImp, [ IsDenseList, IsConcatNListImp, IsFunction ],
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
                          LookupInfListImp( BaseList( BL ), 1 ) ) ];
  fi;
  return ConcatenateImp( new_tail, LiftListImp( new_init_list, BaseList( BL ), f ) );
end );

InstallMethod( BetterImplementationAvailable, [ IsLiftingNListImp, IsNListImp ],
function( L, BL )
  if IsIdenticalObj( BL, BaseList( L ) ) then
    SetBetterImplementation( L, LiftListImp( L!.values, BetterImplementation( BL ),
                                             LiftingFunction( L ) ) );
  fi;
end );

InstallMethod( LookupInfListImp, [ IsLiftingNListImp, IsPosInt ],
function( L, i )
  local v, f, l, m, check_repeating, i1, i2;
  v := L!.values;
  f := LiftingFunction( L );
  if IsRepeatingNListImp( BaseList( L ) ) then
    m := Length( RepeatingList( BaseList( L ) ) );
    check_repeating := true;
  else
    m := 0;
    check_repeating := false;
  fi;
  while i > Length( v ) do
    l := Length( v );
    v[ l + 1 ] := f( v[ l ], LookupInfListImp( BaseList( L ), l + 1 ) );
    if check_repeating
       and ( l mod m ) = 0
       and ( l / m ) mod 2 = 1 then
      i1 := ( l + m ) / 2 - m + 1;
      i2 := l + 1;
      if v[ i1 ] = v[ i2 ] then
        SetBetterImplementation( L, Repeatify( L, i1, i2 ) );
        return LookupInfListImp( BetterImplementation( L ), i );
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
  newList := ConcatenateImp( tail, RepeatListImp( repeatedList ) );
  return newList;
end );

InstallMethod( KnownIndicesImp, [ IsLiftingNListImp ],
function( L )
  return [ 1 .. Length( L!.values ) ];
end );

InstallMethod( InfListString, [ IsRecord, IsLiftingNListImp, IsPosInt, IsBool, IsInt, IsInt ],
function( opt, L, i, reversed, shift, incr )
  return InfListString( opt, L, i, KnownIndicesImp( L ), reversed, [ shift, incr ] );
end );

InstallMethod( Sublist, [ IsNList, IsPosInt, IsPosInt ],
function( L, a, b )
  return SublistImp( Implementation( L ), a, b );
end );

InstallMethod( SublistImp, [ IsNListImp, IsPosInt, IsPosInt ],
function( L, a, b )
  return List( [ a .. ( b - 1 ) ], i -> LookupInfListImp( L, i ) );
end );

InstallMethod( Sublist, [ IsZList, IsInt, IsInt ],
function( L, a, b )
  return SublistImp( Implementation( L ), a, b );
end );

InstallMethod( SublistImp, [ IsZListImp, IsInt, IsInt ],
function( L, a, b )
  return List( [ a .. ( b - 1 ) ], i -> LookupInfListImp( L, i ) );
end );

InstallMethod( \[\], [ IsNList, IsPosInt ],
function( list, i )
  return LookupInfListImp( Implementation( list ), i );
end );

InstallMethod( \[\], [ IsZList, IsInt ],
function( list, i )
  return LookupInfListImp( Implementation( list ), i );
end );

# InstallValue( IntegersList, FunctionInfList( IdFunc ) );

InstallValue( PositiveIntegersList, ArithmeticSequence( 1, 1 ) );

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

InstallMethod( IsInductive, [ IsNList ],
               L -> IsInductive( Implementation( L ) ) );

InstallMethod( IsEventuallyInductive, [ IsNList ],
               L -> IsEventuallyInductive( Implementation( L ) ) );

InstallMethod( InductiveFromIndex, [ IsNList ],
               L -> InductiveFromIndex( Implementation( L ) ) );

InstallMethod( InductivePart, [ IsNList ],
               L -> MakeInfList( InductivePart( Implementation( L ) ) ) );

InstallMethod( InductivePart, [ IsNList and IsInductive ],
               IdFunc );

InstallMethod( InductionFunction, [ IsNList ],
               L -> InductionFunction( Implementation( L ) ) );

InstallTrueMethod( IsInductive, IsNListImp and HasInductionFunction );
InstallTrueMethod( IsEventuallyInductive, IsNListImp and IsInductive );

InstallMethod( InductiveFromIndex, [ IsNListImp ],
function( L )
  if IsInductive( L ) then return 1; fi;
  TryNextMethod();
end );

InstallMethod( InductivePart, [ IsNListImp ],
function( L )
  if IsInductive( L ) then return L; fi;
  TryNextMethod();
end );

InstallMethod( IsRepeating, [ IsNList ],
               L -> IsRepeating( Implementation( L ) ) );

InstallMethod( IsEventuallyRepeating, [ IsNList ],
               L -> IsEventuallyRepeating( Implementation( L ) ) );

InstallMethod( RepeatingFromIndex, [ IsNList ],
               L -> RepeatingFromIndex( Implementation( L ) ) );

InstallMethod( RepeatingPart, [ IsNList ],
               L -> MakeInfList( RepeatingPart( Implementation( L ) ) ) );

InstallMethod( RepeatingPart, [ IsNList and IsRepeating ],
               IdFunc );

InstallMethod( RepeatingList, [ IsNList ],
               L -> RepeatingList( Implementation( L ) ) );

InstallTrueMethod( IsRepeating, IsNListImp and HasRepeatingList );
InstallTrueMethod( IsEventuallyRepeating, IsNListImp and IsRepeating );

InstallMethod( RepeatingFromIndex, [ IsNListImp ],
function( L )
  if IsRepeating( L ) then return 1; fi;
  TryNextMethod();
end );

InstallMethod( RepeatingPart, [ IsNListImp ],
function( L )
  if IsRepeating( L ) then return L; fi;
  TryNextMethod();
end );




# ZList

InstallGlobalFunction( Concat,
function( arg )
  local first_list, middle_lists, last_list, all_but_first;
  if IsEmpty( arg ) then
    Error( "Needs at least one argument" );
  fi;
  first_list := arg[ 1 ];
  middle_lists := arg{ [ 2 .. Length( arg ) - 1 ] };
  last_list := arg[ Length( arg ) ];
  if not IsNList( last_list ) then
    Error( "Last argument must be N-list" );
  elif not ( IsNList( first_list ) or IsDenseList( first_list ) ) then
    Error( "First argument must be either N-list or dense list" );
  elif not ForAll( middle_lists, IsDenseList ) then
    Error( "All arguments except first and last must be dense lists" );
  fi;
  if Length( arg ) = 1 then
    return first_list;
  fi;
  all_but_first := Concatenate( Concatenation( middle_lists ),
                                last_list );
  return Concatenate( first_list, all_but_first );
end );

InstallMethod( Concatenate, [ IsNList, IsDenseList, IsNList ],
function( L1, middle, L2 )
  return MakeInfList( ConcatenateImp( Implementation( L1 ),
                                      middle,
                                      Implementation( L2 ) ) );
end );

InstallMethod( Concatenate, [ IsNList, IsNList ],
function( L1, L2 )
  return Concatenate( L1, [], L2 );
end );

InstallMethod( MakeConcatZListImp, [ IsNListImp, IsDenseList, IsNListImp, IsInt ],
function( neg, mid, pos, base )
  local L;
  L := MakeInfListImp( IsConcatZListImp,
                       rec(),
                       [ BasePosition, base,
                         NegativeList, neg,
                         MiddleList, mid,
                         PositiveList, pos ] );
  NotifyBetterImplementation( neg, L );
  NotifyBetterImplementation( pos, L );
  return L;
end );

InstallMethod( ConcatenateImp, [ IsNListImp, IsDenseList, IsNListImp ],
function( neg, mid, pos )
  return MakeConcatZListImp( neg, mid, pos, 0 );
end );

InstallMethod( ConcatenateImp, [ IsConcatNListImp, IsDenseList, IsNListImp ],
function( L1, middle, L2 )
  local middle_extra, C;
  middle_extra := Reversed( ConcatList( L1 ) );
  C := ConcatenateImp( BaseList( L1 ),
                       Concatenation( middle_extra, middle ),
                       L2 );
  return ShiftImp( C, Length( middle_extra ) );
end );

InstallMethod( ConcatenateImp, [ IsNListImp, IsDenseList, IsConcatNListImp ],
function( L1, middle, L2 )
  local middle_extra, C;
  middle_extra := ConcatList( L2 );
  return ConcatenateImp( L1, Concatenation( middle, middle_extra ),
                         BaseList( L2 ) );
  # return ShiftImp( C, -Length( middle_extra ) );
end );

InstallMethod( BetterImplementationAvailable, [ IsConcatZListImp, IsNListImp ],
function( L, NL )
  local pos, neg, change;
  pos := PositiveList( L );
  neg := NegativeList( L );
  change := false;
  if IsIdenticalObj( NL, pos ) then
    pos := BetterImplementation( NL );
    change := true;
  fi;
  if IsIdenticalObj( NL, neg ) then
    neg := BetterImplementation( NL );
    change := true;
  fi;
  if change then
    SetBetterImplementation( L, ConcatenateImp( neg, MiddleList( L ), pos ) );
  fi;
end );

InstallMethod( LookupInfListImp, [ IsConcatZListImp, IsInt ],
function( L, i )
  local b, mid;
  b := BasePosition( L );
  mid := MiddleList( L );
  if i >= b + Length( mid ) then
    return LookupInfListImp( PositiveList( L ),
                             i - ( b + Length( mid ) ) + 1 );
  elif i >= b then
    return mid[ i - b + 1 ];
  else
    return LookupInfListImp( NegativeList( L ), b - i );
  fi;
  # if i >= b then
  #   return LookupInfListImp( PositiveList( L ),
  #                            i - b + 1 );
  # elif i >= b - Length( mid ) then
  #   return mid[ i - b + Length( mid ) + 1 ];
  # else
  #   return LookupInfListImp( NegativeList( L ),
  #                            b - Length( mid ) - i );
  # fi;
end );

InstallMethod( KnownIndicesImp, [ IsConcatZListImp ],
function( L )
  return []; #TODO
end );

InstallMethod( InfListString, [ IsRecord, IsConcatZListImp, IsBool, IsInt, IsInt ],
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

InstallMethod( Shift, [ IsZList, IsInt ],
function( L, i )
  return MakeInfList( ShiftImp( Implementation( L ), i ) );
end );

InstallMethod( ShiftImp, [ IsConcatZListImp, IsInt ],
function( L, i )
  return MakeConcatZListImp( NegativeList( L ), MiddleList( L ), PositiveList( L ),
                             BasePosition( L ) - i );
end );

InstallMethod( MapImp, [ IsConcatZListImp, IsFunction ],
function( L, f )
  return MakeConcatZListImp
         ( MapImp( NegativeList( L ), f ),
           List( MiddleList( L ), f ),
           MapImp( PositiveList( L ), f ),
           BasePosition( L ) );
end );

InstallMethod( ZRepeatList, [ IsDenseList ],
function( list )
  return MakeInfList( ZRepeatListImp( list ) );
end );

InstallMethod( ZRepeatListImp, [ IsDenseList ],
function( list )
  return MakeInfListImp( IsRepeatingZListImp,
                         rec(),
                         [ BasePosition, 0,
                           RepeatingList, list ] );
end );

InstallMethod( BetterImplementationAvailable, [ IsRepeatingZListImp, IsNListImp ],
function( L, NL ) end );

InstallMethod( LookupInfListImp, [ IsRepeatingZListImp, IsInt ],
function( L, i )
  local rep_list, base;
  rep_list := RepeatingList( L );
  base := BasePosition( L );
  return rep_list[ ( i - base ) mod Length( rep_list ) + 1 ];
end );

InstallMethod( KnownIndicesImp, [ IsRepeatingZListImp ],
function( L )
  return []; # TODO return IntegersList
end );

InstallMethod( InfListString, [ IsRecord, IsRepeatingZListImp, IsBool, IsInt, IsInt ],
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

InstallMethod( ShiftImp, [ IsRepeatingZListImp, IsInt ],
function( L, i )
  return ZRepeatListImp( RotateLeft( RepeatingList( L ), i ) );
end );

InstallMethod( ShiftImp, [ IsRepeatingZListImp, IsInt and IsZero ],
function( L, i )
  return L;
end );

InstallValue( AlternatingSignList, ZRepeatList( [ 1, -1 ] ) );

InstallMethod( ZArithmeticSequence, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfList( ZArithmeticSequenceImp( init, incr ) );
end );

InstallMethod( ZArithmeticSequenceImp, [ IsInt, IsInt ],
function( init, incr )
  return MakeInfListImp( IsArithmeticZListImp,
                         rec(),
                         [ InitialValue, init,
                           Increment, incr ] );
end );

InstallMethod( BetterImplementationAvailable, [ IsArithmeticZListImp, IsZListImp ],
function( L, BL ) end );

InstallMethod( LookupInfListImp, [ IsArithmeticZListImp, IsInt ],
function( L, i )
  return InitialValue( L ) + i * Increment( L );
end );

InstallMethod( KnownIndicesImp, [ IsArithmeticZListImp ],
function( L )
  return PositiveIntegersList;
end );

InstallMethod( InfListString, [ IsRecord, IsArithmeticZListImp, IsBool, IsInt, IsInt ],
function( opt, L, reversed, shift, incr )
  local str_list, str;
  str_list := ListN( [ -2 .. 3 ] * incr + shift,
                     SublistImp( L, -2, 3 ),
                     opt.format_value );
  if reversed then str_list := Reversed( str_list ); fi;
  str := JoinStringsWithSeparator( str_list, opt.separator );
  return Concatenation( opt.ellipsis, opt.separator,
                        str,
                        opt.separator, opt.ellipsis );
end );

InstallMethod( ShiftImp, [ IsArithmeticZListImp, IsInt ],
function( L, i )
  return ZArithmeticSequenceImp( InitialValue( L ) + i * Increment( L ),
                                 Increment( L ) );
end );

InstallValue( IntegersList, ZArithmeticSequence( 0, 1 ) );
