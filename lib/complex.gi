DeclareRepresentation( "IsChainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainComplexes",
            NewFamily( "chain complexes" ) );

InstallValue( ComplexSingleAssertions,
[ [ function( C, i, d )
      return MorphismFilter( CatOfComplex( C ) )( d );
    end,
    "differentials must be morphisms in the category" ] ] );
InstallValue( ComplexDoubleAssertions,
[ [ function( C, i, d0, d1 )
      local cat;
      cat := CatOfComplex( C );
      return Range( d1 ) = Source( d0 );
    end,
    "differentials must be composable" ],
  [ function( C, i, d0, d1 )
      local cat;
      cat := CatOfComplex( C );
      return IsZeroForMorphisms( PostCompose( d0, d1 ) );
    end,
    "differentials must compose to zero" ] ] );

InstallMethod( ComplexByDifferentialList, [ IsAbelianCategory, IsZList ],
function( cat, diffs )
  return ComplexByDifferentialList( cat, diffs, true );
end );

InstallMethod( ComplexByDifferentialList, [ IsAbelianCategory, IsZList, IsBool ],
function( cat, diffs, make_assertions )
  local type, C, assertion, f, msg;
  type := NewType( FamilyOfChainComplexes,
                   IsChainComplex and IsChainComplexRep );
  C := rec();
  ObjectifyWithAttributes( C, type,
                           CatOfComplex, cat,
                           DifferentialsOfComplex, diffs );
  if make_assertions then
    for assertion in ComplexSingleAssertions do
      f := assertion[ 1 ];
      msg := assertion[ 2 ];
      AddAssertion( diffs, MakeSingleAssertion( C, f, msg ) );
    od;
    for assertion in ComplexDoubleAssertions do
      f := assertion[ 1 ];
      msg := assertion[ 2 ];
      AddAssertion( diffs, MakeDoubleAssertion( C, f, msg ) );
    od;
  fi;
  return C;
end );

InstallMethod( DifferentialOfComplex, [ IsChainComplex, IsInt ],
function( C, i )
  return DifferentialsOfComplex( C )[ i ];
end );

InstallMethod( \^, [ IsChainComplex, IsInt ],
function( C, i )
  return DifferentialOfComplex( C, i );
end );

InstallMethod( ObjectOfComplex, [ IsChainComplex, IsInt ],
function( C, i )
  return Source( DifferentialOfComplex( C, i ) );
end );

InstallMethod( \[\], [ IsChainComplex, IsInt ],
function( C, i )
  return ObjectOfComplex( C, i );
end );

InstallMethod( CyclesOfComplex, [ IsChainComplex, IsInt ],
function( C, i )
  local cat;
  cat := CatOfComplex( C );
  return KernelEmbedding( DifferentialOfComplex( C, i ) );
end );

InstallMethod( BoundariesOfComplex, [ IsChainComplex, IsInt ],
function( C, i )
  local cat;
  cat := CatOfComplex( C );
  return ImageEmbedding( DifferentialOfComplex( C, i + 1 ) );
end );

InstallMethod( HomologyOfComplex, [ IsChainComplex, IsInt ],
function( C, i )
  local cat, im, d, inc;
  cat := CatOfComplex( C );
  im := BoundariesOfComplex( C, i );
  d := DifferentialOfComplex( C, i );
  inc := KernelLift( d, im );
  return CokernelObject( inc );
end );

InstallMethod( ZeroComplex, [ IsAbelianCategory ],
function( cat )
  local zero_map;
  zero_map := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
  return ComplexByDifferentialList( cat, ZRepeatList( [ zero_map ] ), false );
end );

