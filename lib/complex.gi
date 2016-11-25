

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
    local zero_map;
    zero_map := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
    return complex_constructor( cat, RepeatListZ( [ zero_map ] ), false );
    end );
  ##

  #c
  AddZeroMorphism( complex_cat, ZeroMap );
  ##

  addition_for_morphisms := function( m1, m2 )
    local morphisms;
    morphisms := Map( [ MorphismsOfMap( m1 ),
                        MorphismsOfMap( m2 ) ],
                      AdditionForMorphisms );
    return maps_constructor( Source( m1 ), Range( m1 ),
                                   morphisms );
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
    local morphisms;
    morphisms := Map( [ MorphismsOfMap( m1 ),
                        MorphismsOfMap( m2 ) ],
                      PreCompose );
    return maps_constructor( Source( m1 ), Range( m2 ),
                                   morphisms );
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
    local morphisms;
    morphisms := Map( MorphismsOfMap( iso ), Inverse );
    return maps_constructor( Range( iso ), Source( iso ),
                                   morphisms );
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
    local diffs;
    diffs := Map( Combine( List( complexes, Differentials ) ),
                  DirectSumFunctorial );
    #cat := UnderlyingCategory( CapCategory( complexes[ 1 ] ) );
    return complex_constructor( cat, diffs );
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
#    this code need to be modified for the case of cochain complexes.
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
  return Differentials( C )[ i ];
end );
##

#c
InstallMethod( \^, [ IsChainOrCochainComplex, IsInt ], DifferentialOfComplex );
##

InstallMethod( ObjectOfComplex, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  return Source( DifferentialOfComplex( C, i ) );
end );

#c
InstallMethod( \[\], [ IsChainOrCochainComplex, IsInt ], ObjectOfComplex );
##

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
##

#n
InstallMethod( CohomologyOfCochainComplex, [ IsCochainComplex, IsInt ], HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX );
##

#c
InstallMethod( HomologyOfComplex, [ IsChainComplex, IsInt ], HomologyOfChainComplex );
##

####################################
#
#    Functors 
#
####################################

# Homology and Cohomology functors

#n
BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR", 
     function( cat, i, string )
     local functor, complex_cat, name;
     
     if string = "Homology" then
     
     complex_cat := ChainComplexCategory( cat );
     
     name := Concatenation( String( i ), "-th homology functor in ", Name( cat ) );
     
     else
     
     complex_cat := CochainComplexCategory( cat );
     
     name := Concatenation( String( i ), "-th cohomology functor in ", Name( cat ) );
     
     fi;
     
     functor := CapFunctor( name, complex_cat, cat );

     AddObjectFunction( functor, 
     function( complex )
     return HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX( complex, i );
     end );
     
     AddMorphismFunction( functor,
     function( new_source, map, new_range )
     return HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX_FUNCTORIAL( map, i );
     end );
     
     return functor;
     end );
##

## Shift functor

#n
BindGlobal( "SHIFT_AS_FUNCTOR",
   function( complex_cat, n )
   local name, shift, morphism_constructor;
   
   if IsChainComplexCategory( complex_cat ) then 
      morphism_constructor := ChainMapByMorphismList;
   elif IsCochainComplexCategory( complex_cat ) then 
      morphism_constructor := CochainMapByMorphismList;
   else 
      Error( "The category should be either chain or cochain complexes category" );
   fi;
   
   if n = 0 then 
      return IdentityFunctor( complex_cat );
   elif n>0 then 
      name := Concatenation( "Shift (", String( n ), " times to the left) functor in ", Name( complex_cat ) );
   else
      name := Concatenation( "Shift (", String( -n ), " times to the right) functor in ", Name( complex_cat ) );
   fi;
   
   shift := CapFunctor( name, complex_cat, complex_cat );
   
   AddObjectFunction( shift, 
     function( complex )
       return Shift( complex, n );
     end );
   AddMorphismFunction( shift, 
     function( new_source, map, new_range )
     local morphisms;
     morphisms := MorphismsOfMap( map );
     morphisms := Shift( morphisms, n );
     return morphism_constructor( new_source, new_range, morphisms );
     end );
   
   return shift;
end );
##

