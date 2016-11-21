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
#c
BindGlobal( "CHAIN_OR_COCHAIN_COMPLEX_CATEGORY",
##
function( cat, shift_index )
  local   name,  complex_cat,  addition_for_morphisms,  
          additive_inverse_for_morphisms,  pre_compose,  
          identity_morphism,  inverse,  lift_along_monomorphism,  
          colift_along_epimorphism,  kernel_embedding,  
          cokernel_projection,  direct_sum,  injection_of_cofactor,  
          projection_in_factor;
#c
  if shift_index = -1 then 
  name := Concatenation( "Chain complexes category over ", Name( cat ) );
  complex_cat := CreateCapCategory( name );
  SetFilterObj( complex_cat, IsChainComplexCategory );
  elif shift_index = 1 then
  name := Concatenation( "Cochain complexes category over ", Name( cat ) );
  complex_cat := CreateCapCategory( name );
  SetFilterObj( complex_cat, IsCochainComplexCategory );
  else
    Error( "The second argument must be either -1( to construct the chain complexes category ) or 1( to contruct the cochain complexes category )" );
  fi;
##
  SetUnderlyingCategory( complex_cat, cat );

  if HasIsAbelianCategory( cat ) and IsAbelianCategory( cat ) then
    SetIsAbelianCategory( complex_cat, true );
  fi;

  # TODO
  #AddIsEqualForObjects( complex_cat, 
  #AddIsEqualForMorphisms( complex_cat, 

  #c
  AddZeroObject( complex_cat, function( ) return ZeroComplex( cat ); end );
  ##

  AddZeroMorphism( complex_cat, ZeroChainMap );

  addition_for_morphisms := function( m1, m2 )
    local morphisms;
    morphisms := Map( [ MorphismsOfChainMap( m1 ),
                        MorphismsOfChainMap( m2 ) ],
                      AdditionForMorphisms );
    return ChainMapByMorphismList( Source( m1 ), Range( m1 ),
                                   morphisms );
  end;
  AddAdditionForMorphisms( complex_cat, addition_for_morphisms );

  additive_inverse_for_morphisms := function( map )
    local morphisms;
    morphisms := Map( MorphismsOfChainMap( map ),
                      AdditiveInverseForMorphisms );
    return ChainMapByMorphismList( Source( map ), Range( map ),
                                   morphisms );
  end;
  AddAdditiveInverseForMorphisms( complex_cat, additive_inverse_for_morphisms );

  pre_compose := function( m1, m2 )
    local morphisms;
    morphisms := Map( [ MorphismsOfChainMap( m1 ),
                        MorphismsOfChainMap( m2 ) ],
                      PreCompose );
    return ChainMapByMorphismList( Source( m1 ), Range( m2 ),
                                   morphisms );
  end;
  AddPreCompose( complex_cat, pre_compose );

  identity_morphism := function( C )
    local morphisms;
    morphisms := Map( DifferentialsOfComplex( C ),
                      d -> IdentityMorphism( Source( d ) ) );
    return ChainMapByMorphismList( C, C, morphisms );
  end;
  AddIdentityMorphism( complex_cat, identity_morphism );

  inverse := function( iso )
    local morphisms;
    morphisms := Map( MorphismsOfChainMap( iso ), Inverse );
    return ChainMapByMorphismList( Range( iso ), Source( iso ),
                                   morphisms );
  end;
  AddInverse( complex_cat, inverse );

  lift_along_monomorphism := function( mono, test )
    local morphisms;
    morphisms := Map( [ MorphismsOfChainMap( mono ),
                        MorphismsOfChainMap( test ) ],
                      LiftAlongMonomorphism );
    return ChainMapByMorphismList( Source( test ), Source( mono ),
                                   morphisms );
  end;
  AddLiftAlongMonomorphism( complex_cat, lift_along_monomorphism );
  
  #c
  colift_along_epimorphism := function( epi, test )
    local morphisms;
    morphisms := Map( [ MorphismsOfChainMap( epi ),
                        MorphismsOfChainMap( test ) ],
                      ColiftAlongEpimorphism );
    return ChainMapByMorphismList( Range( epi ), Range( test ),
                                   morphisms );
  end;
  ##

  AddColiftAlongEpimorphism( complex_cat, colift_along_epimorphism );

  kernel_embedding := function( map )
    local   embeddings,  kernel_to_next_source,  diffs,
            kernel_complex,  kernel_emb;
    embeddings := Map( MorphismsOfChainMap( map ), KernelEmbedding );
    kernel_to_next_source :=
      Map( [ embeddings, DifferentialsOfComplex( Source( map ) ) ],
           PreCompose );
    diffs :=
      Map( [ Shift( MorphismsOfChainMap( map ), shift_index ),
             kernel_to_next_source ],
           KernelLift );
    #cat := UnderlyingCategory( CapCategory( map ) );
    kernel_complex := ComplexByDifferentialList( cat, diffs );
    kernel_emb := ChainMapByMorphismList( kernel_complex, Source( map ),
                                          embeddings );
    return kernel_emb;
  end;
  if CanCompute( cat, "KernelEmbedding" ) and CanCompute( cat, "KernelLift" ) then
    AddKernelEmbedding( complex_cat, kernel_embedding );
  fi;

  #c
  cokernel_projection := function( map )
    local   projections,  range_to_next_cokernel,  diffs,
            cokernel_complex,  cokernel_proj;
    projections := Map( MorphismsOfChainMap( map ), CokernelProjection );
    range_to_next_cokernel :=
      Map( [ DifferentialsOfComplex( Range( map ) ),
             Shift( projections, shift_index ) ],
           PreCompose );
    diffs :=
      Map( [ MorphismsOfChainMap( map ),
             range_to_next_cokernel ],
              CokernelColift );
    #cat := UnderlyingCategory( CapCategory( map ) );
    cokernel_complex := ComplexByDifferentialList( cat, diffs );
    cokernel_proj := ChainMapByMorphismList( Range( map ), cokernel_complex,
                                             projections );
    return cokernel_proj;
  end;
  ##

  if CanCompute( cat, "CokernelProjection" ) and CanCompute( cat, "CokernelColift" ) then
    AddCokernelProjection( complex_cat, cokernel_projection );
  fi;

  direct_sum := function( complexes )
    local diffs;
    diffs := Map( Combine( List( complexes, DifferentialsOfComplex ) ),
                  DirectSumFunctorial );
    #cat := UnderlyingCategory( CapCategory( complexes[ 1 ] ) );
    return ComplexByDifferentialList( cat, diffs );
  end;
  AddDirectSum( complex_cat, direct_sum );

  injection_of_cofactor := function( complexes, i, sum_complex )
    local morphisms;
    morphisms := Map( [ Combine( List( complexes, ObjectsOfComplex ) ),
                        ObjectsOfComplex( sum_complex ) ],
                      function( summands, sum )
                        return InjectionOfCofactorOfDirectSumWithGivenDirectSum
                               ( summands, i, sum );
                      end );
    return ChainMapByMorphismList( complexes[ i ], sum_complex,
                                   morphisms );
  end;
  AddInjectionOfCofactorOfDirectSumWithGivenDirectSum
    ( complex_cat, injection_of_cofactor );

  projection_in_factor := function( complexes, i, sum_complex )
    local morphisms;
    morphisms := Map( [ Combine( List( complexes, ObjectsOfComplex ) ),
                        ObjectsOfComplex( sum_complex ) ],
                      function( summands, sum )
                        return ProjectionInFactorOfDirectSumWithGivenDirectSum
                               ( summands, i, sum );
                      end );
    return ChainMapByMorphismList( sum_complex, complexes[ i ],
                                   morphisms );
  end;
  AddProjectionInFactorOfDirectSumWithGivenDirectSum
    ( complex_cat, projection_in_factor );

 ## Terminal and initial objects

 #n
 if CanCompute( cat, "TerminalObject" ) then
 AddTerminalObject( complex_cat, function( )
                                 local terminal_obj_functorial, terminal_obj_differentials;
                                 terminal_obj_functorial := TerminalObjectFunctorial( cat );
                                 terminal_obj_differentials := RepeatListZ( [ terminal_obj_functorial ] );
                                 return ComplexByDifferentialList( cat, terminal_obj_differentials, false );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "UniversalMorphismIntoTerminalObject" ) then
 AddUniversalMorphismIntoTerminalObjectWithGivenTerminalObject( complex_cat,
                                 function( complex, terminal_obj )
                                 local objects, universal_maps;
                                 objects := ObjectsOfComplex( complex );
                                 universal_maps := Map( objects,  UniversalMorphismIntoTerminalObject );
                                 return ChainMapByMorphismList( complex, terminal_obj, universal_maps );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "InitialObject" ) then
 AddInitialObject( complex_cat, function( )
                                 local initial_obj_functorial, initial_obj_differentials;
                                 initial_obj_functorial := InitialObjectFunctorial( cat );
                                 initial_obj_differentials := RepeatListZ( [ initial_obj_functorial ] );
                                 return ComplexByDifferentialList( cat, initial_obj_differentials, false );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "UniversalMorphismFromInitialObject" ) then
 AddUniversalMorphismFromInitialObjectWithGivenInitialObject( complex_cat,
                                 function( complex, initial_object )
                                 local objects, universal_maps;
                                 objects := ObjectsOfComplex( complex );
                                 universal_maps := Map( objects,  UniversalMorphismFromInitialObject );
                                 return ChainMapByMorphismList( complex, initial_object, universal_maps );
                                 end );
 fi;
 ##

 #TODO


  Finalize( complex_cat );
  return complex_cat;
end );

