

# Lazy apply of a function f on a z list

InstallMethod( MapLazy,
               [ IsZList, IsFunction, IsInt ],
  function( l, f, n )
  
  if n<0 then 

       Error( "Number of arguments should be >= 0" );

  fi;

  return MakeInfList( IsMapZList,
                      rec( ),
                      [ BaseList, l,
                      MapFunction, f,
                      NrArg, n ] );
end );

InstallMethod( MapLazy,
               [ IsDenseList, IsFunction, IsInt ],
  function( l, f, n )
  return MapLazy( CombineZLazy( l ), f, n );
end );

# Lazy combination of z lists

InstallMethod( CombineZLazy,
               [ IsDenseList ],
  function( lists )
  return MakeInfList( IsCombinationZList,
                      rec( ),
                      [ BaseLists, lists ] );
end );

# shift of MapZList

InstallMethod( ShiftLazyOp, [ IsZList, IsInt ],
  function( l, i )
  return MakeInfList( IsShiftedZList,
                      rec( ),
                      [ BaseList, l,
                        ShiftIndex, i ] );
end );

# Reflection of z list

InstallMethod( Reflection,
               [ IsZList ],
  function( l )
  return MakeInfList( IsReflectedZList,
                      rec( ),
                      [ BaseList, l,
                        Reflection, l ] );
end );

# Compute the entry in index n

InstallMethod( LookupInfList,
               [ IsMapZList, IsInt ],
   function( l, n )
   local b;
   b := BaseList( l )[ n ];

   if NrArg( l) = 1 then 
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

InstallMethod( LookupInfList,
               [ IsShiftedZList, IsInt ],
   function( l, n )
   return BaseList( l )[ n + ShiftIndex( l ) ];
end );

InstallMethod( LookupInfList,
               [ IsReflectedZList, IsInt ],
   function( l, n )
   return BaseList( l )[ -n ];
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

InstallMethod( \=, [ IsShiftedZList, IsShiftedZList ],
  function( l1, l2 )
  return BaseList( l1 ) = BaseList( l2 ) and ShiftIndex( l1 ) = ShiftIndex( l2 );
end );

InstallMethod( \=, [ IsReflectedZList, IsReflectedZList ],
  function( l1, l2 )
  return BaseList( l1 ) = BaseList( l2 );
end );