#n
BindGlobal( "UNSIGNED_SHIFT_AS_FUNCTOR",
   function( complex_cat, n )
   local name, shift, morphism_constructor;
   
   if IsChainComplexCategory( complex_cat ) then 
      morphism_constructor := ChainMapByMorphismList;
   elif IsCochainComplexCategory( complex_cat ) then 
      morphism_constructor := CochainMapByMorphismList;
   else 
      Error( "The category should be either chain or cochain complexes category" );
   fi;
   
   if n = 0 then 
      return IdentityFunctor( complex_cat );
   elif n>0 then 
      name := Concatenation( "Unsigned shift (", String( n ), " times to the left) functor in ", Name( complex_cat ) );
   else
      name := Concatenation( "Unsigned shift (", String( -n ), " times to the right) functor in ", Name( complex_cat ) );
   fi;
   
   shift := CapFunctor( name, complex_cat, complex_cat );
   
   AddObjectFunction( shift, 
     function( complex )
       return ShiftUnsigned( complex, n );
     end );
   AddMorphismFunction( shift, 
     function( new_source, map, new_range )
     local morphisms;
     morphisms := MorphismsOfMap( map );
     morphisms := Shift( morphisms, n );
     return morphism_constructor( new_source, new_range, morphisms );
     end );
   
   return shift;
end );
##

#n
BindGlobal( "CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR",
   function( cat, string )
   local chain_complexes, cochain_complexes, complex_constructor, name, functor, morphism_constructor; 

   chain_complexes := ChainComplexCategory( cat );
   cochain_complexes := CochainComplexCategory( cat );

   if string = "chain_to_cochain" then
      name := Concatenation("Chain to Cochain complex functor over ", Name( cat ) );
      functor := CapFunctor( name, chain_complexes, cochain_complexes );
      complex_constructor := CochainComplexByDifferentialList;
      morphism_constructor := CochainMapByMorphismList;
   elif string = "cochain_to_chain" then 
      name := Concatenation("Cochain to chain complex functor over ", Name( cat ) );
      functor := CapFunctor( name, cochain_complexes, chain_complexes );
      complex_constructor := ChainComplexByDifferentialList;
      morphism_constructor := ChainMapByMorphismList;
   else 
      Error( "string should be either chain_to_cochain or cochain_to_chain" );
   fi;
 
   AddObjectFunction( functor,
     function( C )
     local diffs, neg_part, pos_part, new_diffs;
     diffs := Differentials( C );
     neg_part := NegativePartFrom( diffs, 0 );
     pos_part := PositivePartFrom( diffs, 1 );
     new_diffs := Concatenate( pos_part, neg_part );
     return complex_constructor( cat, new_diffs );
     end );
   AddMorphismFunction( functor, 
     function( new_source, map, new_range )
     local morphisms, neg_part, pos_part, new_morphisms;
     morphisms := MorphismsOfMap( map );
     neg_part := NegativePartFrom( morphisms, 0 );
     pos_part := PositivePartFrom( morphisms, 1 );
     new_morphisms := Concatenate( pos_part, neg_part );
     return morphism_constructor( new_source, new_range, new_morphisms );
     end );

   return functor;
end );
##

BindGlobal( "FUNCTORS_INSTALLER",
   function( )

InstallMethod( HomologyAsFunctor, 
               [ IsCapCategory, IsInt ], 
  function( cat, i )
  return HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR( cat, i, "Homology" );
  end );

InstallMethod( CohomologyAsFunctor, 
               [ IsCapCategory, IsInt ],
  function( cat, i )
  return HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR( cat, i, "Cohomology" );
  end );

InstallMethod( ShiftAsFunctor, 
               [ IsCapCategory, IsInt ],
SHIFT_AS_FUNCTOR );

InstallMethod( UnsignedShiftAsFunctor, 
               [ IsCapCategory, IsInt ],
UNSIGNED_SHIFT_AS_FUNCTOR );

InstallMethod( ChainToCochainComplexAsFunctor, 
               [ IsCapCategory ], 
   function( cat )
   return CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR( cat, "chain_to_cochain" );
   end );

InstallMethod( CochainToChainComplexAsFunctor, 
               [ IsCapCategory ], 
   function( cat )
   return CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR( cat, "cochain_to_chain" );
   end );
end );

