

########################################
#
# Representations, families and types
#
########################################


DeclareRepresentation( "IsChainMapRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainMaps",
            NewFamily( "chain maps" ) );

BindGlobal( "TheTypeOfChainMap",
            NewType( FamilyOfChainMaps, 
                     IsChainMap and IsChainMapRep ) );

DeclareRepresentation( "IsCochainMapRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfCochainMaps",
            NewFamily( "cochain maps" ) );

BindGlobal( "TheTypeOfCochainMap",
            NewType( FamilyOfCochainMaps, 
                     IsCochainMap and IsCochainMapRep ) );

#########################################
#
# (Co)chain maps constructors 
#
#########################################

#n
BindGlobal( "CHAIN_OR_COCHAIN_MAP_BY_LIST",
     function( C1, C2, morphisms )
     local map, l, u;
     map := rec( );
     if ForAll( [ C1, C2 ], IsChainComplex ) then 
        l := 1;
        u := 0;
        ObjectifyWithAttributes( map, TheTypeOfChainMap,
                           Source, C1,
                           Range, C2,
                           MorphismsOfMap, morphisms );

     elif ForAll( [ C1, C2 ], IsCochainComplex ) then 
        l := 0;
        u := 1;
        ObjectifyWithAttributes( map, TheTypeOfCochainMap,
                           Source, C1,
                           Range, C2,
                           MorphismsOfMap, morphisms );
     else
        Error( "first and second argument should be both chains or cochains" );
     fi;
     Add( CapCategory( C1 ), map );

     if IsBound( C1!.UpperBound ) then
        if IsBound( C2!.UpperBound ) then
           SetUpperBound( map, Minimum( C1!.UpperBound, C2!.UpperBound ) );
        else
           SetUpperBound( map, C1!.UpperBound );
        fi;
     elif IsBound( C2!.UpperBound ) then
           SetUpperBound( map, C2!.UpperBound );
     fi;

     if IsBound( C1!.LowerBound ) then
        if IsBound( C2!.LowerBound ) then
           SetLowerBound( map, Maximum( C1!.LowerBound, C2!.LowerBound ) );
        else
           SetLowerBound( map, C1!.LowerBound  );
        fi;
     elif IsBound( C2!.LowerBound ) then
           SetLowerBound( map, C2!.LowerBound  );
     fi;
     map!.ListOfComputedMorphisms := [ ];
     return map;
end );
##

#n
BindGlobal( "FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS",
   function( l1,m1, l2,m2, mor, n, string )
   local C1, C2, base_list, maps, zero, all_maps, cat, complex_category, complex_constructor, map_constructor, map;
   cat := CapCategory( l1[ 1 ] );

   if string = "chain_map" then 
      complex_category := ChainComplexCategory( cat );
      complex_constructor := FiniteChainComplex;
      map_constructor := ChainMapByMorphismList;
   else 
      complex_category := CochainComplexCategory( cat );
      complex_constructor := FiniteCochainComplex;
      map_constructor := CochainMapByMorphismList;
   fi;

   C1 := complex_constructor( l1, m1 );
   C2 := complex_constructor( l2, m2 );
   base_list := [ Minimum( ActiveLowerBound( C1 ), ActiveLowerBound( C2 ) ) + 1 .. Maximum( ActiveUpperBound( C1 ), ActiveUpperBound( C2 ) ) - 1 ];

   maps := List( base_list,      function( i )
                                 if i >= n and i <= n + Length( mor ) - 1 then 
                                        return mor[ i - n + 1 ];
                                 else 
                                        return ZeroMorphism( C1[ i ], C2[ i ] );
                                 fi;
                                 end );
   zero := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
   zero := RepeatListN( [ zero ] );
   all_maps := Concatenate( zero, base_list[ 1 ], maps, zero );
   map := map_constructor( C1, C2, all_maps );

  if n >= ActiveUpperBound( map ) then SetIsZero( map, true );fi;
  if n + Length( mor ) -1 <= ActiveLowerBound( map ) then SetIsZero( map, true ); fi;
  return map;
end );

#c
InstallMethod( ChainMapByMorphismList,
               [ IsChainComplex, IsChainComplex, IsZList ],
CHAIN_OR_COCHAIN_MAP_BY_LIST );
##

#n
InstallMethod( CochainMapByMorphismList,
               [ IsCochainComplex, IsCochainComplex, IsZList ],
CHAIN_OR_COCHAIN_MAP_BY_LIST );
##

#n
InstallMethod( FiniteChainMap,
               [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ],
   function( c1, m1, c2, m2, maps, n )
   return FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS( c1, m1, c2, m2, maps, n, "chain_map" );
end );

