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

# InstallMethod( FiniteChainMap, [ IsChainComplex, IsChainComplex, IsInt, IsList ],
# function( C1, C2, base_pos, morphisms )
#   local make_morphism, morphisms;
#   make_morphism := function( i )
#     return ZeroMorphism( ObjectOfComplex( C1, i ),
#                          ObjectOfComplex( C2, i ) );
#   end;
#   morphisms_pos := PositionalList( make_morphism );
#   return ChainMapByMorphismList( C1, C2, morphisms );
# end );

InstallMethod( ZeroChainMap, [ IsChainComplex, IsChainComplex ],
function( C1, C2 )
  local make_morphism, morphisms;
  make_morphism := function( i )
    return ZeroMorphism( ObjectOfComplex( C1, i ),
                         ObjectOfComplex( C2, i ) );
  end;
  morphisms := PositionalZList( make_morphism );
  return ChainMapByMorphismList( C1, C2, morphisms );
end );

InstallMethod( MorphismOfChainMap,
[ IsChainMap, IsInt ],
function( map, i )
    return MorphismsOfChainMap( map )[ i ];
end );

InstallMethod( \[\], [ IsChainMap, IsInt ], MorphismOfChainMap );

InstallMethod( String, [ IsChainMap ],
function( map )
  return Concatenation( "<chain map (",
                        InfListString( MorphismsOfChainMap( map ) ),
                        ")>" );
end );

