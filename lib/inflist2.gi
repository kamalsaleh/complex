

# Lazy apply of a function f on a z list

InstallMethod( MapLazy, 
               [ IsZList, IsFunction ],
  function( l, f )
  return MakeInfList( IsMapZList,
                      rec( ),
                      [ BaseList, l,
                      MapFunction, f ] );
end );

InstallMethod( MapLazy, 
               [ IsDenseList, IsFunction ],
  function( l, f )
  return MapLazy( CombineZLazy( l ), f );
end );

# Lazy combination of z lists

InstallMethod( CombineZLazy,
               [ IsDenseList ],
  function( lists )
  return MakeInfList( IsCombinationZList,
                      rec( ),
                      [ BaseLists, lists ] );
end );

# Compute the entry in index n

InstallMethod( LookupInfList,
               [ IsMapZList, IsInt ],
   function( l, n )
   local b;
   b := BaseList( l )[ n ];

   if not IsList( b ) then 
      return MapFunction( l )( b );
   else 
      return CallFuncList( MapFunction( l ), b );
   fi;
end );

InstallMethod( LookupInfList,
               [ IsCombinationZList, IsInt ],
   function( l, n )
   return List( BaseLists( l ), u -> u[ n ] );
end );

# testing if two combination z lists are equal!

InstallMethod( \=, [ IsCombinationZList, IsCombinationZList ],
  function( l1, l2 )
  return BaseLists( l1 ) = BaseLists( l2 );
end );

# testing if two map z lists are equal!

InstallMethod( \=, [ IsMapZList, IsMapZList ],
  function( l1, l2 )
  return BaseList( l1 ) = BaseList( l2 ) and MapFunction( l1 ) = MapFunction( l2 );
end );
