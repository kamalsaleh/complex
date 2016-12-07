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
     morphisms := morphism_constructor( new_source, new_range, morphisms );
     if HasActiveUpperBound( map ) then 
        SetUpperBound( morphisms, ActiveUpperBound( map ) - n );
     fi;
  
     if HasActiveLowerBound( map ) then 
        SetLowerBound( morphisms, ActiveLowerBound( map ) - n );
     fi;
     
     return morphisms;
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
     morphisms := morphism_constructor( new_source, new_range, morphisms );
     if HasActiveUpperBound( map ) then 
        SetUpperBound( morphisms, ActiveUpperBound( map ) - n );
     fi;
     if HasActiveLowerBound( map ) then 
        SetLowerBound( morphisms, ActiveLowerBound( map ) - n );
     fi;
     return morphisms;
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
     local diffs, neg_part, pos_part, new_diffs, complex;
     diffs := Differentials( C );
     neg_part := NegativePartFrom( diffs, 0 );
     pos_part := PositivePartFrom( diffs, 1 );
     new_diffs := Concatenate( pos_part, neg_part );
     complex := complex_constructor( cat, new_diffs );
     if HasActiveUpperBound( C ) then 
        SetLowerBound( complex, -ActiveUpperBound( C ) );
     fi;
     if HasActiveLowerBound( C ) then 
        SetUpperBound( complex, -ActiveLowerBound( C ) );
     fi;
     return complex;
     end );
   AddMorphismFunction( functor, 
     function( new_source, map, new_range )
     local morphisms, neg_part, pos_part, new_morphisms;
     morphisms := MorphismsOfMap( map );
     neg_part := NegativePartFrom( morphisms, 0 );
     pos_part := PositivePartFrom( morphisms, 1 );
     new_morphisms := Concatenate( pos_part, neg_part );
     new_morphisms := morphism_constructor( new_source, new_range, new_morphisms );
     if HasActiveUpperBound( map ) then 
        SetLowerBound( new_morphisms, -ActiveUpperBound( map ) );
     fi;
     if HasActiveLowerBound( map ) then 
        SetUpperBound( new_morphisms, -ActiveLowerBound( map ) );
     fi;
     return new_morphisms;
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

