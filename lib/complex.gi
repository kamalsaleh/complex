

#############################################
#
#  Representations, families and types 
#
#############################################


DeclareRepresentation( "IsChainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

DeclareRepresentation( "IsCochainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainComplexes",
            NewFamily( "chain complexes" ) );


BindGlobal( "FamilyOfCochainComplexes",
            NewFamily( "cochain complexes" ) );

BindGlobal( "TheTypeOfChainComplexes",
            NewType( FamilyOfChainComplexes,
                     IsChainComplex and IsChainComplexRep ) );

BindGlobal( "TheTypeOfCochainComplexes",
            NewType( FamilyOfCochainComplexes,
                     IsCochainComplex and IsCochainComplexRep ) );


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
          projection_in_factor, complex_constructor, maps_constructor;
#c
  if shift_index = -1 then 
  name := Concatenation( "Chain complexes category over ", Name( cat ) );
  complex_cat := CreateCapCategory( name );
  SetFilterObj( complex_cat, IsChainComplexCategory );
  complex_constructor := ChainComplexByDifferentialList;
  maps_constructor := ChainMapByMorphismList;
  elif shift_index = 1 then
  name := Concatenation( "Cochain complexes category over ", Name( cat ) );
  complex_cat := CreateCapCategory( name );
  SetFilterObj( complex_cat, IsCochainComplexCategory );
  complex_constructor := CochainComplexByDifferentialList;
  maps_constructor := CochainMapByMorphismList;
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
  AddZeroObject( complex_cat, 
    function( ) 
    local zero_map, zero_complex;
    zero_map := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
    zero_complex := complex_constructor( cat, RepeatListZ( [ zero_map ] ), false );
    SetUpperBound( zero_complex, 0 );
    SetLowerBound( zero_complex, 0 );
    return zero_complex;
    end );
  ##

  #c
  AddZeroMorphism( complex_cat, ZeroMap );
  ##

  addition_for_morphisms := function( m1, m2 )
    local morphisms, map;
    morphisms := Map( [ MorphismsOfMap( m1 ),
                        MorphismsOfMap( m2 ) ],
                      AdditionForMorphisms );
    map := maps_constructor( Source( m1 ), Range( m1 ),
                                   morphisms );
    
    if HasActiveUpperBound( m1 ) and HasActiveUpperBound( m2 ) then 
       SetUpperBound( map, Maximum( ActiveUpperBound( m1 ), ActiveUpperBound( m2 ) ) );
    fi;
    
    if HasActiveLowerBound( m1 ) and HasActiveLowerBound( m2 ) then 
       SetLowerBound( map, Minimum( ActiveLowerBound( m1 ), ActiveLowerBound( m2 ) ) );
    fi;
    
    return map;
  end;
  AddAdditionForMorphisms( complex_cat, addition_for_morphisms );

  additive_inverse_for_morphisms := function( map )
    local morphisms;
    morphisms := Map( MorphismsOfMap( map ),
                      AdditiveInverseForMorphisms );
    return maps_constructor( Source( map ), Range( map ),
                                   morphisms );
  end;
  AddAdditiveInverseForMorphisms( complex_cat, additive_inverse_for_morphisms );

  pre_compose := function( m1, m2 )
    local morphisms, map;
    morphisms := Map( [ MorphismsOfMap( m1 ),
                        MorphismsOfMap( m2 ) ],
                      PreCompose );
    map := maps_constructor( Source( m1 ), Range( m2 ),
                                   morphisms );
       
    if HasActiveUpperBound( m1 ) and HasActiveUpperBound( m2 ) then 
       SetUpperBound( map, Minimum( ActiveUpperBound( m1 ), ActiveUpperBound( m2 ) ) );
    elif HasActiveUpperBound( m1 ) then 
       SetUpperBound( map, ActiveUpperBound( m1 ) );
    elif HasActiveUpperBound( m2 ) then 
       SetUpperBound( map, ActiveUpperBound( m2 ) );
    fi;
    
    if HasActiveLowerBound( m1 ) and HasActiveLowerBound( m2 ) then 
       SetLowerBound( map, Maximum( ActiveLowerBound( m1 ), ActiveLowerBound( m2 ) ) );
    elif HasActiveLowerBound( m1 ) then 
       SetLowerBound( map, ActiveLowerBound( m1 ) );
    elif HasActiveLowerBound( m2 ) then 
       SetLowerBound( map, ActiveLowerBound( m2 ) );
    fi;
    
    return map;
  end;
  
  AddPreCompose( complex_cat, pre_compose );

  identity_morphism := function( C )
    local morphisms;
    morphisms := Map( Differentials( C ),
                      d -> IdentityMorphism( Source( d ) ) );
    return maps_constructor( C, C, morphisms );
  end;
  AddIdentityMorphism( complex_cat, identity_morphism );

  inverse := function( iso )
    local morphisms, map;
    morphisms := Map( MorphismsOfMap( iso ), Inverse );
    map := maps_constructor( Range( iso ), Source( iso ),
                                   morphisms );
    if HasActiveUpperBound( iso ) then 
       SetUpperBound( map, ActiveUpperBound( iso ) );
    fi;

    if HasActiveLowerBound( iso ) then 
       SetLowerBound( map, ActiveLowerBound( iso ) );
    fi;
    return map;
  end;
  
  AddInverse( complex_cat, inverse );

  lift_along_monomorphism := function( mono, test )
    local morphisms;
    morphisms := Map( [ MorphismsOfMap( mono ),
                        MorphismsOfMap( test ) ],
                      LiftAlongMonomorphism );
    return maps_constructor( Source( test ), Source( mono ),
                                   morphisms );
  end;
  AddLiftAlongMonomorphism( complex_cat, lift_along_monomorphism );
  
  #c
  colift_along_epimorphism := function( epi, test )
    local morphisms;
    morphisms := Map( [ MorphismsOfMap( epi ),
                        MorphismsOfMap( test ) ],
                      ColiftAlongEpimorphism );
    return maps_constructor( Range( epi ), Range( test ),
                                   morphisms );
  end;
  ##

  AddColiftAlongEpimorphism( complex_cat, colift_along_epimorphism );

  kernel_embedding := function( map )
    local   embeddings,  kernel_to_next_source,  diffs,
            kernel_complex,  kernel_emb;
    embeddings := Map( MorphismsOfMap( map ), KernelEmbedding );
    kernel_to_next_source :=
      Map( [ embeddings, Differentials( Source( map ) ) ],
           PreCompose );
    diffs :=
      Map( [ Shift( MorphismsOfMap( map ), shift_index ),
             kernel_to_next_source ],
           KernelLift );
    #cat := UnderlyingCategory( CapCategory( map ) );
    kernel_complex := complex_constructor( cat, diffs );
    kernel_emb := maps_constructor( kernel_complex, Source( map ),
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
    projections := Map( MorphismsOfMap( map ), CokernelProjection );
    range_to_next_cokernel :=
      Map( [ Differentials( Range( map ) ),
             Shift( projections, shift_index ) ],
           PreCompose );
    diffs :=
      Map( [ MorphismsOfMap( map ),
             range_to_next_cokernel ],
              CokernelColift );
    #cat := UnderlyingCategory( CapCategory( map ) );
    cokernel_complex := complex_constructor( cat, diffs );
    cokernel_proj := maps_constructor( Range( map ), cokernel_complex,
                                             projections );
    return cokernel_proj;
  end;
  ##

  if CanCompute( cat, "CokernelProjection" ) and CanCompute( cat, "CokernelColift" ) then
    AddCokernelProjection( complex_cat, cokernel_projection );
  fi;

  direct_sum := function( complexes )
    local C, diffs;

    diffs := Map( Combine( List( complexes, Differentials ) ),
                  DirectSumFunctorial );
    #cat := UnderlyingCategory( CapCategory( complexes[ 1 ] ) );
    C := complex_constructor( cat, diffs );
    
    if ForAll( complexes, u -> HasActiveUpperBound( u ) ) then 
       SetUpperBound( C, Maximum( List( complexes, C -> ActiveUpperBound( C ) ) ) );
    fi;
    
    if ForAll( complexes, u -> HasActiveLowerBound( u ) ) then 
       SetLowerBound( C, Minimum( List( complexes, C -> ActiveLowerBound( C ) ) ) );
    fi;
    
    return C;
  end;
  
  AddDirectSum( complex_cat, direct_sum );

  injection_of_cofactor := function( complexes, i, sum_complex )
    local morphisms;
    morphisms := Map( [ Combine( List( complexes, Objects ) ),
                        Objects( sum_complex ) ],
                      function( summands, sum )
                        return InjectionOfCofactorOfDirectSumWithGivenDirectSum
                               ( summands, i, sum );
                      end );
    return maps_constructor( complexes[ i ], sum_complex,
                                   morphisms );
  end;
  AddInjectionOfCofactorOfDirectSumWithGivenDirectSum
    ( complex_cat, injection_of_cofactor );

  projection_in_factor := function( complexes, i, sum_complex )
    local morphisms;
    morphisms := Map( [ Combine( List( complexes, Objects ) ),
                        Objects( sum_complex ) ],
                      function( summands, sum )
                        return ProjectionInFactorOfDirectSumWithGivenDirectSum
                               ( summands, i, sum );
                      end );
    return maps_constructor( sum_complex, complexes[ i ],
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
                                 return complex_constructor( cat, terminal_obj_differentials, false );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "UniversalMorphismIntoTerminalObject" ) then
 AddUniversalMorphismIntoTerminalObjectWithGivenTerminalObject( complex_cat,
                                 function( complex, terminal_obj )
                                 local objects, universal_maps;
                                 objects := Objects( complex );
                                 universal_maps := Map( objects,  UniversalMorphismIntoTerminalObject );
                                 return maps_constructor( complex, terminal_obj, universal_maps );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "InitialObject" ) then
 AddInitialObject( complex_cat, function( )
                                 local initial_obj_functorial, initial_obj_differentials;
                                 initial_obj_functorial := InitialObjectFunctorial( cat );
                                 initial_obj_differentials := RepeatListZ( [ initial_obj_functorial ] );
                                 return complex_constructor( cat, initial_obj_differentials, false );
                                 end );
 fi;
 ##

 #n
 if CanCompute( cat, "UniversalMorphismFromInitialObject" ) then
 AddUniversalMorphismFromInitialObjectWithGivenInitialObject( complex_cat,
                                 function( complex, initial_object )
                                 local objects, universal_maps;
                                 objects := Objects( complex );
                                 universal_maps := Map( objects,  UniversalMorphismFromInitialObject );
                                 return maps_constructor( complex, initial_object, universal_maps );
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

#n
# InstallMethod( ComplexCategory, 
#                  [ IsCapCategory ],
#   ChainComplexCategory );
##

#n
# InstallMethod( CocomplexCategory, 
#                  [ IsCapCategory ],
#   CochainComplexCategory );
##


#########################################
#
#  Constructors of (Co)chain complexes 
#
#########################################

#n
BindGlobal( "CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST",
function( cat, diffs, make_assertions, type )
  local C, assertion, f, msg;

  C := rec();

  if type = "TheTypeOfChainComplexes" then

     ObjectifyWithAttributes( C, TheTypeOfChainComplexes,
                           CatOfComplex, cat,
                           Differentials, diffs );
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
     Add( ChainComplexCategory( cat ), C );
     
  elif type = "TheTypeOfCochainComplexes" then

     ObjectifyWithAttributes( C, TheTypeOfCochainComplexes,
                              CatOfComplex, cat,
                              Differentials, diffs );
     if make_assertions then
#         this code need to be modified for the case of cochain complexes.
#         for assertion in ComplexSingleAssertions do
#         f := assertion[ 1 ];
#         msg := assertion[ 2 ];
#         AddAssertion( diffs, MakeSingleAssertion( C, f, msg ) );
#         od;
#         for assertion in ComplexDoubleAssertions do
#         f := assertion[ 1 ];
#         msg := assertion[ 2 ];
#         AddAssertion( diffs, MakeDoubleAssertion( C, f, msg ) );
#         od;
     fi;

     Add( CochainComplexCategory( cat ), C );

  else 

     Error( "4'th argument must be either 'TheTypeOfChainComplexes' or 'TheTypeOfCochainComplexes'" );

  fi;
  C!.ListOfComputedDifferentials := [ ];
  C!.ListOfComputedObjects := [ ];
  return C;
end );
##

#n
InstallMethod( ChainComplexByDifferentialList, [ IsCapCategory, IsZList, IsBool ],
function( cat, diffs, make_assertions )
  return CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST( cat, diffs, make_assertions, "TheTypeOfChainComplexes" );
end );

InstallMethod( ChainComplexByDifferentialList, [ IsCapCategory, IsZList ],
function( cat, diffs )
  return ChainComplexByDifferentialList( cat, diffs, true );
end );

InstallMethod( CochainComplexByDifferentialList, [ IsCapCategory, IsZList, IsBool ],
function( cat, diffs, make_assertions )
  return CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST( cat, diffs, make_assertions, "TheTypeOfCochainComplexes" );
end );

InstallMethod( CochainComplexByDifferentialList, [ IsCapCategory, IsZList ],
function( cat, diffs )
  return CochainComplexByDifferentialList( cat, diffs, true );
end );
##

#c
InstallMethod( ComplexByDifferentialList, 
         [ IsAbelianCategory, IsZList, IsBool ],
ChainComplexByDifferentialList );

InstallMethod( ComplexByDifferentialList, 
         [ IsAbelianCategory, IsZList ],
ChainComplexByDifferentialList );
##

################################################
#
#  Constructors of finite (co)chain complexes
#
################################################

#n
BindGlobal( "FINITE_CHAIN_OR_COCHAIN_COMPLEX",
     function( cat, list, homological_index, string )
     local zero, zero_map, zero_part, n, diffs, new_list, complex, upper_bound, lower_bound;
  zero := ZeroObject( cat );
  zero_map := ZeroMorphism( zero, zero );
  zero_part := RepeatListN( [ zero_map ] );
  n := Length( list );
  if not ForAll( list, mor -> cat = CapCategory( mor ) ) then 
     Error( "All morphisms in the list should live in the same category" );
  fi;  
  if string = "chain" then 
 
        new_list := Concatenation( [ ZeroMorphism( Range( list[ 1 ] ), zero ) ], list, [ ZeroMorphism( zero, Source( list[ n ] ) ) ] );
        diffs := Concatenate( zero_part, new_list, zero_part );
        complex := ShiftUnsigned( ChainComplexByDifferentialList( cat, diffs ), 1 - homological_index );
        lower_bound := homological_index - 2;
        upper_bound := homological_index + Length( list );
  else

        new_list := Concatenation( [ ZeroMorphism( zero, Source( list[ 1 ] ) ) ], list, [ ZeroMorphism( Range( list[ n ] ), zero ) ] );
        diffs := Concatenate( zero_part, new_list, zero_part );
        complex := ShiftUnsigned( CochainComplexByDifferentialList( cat, diffs ), 1 - homological_index );
        lower_bound := homological_index - 1;
        upper_bound := homological_index + Length( list ) + 1;
  fi;

  SetLowerBound( complex, lower_bound );
  SetUpperBound( complex, upper_bound );  
  return complex;
end );
##

#n
InstallMethod( FiniteChainComplex, 
                   [ IsDenseList, IsInt ], 
   function( diffs, n )
   local cat;
   cat := CapCategory( diffs[ 1 ] );
   return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "chain" );
   end );
 
InstallMethod( FiniteCochainComplex, 
                   [ IsDenseList, IsInt ], 
   function( diffs, n )
   local cat;
   cat := CapCategory( diffs[ 1 ] );
   return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "cochain" );
   end );
 
InstallMethod( FiniteChainComplex, 
                   [ IsDenseList ], 
   function( diffs )
   return FiniteChainComplex( diffs, 0 );
   end );
 
InstallMethod( FiniteCochainComplex, 
                   [ IsDenseList ], 
   function( diffs )
   return FiniteCochainComplex( diffs, 0 );
   end );

InstallMethod( StalkChainComplex, 
                   [ IsCapCategoryObject ], 
   function( obj )
   local zero, diffs, complex;
   zero := ZeroObject( CapCategory( obj ) );
   diffs := [ ZeroMorphism( obj, zero ) ];
   complex := FiniteChainComplex( diffs );
   SetLowerBound( complex, -1 );
   return complex;
   end );

InstallMethod( StalkCochainComplex, 
                   [ IsCapCategoryObject ], 
   function( obj )
   local zero, diffs, complex;
   zero := ZeroObject( CapCategory( obj ) );
   diffs := [ ZeroMorphism( obj, zero ) ];
   complex := FiniteCochainComplex( diffs );
   SetUpperBound( complex, 1 );
   return complex;
   end );
##

################################################
#
#  Constructors of inductive (co)chain complexes
#
################################################

#n
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES",
  function( d0, negative_part_function, positive_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs;

  cat := CapCategory( d0 ); 
  if string = "chain" then 
     complex_constructor := ChainComplexByDifferentialList;
  elif string = "cochain" then
     complex_constructor := CochainComplexByDifferentialList;
  else
     Error( "string must be either chain or cochain" );
  fi;

  negative_part := InductiveList( negative_part_function( d0 ), negative_part_function );
  positive_part := InductiveList( d0, positive_part_function );

  diffs := Concatenate( negative_part, positive_part );

  return complex_constructor( cat, diffs );
end );
##

#n
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE",
  function( d0, negative_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs, d1, zero_part, complex, upper_bound;

  cat := CapCategory( d0 ); 
  zero_part := RepeatListN( [ UniversalMorphismFromZeroObject( ZeroObject( cat ) ) ] );
  if string = "chain" then 
     complex_constructor := ChainComplexByDifferentialList;
     d1 := UniversalMorphismFromZeroObject( Source( d0 ) );
     upper_bound := 1;
  elif string = "cochain" then
     complex_constructor := CochainComplexByDifferentialList;
     d1 := UniversalMorphismIntoZeroObject( Range( d0 ) );
     upper_bound := 2;
  else
     Error( "string must be either chain or cochain" );
  fi;

  negative_part := InductiveList( negative_part_function( d0 ), negative_part_function );
  positive_part := Concatenate( [ d0, d1 ], zero_part );
  diffs := Concatenate( negative_part, positive_part );
  complex :=  complex_constructor( cat, diffs );
  SetUpperBound( complex, upper_bound );
  return complex;
  
end );
##

#n
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE",
  function( d0, positive_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs, d_minus_1, zero_part, complex, lower_bound;

  cat := CapCategory( d0 ); 
  zero_part := RepeatListN( [ UniversalMorphismFromZeroObject( ZeroObject( cat ) ) ] );
  if string = "chain" then 
     complex_constructor := ChainComplexByDifferentialList;
     d_minus_1 := UniversalMorphismIntoZeroObject( Range( d0 ) );
     lower_bound := -2;
  elif string = "cochain" then
     complex_constructor := CochainComplexByDifferentialList;
     d_minus_1 := UniversalMorphismFromZeroObject( Source( d0 ) );
     lower_bound := -1;
  else
     Error( "string must be either chain or cochain" );
  fi;

  positive_part := InductiveList( d0, positive_part_function );
  negative_part := Concatenate( [ d_minus_1 ], zero_part );
  diffs := Concatenate( negative_part, positive_part );
  complex :=  complex_constructor( cat, diffs );
  SetLowerBound( complex, lower_bound );
  return complex;
end );
##

#n
InstallMethod( ChainComplexWithInductiveSides,
               [ IsCapCategoryMorphism, IsFunction, IsFunction ],
   function( d0, negative_part_function, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES( d0, negative_part_function, positive_part_function, "chain" );
end );

InstallMethod( CochainComplexWithInductiveSides,
               [ IsCapCategoryMorphism, IsFunction, IsFunction ],
   function( d0, negative_part_function, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES( d0, negative_part_function, positive_part_function, "cochain" );
end );

InstallMethod( ChainComplexWithInductiveNegativeSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, negative_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE( d0, negative_part_function, "chain" );
   end );

InstallMethod( ChainComplexWithInductivePositiveSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE( d0, positive_part_function, "chain" );
end );

InstallMethod( CochainComplexWithInductiveNegativeSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, negative_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE( d0, negative_part_function, "cochain" );
   end );

InstallMethod( CochainComplexWithInductivePositiveSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE( d0, positive_part_function, "cochain" );
   end );
##



#########################################
##
## Attributes of (co)chain complexes and
## some operations derived from these attributes
##
#########################################

#n
InstallMethod( Objects, [ IsChainOrCochainComplex ],
function( C )
  return Map( Differentials( C ), Source );
end );
##

#n
InstallMethod( ObjectsOfChainComplex, [ IsChainComplex ], Objects );
InstallMethod( ObjectsOfCochainComplex, [ IsCochainComplex ], Objects );
##

#c
# InstallMethod( ObjectsOfComplex, [ IsChainOrCochainComplex ],
# function( C )
#   return Map( DifferentialsOfComplex( C ), Source );
# end );
##

#c
InstallMethod( DifferentialOfComplex, [ IsChainOrCochainComplex, IsInt ],
  function( C, i )
  local l,j;
  l := C!.ListOfComputedDifferentials;
     if i in List( l, i->i[ 1 ] ) then 
        for j in l do
          if i = j[ 1 ] then 
              return j[ 2 ];
          fi;
        od;
     fi;
  Add( C!.ListOfComputedDifferentials, [ i, Differentials( C )[ i ] ] );
  return Differentials( C )[ i ];
end );
##

#c
InstallMethod( \^, [ IsChainOrCochainComplex, IsInt ], DifferentialOfComplex );
##

InstallMethod( ObjectOfComplex, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local l,j;
  l := C!.ListOfComputedObjects;
     if i in List( l, i->i[ 1 ] ) then 
        for j in l do
          if i = j[ 1 ] then 
              return j[ 2 ];
          fi;
        od;
     fi;
  Add( C!.ListOfComputedObjects, [ i, Source( DifferentialOfComplex( C, i ) ) ] );
  return Source( DifferentialOfComplex( C, i ) );
end );

#c
InstallMethod( \[\], [ IsChainOrCochainComplex, IsInt ], ObjectOfComplex );
##

#########################################
#
# Components of a (co)chain complex
#
#########################################

InstallMethod( Display, 
               [ IsChainOrCochainComplex, IsInt, IsInt ], 
   function( C, m, n )
   local i;
   for i in [ m .. n ] do
   Print( "-----------------------------------------------------------------\n" );
   Print( "In index ", String( i ) );
   Print( "\n\nObject[ ", String( i ), " ] is\n" );
   Display( C[ i ] );
   Print( "\nDifferential[ ", String( i ), " ] is\n" );
   Display( C^i );
   od;
end );

InstallMethod( ViewObj,
               [ IsChainOrCochainComplex ],
   function( C )
   if HasActiveUpperBound( C ) and HasActiveLowerBound( C ) then
     Print( "<A bounded object in ", Name( CapCategory( C ) ), ">" );
   elif   HasActiveLowerBound( C ) then
     Print( "<A bounded from bellow object in ", Name( CapCategory( C ) ), ">" );
   elif HasActiveUpperBound( C ) then
   Print( "<A bounded from above object in ", Name( CapCategory( C ) ), ">" );
   else
   TryNextMethod( );
   fi;
end );
   
#############################################
##
## Homology and Cohomology computations
##
#############################################

InstallMethod( CyclesOfComplex, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local cat;
  cat := CatOfComplex( C );
  return KernelEmbedding( DifferentialOfComplex( C, i ) );
end );

#c
InstallMethod( BoundariesOfComplex, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local cat;
  cat := CatOfComplex( C );
  if IsChainComplex( C ) then 
    return ImageEmbedding( DifferentialOfComplex( C, i + 1 ) );
  else
    return ImageEmbedding( DifferentialOfComplex( C, i - 1 ) );
  fi;
end );
##

#n
BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX",
   function( C, i )
   local cat, im, d, inc;
   cat := CatOfComplex( C );
   im := BoundariesOfComplex( C, i );
   d := DifferentialOfComplex( C, i );
   inc := KernelLift( d, im );
   return CokernelObject( inc );
end );
##

#n
BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX_FUNCTORIAL",
   function( map, i )
   local C1, C2, im1, d1, inc1, im2, d2, inc2, cycle1, map_i, ker1_to_ker2;
   C1 := Source( map );
   C2 := Range( map );
   
   im1 := BoundariesOfComplex( C1, i );
   d1 := DifferentialOfComplex( C1, i );
   inc1 := KernelLift( d1, im1 );
   
   im2 := BoundariesOfComplex( C2, i );
   d2 := DifferentialOfComplex( C2, i );
   inc2 := KernelLift( d2, im2 );
   
   cycle1 := CyclesOfComplex( C1, i );
   map_i := MorphismOfMap( map, i );
   
   ker1_to_ker2 := KernelLift( d2, PreCompose( cycle1, map_i ) );
   
   return CokernelColift( inc1, PreCompose( ker1_to_ker2, CokernelProjection( inc2 ) ) );
   
   end );
##

#n
InstallMethod( HomologyOfChainComplex, [ IsChainComplex, IsInt ], HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX );

InstallMethod( CohomologyOfCochainComplex, [ IsCochainComplex, IsInt ], HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX );
##

#n
InstallMethod( DefectOfExactness, 
               [ IsChainOrCochainComplex, IsInt ],
  function( C, n )
  if IsChainComplex( C ) then 
     return HomologyOfChainComplex( C, n );
  else
     return CohomologyOfCochainComplex( C, n );
  fi;
end );

InstallMethod( IsExactInIndex, 
               [ IsChainOrCochainComplex, IsInt ],
   function( C, n )
   return IsZeroForObjects( DefectOfExactness( C, n ) );
end );
##

#c
InstallMethod( HomologyOfComplex, [ IsChainComplex, IsInt ], HomologyOfChainComplex );
##


########################################
#
# Mapping cone
#
########################################

BindGlobal( "MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP", 
    function( map )
    local complex_cat, shift, complex_constructor, morphism_constructor, A, B, C, A_shifted, C_shifted, map1, map2, 
          map_C_to_A_shifted, map_B_to_C, map_B_shifted_to_C_shifted, map_A_shifted_to_B_shifted, diffs_C, injection, projection, complex;
    complex_cat := CapCategory( map );
    
    if IsChainMap( map ) then 
       shift := ShiftAsFunctor( complex_cat, -1 );
       complex_constructor := ChainComplexByDifferentialList;
       morphism_constructor := ChainMapByMorphismList;
    else
       shift := ShiftAsFunctor( complex_cat, 1 );
       complex_constructor := CochainComplexByDifferentialList;
       morphism_constructor := CochainMapByMorphismList;
    fi;

    A := Source( map );
    B := Range( map );
    
    A_shifted := ApplyFunctor( shift, A );
    
    C := DirectSum( A_shifted, B );
    
    diffs_C := Differentials( C );
    
    C_shifted := ApplyFunctor( shift, C );
    
    map1 := morphism_constructor( C, C_shifted, diffs_C );
    
    map_C_to_A_shifted := ProjectionInFactorOfDirectSum( [ A_shifted, B ], 1 );
    map_A_shifted_to_B_shifted := ApplyFunctor( shift, map );
    map_B_to_C := InjectionOfCofactorOfDirectSum( [ A_shifted, B ], 2 );
    map_B_shifted_to_C_shifted := ApplyFunctor( shift, map_B_to_C );
    
    map2 := PreCompose( [ map_C_to_A_shifted, map_A_shifted_to_B_shifted, map_B_shifted_to_C_shifted ] );
    
    complex := complex_constructor( UnderlyingCategory( complex_cat), MorphismsOfMap( map1 + map2 ) );
    if HasActiveLowerBound( map2 ) then SetLowerBound( complex, ActiveLowerBound( map2 ) );fi;
    if HasActiveUpperBound( map2 ) then SetUpperBound( complex, ActiveUpperBound( map2 ) );fi;
    
    injection := MorphismsOfMap( InjectionOfCofactorOfDirectSum( [ A_shifted, B ], 2 ) );
    projection := MorphismsOfMap( ProjectionInFactorOfDirectSum( [ A_shifted, B ], 1 ) );
    
    injection := morphism_constructor( B, complex, injection );
    projection := morphism_constructor( complex, A_shifted, projection );

    return [ complex, injection, projection ];
end );

#n
InstallMethod( MappingCone, [ IsChainOrCochainMap ], MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP );
##
 
########################################
#
# Upper and lower bounds of (co)chains
#
########################################

#n
InstallMethod( SetUpperBound, 
              [ IsChainOrCochainComplex, IsInt ], 
   function( C, upper_bound )
   if IsBound( C!.UpperBound ) and C!.UpperBound < upper_bound then 
      Error( "The input is bigger than the one that already exists!" );
   fi;
   C!.UpperBound := upper_bound;
end );
##

#n
InstallMethod( SetLowerBound, 
              [ IsChainOrCochainComplex, IsInt ], 
   function( C, lower_bound )
   if IsBound( C!.LowerBound ) and C!.LowerBound > lower_bound then 
      Error( "The input is smaller than the one that already exists!" );
   fi;
   C!.LowerBound := lower_bound;
end );
##

#n
InstallMethod( ActiveUpperBound,
[ IsChainOrCochainComplex ],
function( C )
if not IsBound( C!.UpperBound ) then
Error( "The complex does not have yet an upper bound" );
else
return C!.UpperBound;
fi;
end );

InstallMethod( ActiveLowerBound,
[ IsChainOrCochainComplex ],
function( C )
if not IsBound( C!.LowerBound ) then
Error( "The complex does not have yet an lower bound" );
else
return C!.LowerBound;
fi;
end );

InstallMethod( HasActiveUpperBound,
[ IsChainOrCochainComplex ],
function( C )
return IsBound( C!.UpperBound );
end );

InstallMethod( HasActiveLowerBound,
[ IsChainOrCochainComplex ],
function( C )
return IsBound( C!.LowerBound );
end );
##

## This code is not yet finished.
BindGlobal( "LOWER_BOUND_OF_CHAIN_OR_COCHAIN", 
  function( C, bool, m )
  local diffs, repeating_list, negative_part, positive_part, middle_part, n,i, k, concat_list, B;
  
  diffs := Differentials( C );
  
  if IsRepeatingInfList( diffs ) then 
    
     repeating_list := RepeatingList( diffs );
     
     if IsZero( repeating_list ) then 
         return PositiveInfinity;
     else
         return NegativeInfinity;
     fi;
     
  fi;

  if IsConcatZList( diffs ) then 
     negative_part := NegativeList( diffs );

     if IsRepeatingInfList( negative_part ) then 
            repeating_list := RepeatingList( negative_part );
            if IsZero( repeating_list ) then 
               middle_part := MiddleList( diffs );
               n := Length( middle_part );
               for i in [ 1..n ] do
                  if not IsZero( middle_part[ i ] ) then 
                     return BasePosition( diffs ) + i-1;
                  fi;
               od;

               positive_part := PositiveList( diffs );

               if IsRepeatingInfList( positive_part ) then 
                      repeating_list := RepeatingList( positive_part );
                      if IsZero( repeating_list ) then 
                         return PositiveInfinity;
                      fi;
               elif IsConcatNList( positive_part ) then 
                      concat_list := ConcatList( positive_part );
                      k := Length( concat_list );
                           for i in [ 1 .. k ] do 
                               if not IsZero( concat_list[ i ] ) then 
                                  return BasePosition( diffs ) + n + i - 1;
                               fi;
                           od;
                      B := BaseList( positive_part );
                           if IsRepeatingInfList( B ) and IsZero( RepeatingList( B ) ) then 
                                  return PositiveInfinity;
                           fi;
                      return BasePosition( diffs )+ n + k - 1;
               fi;
               return BasePosition( diffs )+ n - 1;
            else
               return NegativeInfinity;
            fi;
     elif IsInductiveNList( negative_part ) and bool  then 
          for i in [ 1 .. m ] do 
              if IsZero( negative_part[ i ] ) and IsZero( negative_part[ i + 1 ] ) and negative_part[ i ] = negative_part[ i + 1 ] then 
                       if IsZero( negative_part[ i -1 ] ) then 
                          return BasePosition( diffs ) - i + 2;
                       else 
                          return BasePosition( diffs ) - i + 1;
                       fi;
              fi;
           od;
     else
     
           return fail;
     
     fi;
 fi;

   return fail;
end );

BindGlobal( "UPPER_BOUND_OF_CHAIN_OR_COCHAIN", 
  function( C, bool, m )
  local diffs, repeating_list, negative_part, positive_part, middle_part, n,i, k, concat_list, B;
  
  diffs := Differentials( C );
  
  if IsRepeatingInfList( diffs ) then 
    
     repeating_list := RepeatingList( diffs );
     
     if IsZero( repeating_list ) then 
         return NegativeInfinity;
     else
         return PositiveInfinity;
     fi;
     
  fi;

  if IsConcatZList( diffs ) then 
     positive_part := PositiveList( diffs );

     if IsRepeatingInfList( positive_part ) then 
          repeating_list := RepeatingList( positive_part );
            if IsZero( repeating_list ) then 
               middle_part := MiddleList( diffs );
               n := Length( middle_part );
               for i in [ 1..n ] do
                  if not IsZero( middle_part[ n-i+1 ] ) then 
                     return BasePosition( diffs ) + n-i;
                  fi;
               od;
           
               negative_part := NegativeList( diffs );
               
               if IsRepeatingInfList( negative_part ) then 
                      repeating_list := RepeatingList( negative_part );
                      if IsZero( repeating_list ) then 
                         return NegativeInfinity;
                      fi;
               fi;
               
            #To do. This code can be improved.
            return BasePosition( diffs );
            
            else
               return PositiveInfinity;
            fi;
     elif IsInductiveNList( positive_part ) and bool  then 
          for i in [ 1 .. m ] do 
              if IsZero( positive_part[ i ] ) and IsZero( positive_part[ i + 1 ] ) and positive_part[ i ] = positive_part[ i + 1 ] then 
                       if IsZero( positive_part[ i -1 ] ) then 
                          return BasePosition( diffs ) + Length( MiddleList( diffs ) ) + i - 3;
                       else 
                          return BasePosition( diffs ) + i - 2;
                       fi;
              fi;
           od;
     elif IsConcatNList( positive_part ) then 
          
          B := BaseList( positive_part );
                
                 if IsRepeatingInfList( B ) then 
                       if not IsZero( RepeatingList( B ) ) then 
                              return PositiveInfinity;
                       else
                              concat_list := ConcatList( positive_part );
                              k := Length( concat_list );
                              for i in [ 1 .. k ] do 
                                  if not IsZero( concat_list[ k - i + 1 ] ) then 
                                     return BasePosition( diffs ) + k - i;
                                  fi;
                              od;
                              
                              negative_part := NegativeList( diffs );
                              
                              if IsRepeatingInfList( negative_part ) and IsZero( RepeatingList( negative_part ) ) then 
                                       return NegativeInfinity;
                              elif IsRepeatingInfList( negative_part ) then 
                                       return BasePosition( diffs );
                              else
                                       return BasePosition( diffs );
                              fi;
                       fi;
                 else
                       return fail;
                 fi;
      fi;
 fi;

   return fail;
end );

InstallMethod( LowerBound, [ IsChainOrCochainComplex, IsPosInt ],
   function( C, m )
   return LOWER_BOUND_OF_CHAIN_OR_COCHAIN( C, true, m );
end );

InstallMethod( LowerBound, [ IsChainOrCochainComplex ],
   function( C )
   return LOWER_BOUND_OF_CHAIN_OR_COCHAIN( C, false, 0 );
end );

InstallMethod( UpperBound, [ IsChainOrCochainComplex, IsPosInt ],
   function( C, m )
   return UPPER_BOUND_OF_CHAIN_OR_COCHAIN( C, true, m );
end );

InstallMethod( UpperBound, [ IsChainOrCochainComplex ],
   function( C )
   return UPPER_BOUND_OF_CHAIN_OR_COCHAIN( C, false, 0 );
end );

########################################
#
# More methods 
#
########################################

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

#c
InstallMethod( Shift, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local newDifferentials, complex;
  newDifferentials := Shift( Differentials( C ), i );
  if i mod 2 = 1 then
    newDifferentials := Map( newDifferentials, d -> -d );
  fi;
  
  if IsChainComplex( C ) then
     complex := ChainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  else
     complex := CochainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  fi;
  
  if HasActiveUpperBound( C ) then 
     SetUpperBound( complex, ActiveUpperBound( C ) - i );
  fi;
  
  if HasActiveLowerBound( C ) then 
     SetLowerBound( complex, ActiveLowerBound( C ) - i );
  fi;
  
  complex!.ListOfComputedDifferentials := List( C!.ListOfComputedDifferentials, l -> [ l[ 1 ] - i, (-1)^i*l[ 2 ] ] );
  complex!.ListOfComputedObjects := List( C!.ListOfComputedObjects, l -> [ l[ 1 ] - i, l[ 2 ] ] );
  
  return complex;
end );
##

#c
InstallMethod( ShiftUnsigned, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local newDifferentials, complex;
  newDifferentials := Shift( Differentials( C ), i );
  
  if IsChainComplex( C ) then 
     complex := ChainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  else
     complex := CochainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  fi;
  if HasActiveUpperBound( C ) then 
     SetUpperBound( complex, ActiveUpperBound( C ) - i );
  fi;
  
  if HasActiveLowerBound( C ) then 
     SetLowerBound( complex, ActiveLowerBound( C ) - i );
  fi;
  
  complex!.ListOfComputedDifferentials := List( C!.ListOfComputedDifferentials, l -> [ l[ 1 ] - i, l[ 2 ] ] );
  complex!.ListOfComputedObjects := List( C!.ListOfComputedObjects, l -> [ l[ 1 ] - i, l[ 2 ] ] );
  
  return complex;
end );
##

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
  return InfListString( opt, Differentials( C ), true );
end );

# InstallMethod( ViewObj, [ IsChainComplex ],
# function( C )
#   Print( String( C ) );
# end );

InstallMethod( SetString, [ IsChainComplex, IsString ],
               function( L, str ) end );


