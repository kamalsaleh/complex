###############################################
# resolutions.gi             complex package
#
# Feb. 2017
###############################################


DeclareGlobalVariable( "ENOUGH_PROJECTIVES_INJECTIVES_METHODS" );

InstallValue( ENOUGH_PROJECTIVES_INJECTIVES_METHODS, rec( 

EpimorphismFromProjectiveObject := rec( 

installation_name := "EpimorphismFromProjectiveObject", 
filter_list := [ "object" ],
cache_name := "EpimorphismFromProjectiveObject",
return_type := "morphism",
post_function := function( object, return_value )
                 SetIsEpimorphism( return_value, true );
                 end ),

MonomorphismInInjectiveObject := rec(

installation_name := "MonomorphismInInjectiveObject",
filter_list := [ "object" ],
cache_name := "MonomorphismInInjectiveObject",
return_type := "morphism",
post_function := function( object, return_value )
                 SetIsMonomorphism( return_value, true );
                 end ),
) );

CAP_INTERNAL_ENHANCE_NAME_RECORD( ENOUGH_PROJECTIVES_INJECTIVES_METHODS );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( ENOUGH_PROJECTIVES_INJECTIVES_METHODS );

###############################
#
# Resolutions
#
###############################

# Here is categorical mathematical construction. It commented since there is more direct construction.
#
# InstallMethod( QuasiIsomorphismFromProjectiveResolution, 
#                  [ IsBoundedAboveCochainComplex ], 
# function( C )
# local u, cat, proj, zero, inductive_list;
# 
# cat := UnderlyingCategory( CapCategory( C ) );
# 
# u := ActiveUpperBound( C );
# 
# zero := ZeroObject( cat );
# 
# inductive_list := MapLazy( IntegersList, function( k )
#                                          local current_mor, current_complex, cone, nat_inj, ker_k, mor_from_proj, injec_in_C;
#                                          if k >= u then
#                                             return [ ZeroMorphism( zero, zero ), ZeroMorphism( zero, C[ k ] ) ];
#                                          else
#                                             current_complex := CochainComplex( cat, MapLazy( inductive_list, function( j ) 
#                                                                                                                  return j[ 1 ]; 
#                                                                                                              end, 1 ) );
#                                             current_complex := BrutalTruncationBelow( current_complex, k );
#                                             current_mor := CochainMorphism( current_complex, C, MapLazy( IntegersList, function( j )
#                                                                                                                    if j <= k then return ZeroMorphism( zero, C[ j ] );
#                                                                                                                    else return inductive_list[ j ][ 2 ];
#                                                                                                                    fi;
#                                                                                                                    end, 1 ) );
#                                             cone := MappingCone( current_mor );
#                                             nat_inj := NaturalProjectionFromMappingCone( current_mor );
#                                             ker_k := CertainCycle( cone, k );
#                                             mor_from_proj := EpimorphismFromProjectiveObject( Source( ker_k ) );
#                                             injec_in_C := ProjectionInFactorOfDirectSum( [ ShiftLazy( current_complex, 1 ), C ], 2 );
#                                             return [ PreCompose( [ mor_from_proj, ker_k, nat_inj[ k ] ] ), PreCompose( [ mor_from_proj, ker_k, injec_in_C[ k ] ] ) ];
#                                          fi;
#                                          end, 1 );
# 
# proj := CochainComplex( cat, MapLazy( inductive_list, function( j ) return j[ 1 ]; end, 1 ) );
# 
# SetUpperBound( proj, u );
# 
# return CochainMorphism( proj, C, MapLazy( inductive_list, function( j ) return j[ 2 ];end, 1 ) );
# 
# end );


InstallMethod( QuasiIsomorphismFromProjectiveResolution,
                 [ IsBoundedAboveCochainComplex ],
                 
function( C )
local u, cat, proj, zero, inductive_list;
 
cat := UnderlyingCategory( CapCategory( C ) );

if not HasHasEnoughProjectives( cat ) then
   Error( "It is not known whether the underlying category has enough projectives or not" );
fi;

if not HasHasEnoughProjectives( cat ) then 
   Error( "The underlying category must have enough projectives" );
fi;
 
u := ActiveUpperBound( C );
 
zero := ZeroObject( cat );
 
inductive_list := MapLazy( IntegersList, function( k )
                                         local k1, m1, mor4, mor2, mor3, m2, m, mor1, ker, pk;

                                         if k >= u then

                                            return [ ZeroMorphism( zero, zero ), ZeroMorphism( zero, C[ k ] ) ];

                                         else

                                            k1 := inductive_list[ k + 1 ][ 1 ];

                                            m1 := DirectSumFunctorial( [ AdditiveInverse( k1 ), C^k ] );

                                            mor1 := ProjectionInFactorOfDirectSum( [ Source( k1 ), C[ k ] ], 1 );

                                            mor2 := inductive_list[ k + 1 ][ 2 ];

                                            mor3 := InjectionOfCofactorOfDirectSum( [ Range( k1 ), C[ k + 1 ] ], 2 );

                                            m2 := PreCompose( [ mor1, mor2, mor3 ] );

                                            m := m1 - m2;

                                            mor4 := ProjectionInFactorOfDirectSum( [ Source( k1 ), C[ k ] ], 2 );

                                            ker := KernelEmbedding( m );

                                            pk := EpimorphismFromProjectiveObject( Source( ker ) );

                                            return [ PreCompose( [ pk, ker, mor1 ] ), PreCompose( [ pk, ker, mor4 ] ) ];

                                         fi;

                                         end, 1 );

proj := CochainComplex( cat, MapLazy( inductive_list, function( j ) return j[ 1 ]; end, 1 ) );
 
SetUpperBound( proj, u );
 
return CochainMorphism( proj, C, MapLazy( inductive_list, function( j ) return j[ 2 ]; end, 1 ) );
 
end );


InstallMethod( QuasiIsomorphismFromProjectiveResolution,
                 [ IsBoundedBelowChainComplex ], 
function( C )
local cat, F, G, C1, quasi;

cat := UnderlyingCategory( CapCategory( C ) );

F := ChainToCochainComplexFunctor( cat );

G := CochainToChainComplexFunctor( cat );

C1 := ApplyFunctor( F, C );

quasi := QuasiIsomorphismFromProjectiveResolution( C1 );

return ApplyFunctor( G, quasi );

end );

