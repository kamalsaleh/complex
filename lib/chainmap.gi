

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
     local map;
     map := rec( );
     if ForAll( [ C1, C2 ], IsChainComplex ) then 
        ObjectifyWithAttributes( map, TheTypeOfChainMap,
                           Source, C1,
                           Range, C2,
                           MorphismsOfMap, morphisms );
                           
     elif ForAll( [ C1, C2 ], IsCochainComplex ) then 
        ObjectifyWithAttributes( map, TheTypeOfCochainMap,
                           Source, C1,
                           Range, C2,
                           MorphismsOfMap, morphisms );
     else
        Error( "first and second argument should be both chains or cochains" );
     fi;
     Add( CapCategory( C1 ), map );
     return map;
end );
##

#n
BindGlobal( "FINITE_CHAIN_OR_COCHAIN_MAP_BY_THREE_LISTS",
   function( l1,m1, l2,m2, mor, n, string )
   local cat, complex_category, complex_constructor, map_constructor, 
         C1, C2, zero, maps, min, max, all_maps, start_of_maps, end_of_maps, base_list;
   
   cat := CapCategory( l1[ 1 ] );
   min := Minimum( m1, m2 );
   max := Maximum( m1 + Length( l1 ) - 1, m2 + Length( l2 ) - 1 );
   
   start_of_maps := n;
   end_of_maps := n + Length( mor ) - 1;
   
   if string = "chain_map" then 
      complex_category := ChainComplexCategory( cat );
      complex_constructor := FiniteChainComplex;
      map_constructor := ChainMapByMorphismList;
      base_list := [ min - 1 .. max ];
   else 
      complex_category := CochainComplexCategory( cat );
      complex_constructor := FiniteCochainComplex;
      map_constructor := CochainMapByMorphismList;
      base_list := [ min .. max + 1 ];
   fi;
   
   C1 := complex_constructor( l1, m1 );
   C2 := complex_constructor( l2, m2 );
   
   maps := List( base_list,      function( i )

                                 if i >= start_of_maps and i <= end_of_maps then 
                                        return mor[ i - start_of_maps + 1 ];
                                 else 
                                        return ZeroMorphism( C1[ i ], C2[ i ] );
                                 fi;
                                 end );
   
   zero := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
   
   zero := RepeatListN( [ zero ] );
   
   all_maps := Concatenate( zero, base_list[ 1 ], maps, zero );
   
   return map_constructor( C1, C2, all_maps );
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

# InstallMethod( FiniteChainMap, 
#                [ IsChainComplex, IsChainComplex, IsDenseList, n ],
#   function( C1, C2, maps, n )
#   local cat, zero, maps;
#   cat := UnderlyingCategory( CapCategory( C1 ) );
#   zero := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
#   zero := RepeatListN( [ zero ] );
#   maps := Concatenate( zero, n, maps, zero );
#   return ChainMapByMorphismList( C1, C2, maps );
# end );
# 
# InstallMethod( FiniteCochainMap, 
#                [ IsCochainComplex, IsCochainComplex, IsDenseList, n ],
#   function( C1, C2, maps, n )
#   local cat, zero, maps;
#   cat := UnderlyingCategory( CapCategory( C1 ) );
#   zero := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );
#   zero := RepeatListN( [ zero ] );
#   maps := Concatenate( zero, n, maps, zero );
#   return ChainMapByMorphismList( C1, C2, maps );
# end );
# 
# InstallMethod( FiniteChainMap, 
#                [ IsChainComplex, IsChainComplex, IsDenseList, n ],
#   function( C1, C2, maps, n )
#   return FiniteChainMap( C1, C2, maps, 0 );
# end );
# 
# InstallMethod( FiniteCochainMap, 
#                [ IsCochainComplex, IsCochainComplex, IsDenseList, n ],
#   function( C1, C2, maps, n )
#   return FiniteCochainMap( C1, C2, maps, 0 );
# end );


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

# InstallMethod( ViewObj, [ IsChainMap ],
# function( map )
#   Print( String( map ) );
# end );

#n
InstallMethod( IsQuasiIsomorphismMap, 
                  [ IsChainOrCochainMap ], 
   function( map )
   local C1, C2, l1,l2,u1,u2,l,i, h_functor, functor, lower_bound, upper_bound, cone_mapping, min, max;
   C1 := Source( map );
   C2 := Range( map );
   l1 := LowerBound( C1 );
   l2 := LowerBound( C2 );
   u1 := UpperBound( C1 );
   u2 := UpperBound( C2 );
   if u1 = NegativeInfinity or u2 = NegativeInfinity then
      return true;
   fi;
   if l1 = PositiveInfinity or l2 = PositiveInfinity then
      return true;
   fi;
   if not IsInt( l1 ) or not IsInt( l2 ) then 
      return fail;
   fi;
   if not IsInt( u1 ) or not IsInt( u2 ) then 
      return fail;
   fi;
#    the commented code is also true.
#    lower_bound := Minimum( l1, l2 );
#    upper_bound := Maximum( u1, u2 );
#    cone_mapping := MappingCone( map );
#    return ForAll( [ lower_bound .. upper_bound + 1 ], i-> IsExactInIndex( cone_mapping, i ) );
   if IsChainMap( map ) then 
      h_functor := HomologyAsFunctor;
   else 
      h_functor := CohomologyAsFunctor;
   fi;
   min := Maximum( l1, l2 ) - 1;
   max := Minimum( u1, u2 ) + 1;
   return ForAll( [ min .. max ], function( i )
                                   local functor; 
                                   functor := h_functor( UnderlyingCategory( CapCategory( map ) ), i );
                                   return IsIsomorphism( ApplyFunctor( functor, map ) );
                                   end );
end );
##

InstallMethod( SetString, [ IsChainMap, IsString ],
               function( m, str ) end );