InstallMethod( FiniteCochainMap,
               [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ],
   function( c1, m1, c2, m2, maps, n )
   return FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS( c1, m1, c2, m2, maps, n, "cochain_map" );
end );

InstallMethod( FiniteChainMap,
               [ IsDenseList, IsDenseList, IsDenseList ],
   function( c1, c2, maps )
   return FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS( c1, 0, c2, 0, maps, 0, "chain" );
end );

InstallMethod( FiniteCochainMap, 
               [ IsDenseList, IsDenseList, IsDenseList ], 
   function( c1, c2, maps )
   return FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS( c1, 0, c2, 0, maps, 0, "cochain" );
end );

InstallMethod( FiniteChainMap, 
                [ IsChainComplex, IsChainComplex, IsDenseList, IsInt ],
   function( C1, C2, maps, n )
   local cat, zero, maps_list, obj1, obj2, negative_part, positive_part, map;
   cat := UnderlyingCategory( CapCategory( C1 ) );
   obj1 := Objects( C1 );
   obj2 := Objects( C2 );
   negative_part := Map( [ NegativePartFrom( obj1, n - 1 ), NegativePartFrom( obj2, n - 1 ) ], ZeroMorphism );
   positive_part := Map( [ PositivePartFrom( obj1, n + 1 ), PositivePartFrom( obj2, n + 1 ) ], ZeroMorphism );
   maps_list := Concatenate( negative_part, n, maps, positive_part );
   map := ChainMapByMorphismList( C1, C2, maps_list );
   if HasActiveUpperBound( map ) and n>= ActiveUpperBound( map ) then 
      SetIsZero( map, true );
   fi;
   
   if HasActiveLowerBound( map ) and n + Length( maps ) - 1 <= ActiveLowerBound( map ) then 
      SetIsZero( map, true );
   fi;
   if not HasActiveLowerBound( map ) then 
      SetLowerBound( map, n - 1 );
   fi;
   if not HasActiveUpperBound( map ) then
      SetUpperBound( map, n + Length( maps ) );
   fi;
   return map;
end );

InstallMethod( FiniteCochainMap, 
                [ IsCochainComplex, IsCochainComplex, IsDenseList, IsInt ],
   function( C1, C2, maps, n )
   local cat, zero, maps_list, obj1, obj2, negative_part, positive_part, map;
   cat := UnderlyingCategory( CapCategory( C1 ) );
   obj1 := Objects( C1 );
   obj2 := Objects( C2 );
   negative_part := Map( [ NegativePartFrom( obj1, n - 1 ), NegativePartFrom( obj2, n - 1 ) ], ZeroMorphism );
   positive_part := Map( [ PositivePartFrom( obj1, n + 1 ), PositivePartFrom( obj2, n + 1 ) ], ZeroMorphism );
   maps_list := Concatenate( negative_part, n, maps, positive_part );
   map := CochainMapByMorphismList( C1, C2, maps_list );
   if HasActiveUpperBound( map ) and n>= ActiveUpperBound( map ) then 
      SetIsZero( map, true );
   fi;
   if HasActiveLowerBound( map ) and n + Length( maps ) - 1 <= ActiveLowerBound( map ) then 
      SetIsZero( map, true );
   fi;
   
   if not HasActiveLowerBound( map ) then 
      SetLowerBound( map, n - 1 );
   fi;
   if not HasActiveUpperBound( map ) then
      SetUpperBound( map, n + Length( maps ) );
   fi;
   
   return map;
end );

InstallMethod( FiniteChainMap, 
                 [ IsChainComplex, IsChainComplex, IsDenseList ],
    function( C1, C2, maps )
    return FiniteChainMap( C1, C2, maps, 0 );
end );

InstallMethod( FiniteCochainMap, 
                 [ IsCochainComplex, IsCochainComplex, IsDenseList],
    function( C1, C2, maps )
    return FiniteCochainMap( C1, C2, maps, 0 );
end );
##

##################################
#
# Lower and upper bounds for maps
#
##################################

#n
InstallMethod( SetUpperBound, 
              [ IsChainOrCochainMap, IsInt ], 
   function( map, upper_bound )
   if IsBound( map!.UpperBound ) and map!.UpperBound < upper_bound then 
      Error( "There is already a smaller upper bound!" );
   fi;
   map!.UpperBound := upper_bound;
end );