#########################################
#
#  Constructors of (Co)complexes category
#
#########################################

#n
InstallMethod( ChainComplexCategory, 
                 [ IsCapCategory ],
  function( cat )
  return CHAIN_OR_COCHAIN_COMPLEX_CATEGORY( cat, -1 );
end );
##

#n
InstallMethod( CochainComplexCategory, 
                 [ IsCapCategory ],
  function( cat )
  return CHAIN_OR_COCHAIN_COMPLEX_CATEGORY( cat, 1 );
end );
##

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
  Add( ComplexCategory( cat ), C );
  return C;
end );

InstallMethod( ObjectsOfComplex, [ IsChainComplex ],
function( C )
  return Map( DifferentialsOfComplex( C ), Source );
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
  return ComplexByDifferentialList( cat, RepeatListZ( [ zero_map ] ), false );
end );

InstallMethod( FiniteComplex, [ IsAbelianCategory, IsDenseList ],
function( cat, diffs )
  local zero, zero_map, zero_part, n;
  zero := ZeroObject( cat );
  zero_map := ZeroMorphism( zero, zero );
  zero_part := RepeatListN( [ zero_map ] );
  n := Length( diffs );
  if not IsZeroForObjects( Source( diffs[ n ] ) ) then
    diffs := Concatenation( diffs,
                            [ ZeroMorphism( zero, Source( diffs[ n ] ) ) ] );
  fi;
  if not IsZeroForObjects( Range( diffs[ 1 ] ) ) then
    diffs := Concatenation( [ ZeroMorphism( Range( diffs[ 1 ] ), zero ) ],
                            diffs );
  fi;
  return ComplexByDifferentialList( cat, Concatenate( zero_part, diffs, zero_part ) );
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
  zero_part := RepeatListN( [ zero_map ] );
  # d_{-1}:
  d_1 := ZeroMorphism( Range( d0 ), ZeroObject( cat ) );
  # this places d_1 in degree 0:
  diffs := Concatenate( zero_part, [ d_1 ], InductiveList( d0, f ) );
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

# InstallMethod( ViewObj, [ IsChainComplex ],
# function( C )
#   Print( String( C ) );
# end );

InstallMethod( SetString, [ IsChainComplex, IsString ],
               function( L, str ) end );


