DeclareRepresentation( "IsChainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainComplexes",
            NewFamily( "chain complexes" ) );

InstallValue( ComplexSingleAssertions,
[ [ function( C, i, d ) return MorphismInCat( CatOfComplex( C ), d ); end,
    "differentials must be morphisms in the category" ] ] );
InstallValue( ComplexDoubleAssertions,
[ [ function( C, i, d0, d1 )
      local cat;
      cat := CatOfComplex( C );
      return CodomainOfMorphism( cat, d1 ) = DomainOfMorphism( cat, d0 );
    end,
    "differentials must be composable" ],
  [ function( C, i, d0, d1 )
      local cat;
      cat := CatOfComplex( C );
      return IsZeroMorphism( cat, Compose( cat, d0, d1 ) );
    end,
    "differentials must compose to zero" ] ] );

InstallMethod( ComplexByDifferentialList, [ IsAbelianCat, IsZList ],
function( cat, diffs )
  return ComplexByDifferentialList( cat, diffs, true );
end );

InstallMethod( ComplexByDifferentialList, [ IsAbelianCat, IsZList, IsBool ],
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

InstallMethod( ZeroComplex, [ IsAbelianCat ],
function( cat )
  local zero_map;
  zero_map := ZeroMorphism( cat, ZeroObject( cat ), ZeroObject( cat ) );
  return ComplexByDifferentialList( cat, ZRepeatList( [ zero_map ] ), false );
end );

InstallMethod( FiniteComplex, [ IsAbelianCat, IsDenseList ],
function( cat, diffs )
  local zero, zero_map, zero_part, n;
  zero := ZeroObject( cat );
  zero_map := ZeroMorphism( cat, zero, zero );
  zero_part := RepeatList( [ zero_map ] );
  n := Length( diffs );
  if not IsZeroObject( cat, DomainOfMorphism( cat, diffs[ n ] ) ) then
    diffs := Concatenation( diffs,
                            [ ZeroMorphism( cat, zero, DomainOfMorphism( cat, diffs[ n ] ) ) ] );
  fi;
  if not IsZeroObject( cat, CodomainOfMorphism( cat, diffs[ 1 ] ) ) then
    diffs := Concatenation( [ ZeroMorphism( cat, CodomainOfMorphism( cat, diffs[ 1 ] ), zero ) ],
                            diffs );
  fi;
  return ComplexByDifferentialList( cat, Concat( zero_part, diffs, zero_part ) );
end );

InstallMethod( StalkComplex, [ IsAbelianCat, IsObject ],
function( cat, obj )
  return FiniteComplex( cat,
                        [ ZeroMorphism( cat, obj, ZeroObject( cat ) ),
                          ZeroMorphism( cat, ZeroObject( cat ), obj ) ] );
end );

# TODO ShortExactSequence

InstallMethod( InductiveComplex, [ IsAbelianCat, IsObject, IsFunction ],
function( cat, d0, f )
  local zero_map, zero_part, d_1, diffs;
  zero_map := ZeroMorphism( cat, ZeroObject( cat ), ZeroObject( cat ) );
  zero_part := RepeatList( [ zero_map ] );
  d_1 := ZeroMorphism( cat, CodomainOfMorphism( cat, d0 ), ZeroObject( cat ) );
  diffs := Concat( zero_part, [ d_1 ], InductiveList( d0, f ) );
  return ComplexByDifferentialList( cat, diffs );
end );

InstallMethod( Resolution, [ IsAbelianCat, IsObject, IsFunction ],
function( cat, obj, f )
  local d0, next_d;
  d0 := ZeroMorphism( cat, obj, ZeroObject( cat ) );
  next_d := function( d )
    local ker, K, p;
    ker := KernelOfMorphism( cat, d );
    K := DomainOfMorphism( cat, ker );
    p := f( K );
    return Compose( cat, ker, p );
  end;
  return InductiveComplex( cat, d0, next_d );
end );

# InstallMethod( Resolution, [ IsAbelianCat, IsObject, IsFunction ],
# function( cat, obj, f )
#   local d0, d1, next_d;
#   zero := ZeroObject( cat );
#   zero_map := ZeroMorphism( cat, ZeroObject( cat ), ZeroObject( cat ) );
#   zero_part := RepeatList( zero_map );
#   d0 := ZeroMorphism( cat, obj, zero );
#   d1 := f( obj );
#   next_d := function( d )
#     local ker, K, p;
#     ker := KernelOfMorphism( cat, d );
#     K := DomainOfMorphism( cat, ker );
#     p := f( K );
#     return Compose( cat, ker, p );
#   end;
#   diffs := Concat( zero_part, [ d0 ],
#                    InductiveList( d1, next_d ) );
#   return ComplexByDifferentialList( cat, diffs );
# end );