InstallMethod( SetLowerBound, 
              [ IsChainOrCochainMap, IsInt ], 
   function( map, lower_bound )
   if IsBound( map!.LowerBound ) and map!.LowerBound > lower_bound then 
      Error( "There is already a greater lower bound!" );
   fi;
   map!.LowerBound := lower_bound;
end );

InstallMethod( ActiveUpperBound,
                [ IsChainOrCochainMap ],
   function( map )
   if not IsBound( map!.UpperBound ) then
      Error( "The map has not yet an upper bound" );
   fi;
   return map!.UpperBound;
end );

InstallMethod( ActiveLowerBound,
               [ IsChainOrCochainMap ],
   function( map )
   if not IsBound( map!.LowerBound ) then
      Error( "The map has not yet an upper bound" );
   fi;
   return map!.LowerBound;
end );

InstallMethod( HasActiveUpperBound,
              [ IsChainOrCochainMap ],
  function( map )
  return IsBound( map!.UpperBound );
end );

InstallMethod( HasActiveLowerBound,
            [ IsChainOrCochainMap ],
  function( map )
  return IsBound( map!.LowerBound );
end );
##
###################################
#
# Attributes of (Co)chain maps
#
###################################

#c
InstallMethod( MorphismsOfChainMap,
                  [ IsChainMap ],
MorphismsOfMap );
##

#n
InstallMethod( MorphismsOfCochainMap,
                  [ IsCochainMap ],
MorphismsOfMap );
##


InstallMethod( FiniteChainMap, [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ],
function( C1, C2, base_pos, morphisms_list )
  local zero_morphisms, morphisms;
  zero_morphisms := Map( [ Objects( C1 ),
                           Objects( C2 ) ],
                         ZeroMorphism );
  morphisms := Replace( zero_morphisms, base_pos, morphisms_list );
  return ChainMapByMorphismList( C1, C2, morphisms );
end );

#############################
#
#  Zero co(chain) maps
#
#############################

#n
InstallMethod( ZeroMap, [ IsChainOrCochainComplex, IsChainOrCochainComplex ], 
function( C1, C2 )
local morphisms;
   morphisms := Map( [ Objects( C1 ),
                      Objects( C2 ) ],
                    ZeroMorphism );
   if ForAll( [ C1, C2 ], IsChainComplex ) then 

      return ChainMapByMorphismList( C1, C2, morphisms );

   elif ForAll( [ C1, C2 ], IsCochainComplex ) then

      return CochainMapByMorphismList( C1, C2, morphisms );

   else 

      Error( "first and second argument should be both chains or cochains" );

   fi;
end );
##

#c
InstallMethod( ZeroChainMap, [ IsChainComplex, IsChainComplex ], ZeroMap );
##

#n
InstallMethod( ZeroCochainMap, [ IsCochainComplex, IsCochainComplex ], ZeroMap );
##

#############################
#
# Morphism of (co)chain maps
#
#############################

#n
InstallMethod( MorphismOfMap, 
          [ IsChainOrCochainMap, IsInt ], 
function( map, i )
     local l,j;
     l := map!.ListOfComputedMorphisms;
     if i in List( l, i->i[ 1 ] ) then 
        for j in l do
          if i = j[ 1 ] then 
              return j[ 2 ];
          fi;
        od;
     fi;
     Add( map!.ListOfComputedMorphisms, [ i, MorphismsOfMap( map )[ i ] ] );
     return MorphismsOfMap( map )[ i ];
end );
##

#c
InstallMethod( MorphismOfChainMap,[ IsChainMap, IsInt ], MorphismOfMap);
##

#n
InstallMethod( MorphismOfCochainMap,[ IsCochainMap, IsInt ], MorphismOfMap);
##

InstallMethod( \[\], [ IsChainOrCochainMap, IsInt ], MorphismOfMap );

InstallMethod( String, [ IsChainMap ],
               NICE_FLAGS + 1,
function( map )
  return Concatenation( "<chain map (",
                        InfListString( MorphismsOfChainMap( map ) ),
                        ")>" );
end );

#########################################
#
# View and display components of a (co)chain complex
#
#########################################

InstallMethod( ViewObj, 
               [ IsChainOrCochainMap ],
   function( map )
   if HasIsZero( map ) and IsZero( map ) then 
     TryNextMethod();
   elif IsBound( map!.UpperBound ) and IsBound( map!.LowerBound ) then 
     Print( "<A bounded morphism in ", Name( CapCategory( map ) ), ">" );
   elif IsBound( map!.LowerBound ) then 
     Print( "<A bounded from bellow morphism in ", Name( CapCategory( map ) ), ">" );
   elif IsBound( map!.UpperBound ) then 
   Print( "<A bounded from above morphism in ", Name( CapCategory( map ) ), ">" );
   else
   TryNextMethod( );
   fi;
end );