InstallMethod( FiniteComplex, [ IsAbelianCategory, IsDenseList ],
function( cat, diffs )
  local zero, zero_map, zero_part, n;
  zero := ZeroObject( cat );
  zero_map := ZeroMorphism( zero, zero );
  zero_part := RepeatList( [ zero_map ] );
  n := Length( diffs );
  if not IsZeroForObjects( Source( diffs[ n ] ) ) then
    diffs := Concatenation( diffs,
                            [ ZeroMorphism( zero, Source( diffs[ n ] ) ) ] );
  fi;
  if not IsZeroForObjects( Range( diffs[ 1 ] ) ) then
    diffs := Concatenation( [ ZeroMorphism( Range( diffs[ 1 ] ), zero ) ],
                            diffs );
  fi;
  return ComplexByDifferentialList( cat, Concat( zero_part, diffs, zero_part ) );
end );

InstallMethod( StalkComplex, [ IsAbelianCategory, IsObject ],
function( cat, obj )
  return FiniteComplex( cat,
                        [ ZeroMorphism( obj, ZeroObject( cat ) ),
                          ZeroMorphism( ZeroObject( cat ), obj ) ] );
end );

# TODO ShortExactSequence

InstallMethod( InductiveComplex, [ IsAbelianCategory, IsObject, IsFunction ],
function( cat, d0, f )
  local zero_map, zero_part, d_1, diffs;
  zero_map := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
  zero_part := RepeatList( [ zero_map ] );
  # d_{-1}:
  d_1 := ZeroMorphism( Range( d0 ), ZeroObject( cat ) );
  # this places d_1 in degree 0:
  diffs := Concat( zero_part, [ d_1 ], InductiveList( d0, f ) );
  # shift to get d0 in degree 0:
  diffs := Shift( diffs, 1 );
  return ComplexByDifferentialList( cat, diffs );
end );

InstallMethod( Resolution, [ IsAbelianCategory, IsObject, IsFunction ],
function( cat, obj, f )
  local d0, next_d;
  d0 := ZeroMorphism( obj, ZeroObject( cat ) );
  next_d := function( d )
    local ker, K, p;
    ker := KernelEmbedding( d );
    K := Source( ker );
    p := f( K );
    return PostCompose( ker, p );
  end;
  return InductiveComplex( cat, d0, next_d );
end );

# InstallMethod( Resolution, [ IsAbelianCategory, IsObject, IsFunction ],
# function( cat, obj, f )
#   local d0, d1, next_d;
#   zero := ZeroObject( cat );
#   zero_map := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
#   zero_part := RepeatList( zero_map );
#   d0 := ZeroMorphism( obj, zero );
#   d1 := f( obj );
#   next_d := function( d )
#     local ker, K, p;
#     ker := KernelEmb( d );
#     K := Source( ker );
#     p := f( K );
#     return PostCompose( ker, p );
#   end;
#   diffs := Concat( zero_part, [ d0 ],
#                    InductiveList( d1, next_d ) );
#   return ComplexByDifferentialList( cat, diffs );
# end );

InstallMethod( Shift, [ IsChainComplex, IsInt ],
function( C, i )
  local newDifferentials;
  newDifferentials := Shift( DifferentialsOfComplex( C ), i );
  if i mod 2 = 1 then
    newDifferentials := Map( newDifferentials, d -> -d );
  fi;
  return ComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
end );

InstallMethod( ShiftUnsigned, [ IsChainComplex, IsInt ],
function( C, i )
  local newDifferentials;
  newDifferentials := Shift( DifferentialsOfComplex( C ), i );
  return ComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
end );

InstallMethod( String, [ IsChainComplex ],
function( C )
  local cat, opt;
  cat := CatOfComplex( C );
  opt := rec( format_value :=
              function( i, d )
                return Concatenation( String( i ), ":",
                                      String( Source( d ) ),
                                      " ->" );
              end,
              separator := " ",
              repeat_start_left := "[ ",
              repeat_start_right := " ]",
              repeat_end_left := "[ ",
              repeat_end_right := " ]",
              ellipsis := "---" );
  return InfListString( opt, DifferentialsOfComplex( C ), true );
end );

InstallMethod( SetString, [ IsChainComplex, IsString ],
               function( L, str ) end );


