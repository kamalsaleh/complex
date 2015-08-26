DeclareRepresentation( "IsInfListAssertionRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfInfListAssertions",
            NewFamily( "infinite list assertions" ) );

InstallMethod( MakeSingleAssertion, [ IsObject, IsFunction, IsString ],
function( obj, f, msg )
  return MakeAssertion( IsInfListSingleAssertion, obj, f, msg, 0, false );
end );

InstallMethod( MakeDoubleAssertion, [ IsObject, IsFunction, IsString ],
function( obj, f, msg )
  return MakeAssertion( IsInfListDoubleAssertion, obj, f, msg, 0, false );
end );

InstallMethod( MakeAssertion, [ IsFunction, IsObject, IsFunction, IsString, IsInt, IsBool ],
function( cat, obj, f, msg, offset, reversed )
  local A, dir;
  if cat <> IsInfListSingleAssertion and cat <> IsInfListDoubleAssertion then
    Error( "first argument to MakeAssertion must be either ",
           "IsInfListSingleAssertion or IsInfListDoubleAssertion" );
  fi;
  if reversed then dir := -1; else dir := 1; fi;
  A := rec();
  ObjectifyWithAttributes( A, NewType( FamilyOfInfListAssertions,
                                       cat and IsInfListAssertionRep ),
                           AssertionObject, obj,
                           AssertionFunction, f,
                           AssertionMessage, msg,
                           AssertionOffset, offset,
                           AssertionDirection, dir,
                           IsReversed, reversed );
  return A;
end );

InstallMethod( Shift, [ IsInfListSingleAssertion, IsInt ],
function( A, i )
  return MakeAssertion( IsInfListSingleAssertion,
                        AssertionObject( A ),
                        AssertionFunction( A ),
                        AssertionMessage( A ),
                        AssertionOffset( A ) + i * AssertionDirection( A ),
                        IsReversed( A ) );
end );

InstallMethod( Shift, [ IsInfListDoubleAssertion, IsInt ],
function( A, i )
  return MakeAssertion( IsInfListDoubleAssertion,
                        AssertionObject( A ),
                        AssertionFunction( A ),
                        AssertionMessage( A ),
                        AssertionOffset( A ) + i * AssertionDirection( A ),
                        IsReversed( A ) );
end );

InstallMethod( Reverse, [ IsInfListSingleAssertion ],
function( A )
  return MakeAssertion( IsInfListSingleAssertion,
                        AssertionObject( A ),
                        AssertionFunction( A ),
                        AssertionMessage( A ),
                        AssertionOffset( A ),
                        not IsReversed( A ) );
end );

InstallMethod( Reverse, [ IsInfListDoubleAssertion ],
function( A )
  return MakeAssertion( IsInfListDoubleAssertion,
                        AssertionObject( A ),
                        AssertionFunction( A ),
                        AssertionMessage( A ),
                        AssertionOffset( A ),
                        not IsReversed( A ) );
end );

InstallMethod( CheckAssertion, [ IsInfListSingleAssertion, IsInt, IsObject ],
function( A, i, elem )
  local obj, pos, f;
  obj := AssertionObject( A );
  pos := AssertionOffset( A ) + i * AssertionDirection( A );
  f := AssertionFunction( A );
  if not f( obj, pos, elem ) then
    Error( "Assertion failed: ", AssertionMessage( A ), "\n",
           "at position ", pos, " in ", obj );
  fi;
end );

InstallMethod( CheckAssertion, [ IsInfListDoubleAssertion, IsInt, IsObject, IsObject ],
function( A, i, elem1, elem2 )
  local obj, pos, f, r;
  obj := AssertionObject( A );
  pos := AssertionOffset( A ) + i * AssertionDirection( A );
  f := AssertionFunction( A );
  if IsReversed( A ) then
    r := f( obj, pos - 1, elem2, elem1 );
  else
    r := f( obj, pos, elem1, elem2 );
  fi;
  if not r then
    Error( "Assertion failed: ", AssertionMessage( A ), "\n",
           "at position ", pos, " in ", obj );
  fi;
end );