FUNCTORS_INSTALLER( );

########################################
#
# Mapping cone
#
########################################

BindGlobal( "MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP", 
    function( map )
    local complex_cat, shift, complex_constructor, morphism_constructor, A, B, C, A_shifted, C_shifted, map1, map2, 
          map_C_to_A_shifted, map_B_to_C, map_B_shifted_to_C_shifted, map_A_shifted_to_B_shifted, diffs_C;
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
    
    return complex_constructor( UnderlyingCategory( complex_cat), MorphismsOfMap( map1 + map2 ) );

end );

#n
InstallMethod( MappingCone, [ IsChainOrCochainMap ], MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP );
##

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

########################################
#
#  Finite complexes
#
########################################

#n
BindGlobal( "FINITE_CHAIN_OR_COCHAIN_COMPLEX",
     function( cat, list, homological_index, string )
     local zero, zero_map, zero_part, n, diffs, new_list;
  zero := ZeroObject( cat );
  zero_map := ZeroMorphism( zero, zero );
  zero_part := RepeatListN( [ zero_map ] );
  n := Length( list );
  
  if string = "chain" then 
 
        new_list := Concatenation( [ ZeroMorphism( Range( list[ 1 ] ), zero ) ], list, [ ZeroMorphism( zero, Source( list[ n ] ) ) ] );
        diffs := Concatenate( zero_part, new_list, zero_part );
        return ShiftUnsigned( ChainComplexByDifferentialList( cat, diffs ), 1 - homological_index );
  else

        new_list := Concatenation( [ ZeroMorphism( zero, Source( list[ 1 ] ) ) ], list, [ ZeroMorphism( Range( list[ n ] ), zero ) ] );
        diffs := Concatenate( zero_part, diffs, zero_part );
        return ShiftUnsigned( CochainComplexByDifferentialList( cat, diffs ), 1 - homological_index );
  fi;

end );
##

#n
InstallMethod( FiniteChainComplexByDifferentialList, 
                   [ IsCapCategory, IsDenseList, IsInt ], 
   function( cat, diffs, n )
   return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "chain" );
   end );
 
InstallMethod( FiniteCochainComplexByDifferentialList, 
                   [ IsCapCategory, IsDenseList, IsInt ], 
   function( cat, diffs, n )
   return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "cochain" );
   end );
 
InstallMethod( FiniteChainComplexByDifferentialList, 
                   [ IsCapCategory, IsDenseList ], 
   function( cat, diffs )
   return FiniteChainComplexByDifferentialList( cat, diffs, 0 );
   end );
 
InstallMethod( FiniteCochainComplexByDifferentialList, 
                   [ IsCapCategory, IsDenseList ], 
   function( cat, diffs )
   return FiniteCochainComplexByDifferentialList( cat, diffs, 0 );
   end );
##

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
  local newDifferentials;
  newDifferentials := Shift( Differentials( C ), i );
  if i mod 2 = 1 then
    newDifferentials := Map( newDifferentials, d -> -d );
  fi;
  
  if IsChainComplex( C ) then 
     return ChainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  else
     return CochainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  fi;
end );
##

#c
InstallMethod( ShiftUnsigned, [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local newDifferentials;
  newDifferentials := Shift( Differentials( C ), i );
  
  if IsChainComplex( C ) then 
     return ChainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  else
     return CochainComplexByDifferentialList( CatOfComplex( C ), newDifferentials );
  fi;
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


