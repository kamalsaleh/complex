

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

BindGlobal( "TheTypeOfChainMaps",
            NewType( FamilyOfChainMaps, 
                     IsChainMap and IsChainMapRep ) );

DeclareRepresentation( "IsCochainMapRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfCochainMaps",
            NewFamily( "cochain maps" ) );

BindGlobal( "TheTypeOfCochainMaps",
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
        ObjectifyWithAttributes( map, TheTypeOfChainMaps,
                           Source, C1,
                           Range, C2,
                           MorphismsOfMap, morphisms );
                           
     elif ForAll( [ C1, C2 ], IsCochainComplex ) then 
        ObjectifyWithAttributes( map, TheTypeOfCochainMaps,
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
  zero_morphisms := Map( [ ObjectsOfComplex( C1 ),
                           ObjectsOfComplex( C2 ) ],
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
   morphisms := Map( [ ObjectsOfComplex( C1 ),
                      ObjectsOfComplex( C2 ) ],
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

InstallMethod( SetString, [ IsChainMap, IsString ],
               function( m, str ) end );
