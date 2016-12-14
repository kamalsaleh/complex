


InstallMethod( Map, 
               [ IsZList, IsFunction ],
  function( l, f )
  return MakeInfList( IsMapZList,
                      rec(),
                      [ BaseList, l,
                      MapFunction, f ] );
end );

InstallMethod( LookupInfList,
               [ IsMapZList, IsInt ],
   function( l, n )
   return MapFunction( l )( BaseList( l )[ n ] );
end );