InstallMethod( Display, 
               [ IsChainOrCochainMap, IsInt, IsInt ], 
   function( map, m, n )
   local i;
   for i in [ m .. n ] do
   Print( "-----------------------------------------------------------------\n" );
   Print( "In index ", String( i ) );
   Print( "\n\nMorphism is\n" );
   Display( map[ i ] );
   od;
   end );

# InstallMethod( ViewObj, [ IsChainMap ],
# function( map )
#   Print( String( map ) );
# end );

#n
InstallMethod( IsQuasiIsomorphismMap, 
                  [ IsChainOrCochainMap ], 
   function( map )
   local min, max, h_functor, functor, i;

   if not HasActiveUpperBound(  Source( map ) ) or not HasActiveLowerBound(  Source( map ) ) then 
      Error( "The source is not known to be bounded" );
   fi;

   if not HasActiveUpperBound(  Range( map ) ) or not HasActiveLowerBound(  Range( map ) ) then 
      Error( "The range is not known to be bounded" );
   fi;

   min := Minimum( ActiveLowerBound(  Source( map ) ), ActiveLowerBound(  Range( map ) ) ) + 1;
   max := Maximum( ActiveUpperBound(  Source( map ) ), ActiveUpperBound(  Range( map ) ) ) - 1;

   if IsChainMap( map ) then 
      h_functor := HomologyAsFunctor;
   else 
      h_functor := CohomologyAsFunctor;
   fi;
   for i in [ min .. max ] do 
     functor := h_functor( UnderlyingCategory( CapCategory( map ) ), i );
     if not IsIsomorphism( ApplyFunctor( functor, map ) ) then 
        return false;
     fi;
   od;
   return true;
end );
##
########################################
#
# Mapping cone
#
########################################

BindGlobal( "MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP", 
    function( map )
    local complex_cat, shift, complex_constructor, morphism_constructor, A, B, C, A_shifted, C_shifted, map1, map2, 
          map_C_to_A_shifted, map_B_to_C, map_B_shifted_to_C_shifted, map_A_shifted_to_B_shifted, diffs_C, injection, 
          projection, complex, u;
    complex_cat := CapCategory( map );
    
    if IsChainMap( map ) then 
       shift := ShiftAsFunctor( complex_cat, -1 );
       complex_constructor := ChainComplexByDifferentialList;
       morphism_constructor := ChainMapByMorphismList;
       u := -1;
    else
       shift := ShiftAsFunctor( complex_cat, 1 );
       complex_constructor := CochainComplexByDifferentialList;
       morphism_constructor := CochainMapByMorphismList;
       u := 1;
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

    complex := complex_constructor( UnderlyingCategory( complex_cat), MorphismsOfMap( map1 - map2 ) );

    if HasActiveLowerBound( A ) and HasActiveLowerBound( B ) then 
       SetLowerBound( complex, Minimum( ActiveLowerBound( A ) - u, ActiveLowerBound( B ) ) );
    fi;
    if HasActiveUpperBound( A ) and HasActiveUpperBound( B ) then 
       SetUpperBound( complex, Maximum( ActiveUpperBound( A ) - u, ActiveUpperBound( B ) ) );
    fi;

    injection := MorphismsOfMap( InjectionOfCofactorOfDirectSum( [ A_shifted, B ], 2 ) );
    projection := MorphismsOfMap( ProjectionInFactorOfDirectSum( [ A_shifted, B ], 1 ) );

    injection := morphism_constructor( B, complex, injection );
    projection := morphism_constructor( complex, A_shifted, projection );

    SetInjectionInMappingCone( map, injection );
    SetProjectionFromMappingCone( map, projection );

    return [ complex, injection, projection ];
end );

#n
InstallMethod( MappingCone, [ IsChainOrCochainMap ], 
   function( map )
   return MAPPING_CONE_OF_CHAIN_OR_COCHAIN_MAP( map )[ 1 ]; 
end );

InstallMethod( InjectionInMappingCone, [ IsChainOrCochainMap ], 
   function( map )
   local mapping_cone;
   mapping_cone := MappingCone( map );
   return InjectionInMappingCone( map );
end );

InstallMethod( ProjectionFromMappingCone, [ IsChainOrCochainMap ], 
   function( map )
   local mapping_cone;
   mapping_cone := MappingCone( map );
   return ProjectionFromMappingCone( map );
end );
##
 
InstallMethod( SetString, [ IsChainMap, IsString ],
               function( m, str ) end );
