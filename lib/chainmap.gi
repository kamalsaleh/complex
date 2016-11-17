DeclareRepresentation( "IsChainMapRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainMaps",
            NewFamily( "chain maps" ) );

InstallMethod( ChainMapByMorphismList,
               [ IsChainComplex, IsChainComplex, IsZList ],
function( C1, C2, morphisms )
  local type, map;
  type := NewType( FamilyOfChainComplexes,
                   IsChainMap and IsChainMapRep );
  map := rec();
  ObjectifyWithAttributes( map, type,
                           Source, C1,
                           Range, C2,
                           MorphismsOfChainMap, morphisms );
  Add( CapCategory( C1 ), map );
  return map;
end );

InstallMethod( FiniteChainMap, [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ],
function( C1, C2, base_pos, morphisms_list )
  local zero_morphisms, morphisms;
  zero_morphisms := Map( [ ObjectsOfComplex( C1 ),
                           ObjectsOfComplex( C2 ) ],
                         ZeroMorphism );
  morphisms := Replace( zero_morphisms, base_pos, morphisms_list );
  return ChainMapByMorphismList( C1, C2, morphisms );
end );

InstallMethod( ZeroChainMap, [ IsChainComplex, IsChainComplex ],
function( C1, C2 )
  local morphisms;
  morphisms := Map( [ ObjectsOfComplex( C1 ),
                      ObjectsOfComplex( C2 ) ],
                    ZeroMorphism );
  return ChainMapByMorphismList( C1, C2, morphisms );
end );

InstallMethod( MorphismOfChainMap,
[ IsChainMap, IsInt ],
function( map, i )
    return MorphismsOfChainMap( map )[ i ];
end );

InstallMethod( \[\], [ IsChainMap, IsInt ], MorphismOfChainMap );

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
