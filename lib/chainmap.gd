
#! @Chapter Working with maps
#! @Section Filters

#! @Description
#!  bla bla
#! @Arguments \phi
DeclareCategory( "IsChainOrCochainMap", IsCapCategoryMorphism );

#! @Description
#!  bla bla
#! @Arguments \phi
DeclareCategory( "IsChainMap", IsChainOrCochainMap );

DeclareCategoryFamily( "IsChainMap" );

#n
#! @Description
#!  bla bla
#! @Arguments \phi
DeclareCategory( "IsCochainMap", IsChainOrCochainMap );

DeclareCategoryFamily( "IsCochainMap" );
#! @EndSection

# DeclareRepresentation( "IsChainMapDefaultRep",
#                        IsComponentObjectRep and IsAttributeStoringRep,
#                        [] );

################################
#
# Constructors of co-chain maps 
#
################################

#! @Section Creating chain and cochain maps

#! @Description
#! The input is two chain complexes $A,B$ and an infinite list $l$. 
#! The output is the chain map $\phi:A\rightarrow B$ defined by $\phi_i :=l[i]$.
#! @Arguments A, B, l
#! @Returns a chain map
DeclareOperation( "ChainMapByMorphismList",
                  [ IsChainComplex, IsChainComplex, IsZList ] );
#! @Description
#! The input is two cochain complexes $A,B$ and an infinite list $l$. 
#! The output is the cochain map $\phi:A\rightarrow B$ defined by $\phi^i :=l[i]$ for $i\in\mathcal{Z}$.
#! @Arguments A, B, l
#! @Returns a cochain map
DeclareOperation( "CochainMapByMorphismList",
                  [ IsCochainComplex, IsCochainComplex, IsZList ] );
##

#! @Description
#! The output is the chain map $\phi:A\rightarrow B$, where $A_m = s[ 1 ], A_{m+1} =s[ 2 ],$ etc.
#! $B_n = t[ 1 ], B_{n+1} =t[ 2 ],$ etc., and $\phi_{k}=l[1]$, $\phi_{k+1}=l[2]$, etc. 
#! @Arguments s,m,t,n,l, k
#! @Returns a chain map
DeclareOperation( "FiniteChainMap",
                  [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );

DeclareOperation( "FiniteChainMap",
                  [ IsDenseList, IsDenseList, IsDenseList ] );

#! @Description
#! The input is two chain complexes $A, B$ and a dense list $l$ and integer $k$. The output is the finite chain 
#! $\phi:A\rightarrow B$ where $\phi_k=l[1], \phi_{k+1}=l[2],$ etc.
#! @Arguments A,B,l, k
#! @Returns a chain map
DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsDenseList, IsInt ] );

DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsDenseList ] );

DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsInt, IsDenseList ] );

#! @Description
#! The output is the chain map $\phi:A\rightarrow B$, where $A^m = s[ 1 ], A^{m+1} =s[ 2 ],$ etc.
#! $B^n = t[ 1 ], B^{n+1} =t[ 2 ],$ etc., and $\phi^{k}=l[ 1 ]$, $\phi^{k+1}=l[ 2 ]$, etc. 
#! @Arguments s,m,t,n,l,k
#! @Returns a chain map
DeclareOperation( "FiniteCochainMap",
                  [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );

DeclareOperation( "FiniteCochainMap",
                  [ IsDenseList, IsDenseList, IsDenseList ] );
#! @Description
#! The input is two cochain complexes $A, B$ and a dense list $l$ and integer $k$. The output is the finite cochain 
#! $\phi:A\rightarrow B$ where $\phi_k=l[1], \phi_{k+1}=l[2],$ etc.
#! @Arguments A, B, l, k
#! @Returns a chain map
DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsDenseList, IsInt ] );

DeclareOperation( "FiniteCochainMap",
                  [ IsCochainComplex, IsCochainComplex, IsDenseList ] );
##

DeclareOperation( "FiniteChainMap",
                  [ IsChainComplex, IsChainComplex, IsInt, IsDenseList ] );
#######################################
#
#! @Section Attributes 
#
#######################################

DeclareAttribute( "Source", IsChainMap );
DeclareAttribute( "Range", IsChainMap );

#! @BeginGroup m1
#! @Description
#! The output is morphisms of the map as an infinite list.
#! @Arguments \phi
#! @Returns infinite list
DeclareAttribute( "MorphismsOfMap", IsChainOrCochainMap );
#! @Arguments \phi
DeclareAttribute( "MorphismsOfChainMap", IsChainMap );
#! @EndGroup
#! @Group m1
#! @Arguments \phi
DeclareAttribute( "MorphismsOfCochainMap", IsCochainMap );

#! @Description
#! The input a chain or cochain map $\phi:A \rightarrow B$. The output is its 
#! mapping cone complex $C(\phi )$.
#! @Arguments \phi
#! @Returns complex
DeclareAttribute( "MappingCone", IsChainOrCochainMap );

#! @Description
#! The input a chain or cochain map $\phi:A\rightarrow B$. The output is the natural injection 
#! $i:B\rightarrow C(\phi )$.
#! @Arguments \phi
#! @Returns chain or cochain map
DeclareAttribute( "InjectionInMappingCone", IsChainOrCochainMap );

#! @Description
#! The input a chain or cochain map $\phi:A\rightarrow B$. The output is the natural projection 
#! $\pi:C(\phi ) \rightarrow A[u]$. where $u=-1$ if $\phi$ is chain map and $u=1$ if $\phi$ is cochain map. 
#! @Arguments \phi
#! @Returns chain or cochain map
DeclareAttribute( "ProjectionFromMappingCone", IsChainOrCochainMap );
##
#! @EndSection

DeclareOperation( "MorphismOfMap", [ IsChainOrCochainMap, IsInt ] );
DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );

#n
DeclareOperation( "MorphismOfCochainMap", [ IsCochainMap, IsInt ] );
DeclareOperation( "\^", [ IsChainMap, IsInt ] );
DeclareOperation( "\[\]", [ IsChainOrCochainMap, IsInt ] );
DeclareOperation( "Display", [ IsChainOrCochainMap, IsInt, IsInt ] );
##

DeclareOperation( "HighestKnownDegree", [ IsChainMap ] );
DeclareOperation( "LowestKnownDegree", [ IsChainMap ] );

#DeclareOperation( "ChainMap", [ IsComplex, IsComplex, IsInt, IsList, IsObject, IsObject ] );

###############################
#
#! @Section Operations on maps
#
###############################

#! @BeginGroup m2
#! @Description
#! The output is the morphism of the map in index $i$.
#! @Arguments \phi, i
#! @Returns morphism
DeclareOperation( "MorphismOfMap", [ IsChainOrCochainMap, IsInt ] );
#! @Arguments \phi, i
DeclareOperation( "MorphismOfChainMap", [ IsChainMap, IsInt ] );
#! @EndGroup
#! @Group m2
#! @Arguments \phi, i
DeclareOperation( "MorphismOfCochainMap", [ IsCochainMap, IsInt ] );

#! @Description
#! The command sets an upper bound to the map $\phi$. An upper bound of $\phi$ is an integer $n$
#! with $\phi_{i\geq n}= 0$. The integer $n$ will be called **active** upper bound of $\phi$.
#! @Arguments \phi, n
#! @Returns nothing
DeclareOperation( "SetUpperBound", [ IsChainOrCochainMap, IsInt ] );

#! @Description
#! The command sets an lower bound to the map $\phi$. An lower bound of $\phi$ is an integer $n$
#! with $\phi_{i\leq m}= 0$. The integer $n$ will be called **active** lower bound of $\phi$.
#! @Arguments \phi, m
#! @Returns nothing
DeclareOperation( "SetLowerBound", [ IsChainOrCochainMap, IsInt ] );

#! @Description
#! The input is chain or cochain map $\phi$. 
#! The output is <A>true</A> if an upper bound has been set to $\phi$ and <A>false</A> otherwise.
#! @Arguments \phi
#! @Returns true or false
DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainMap ] );

#! @Description
#! The input is chain or cochain map $\phi$. 
#! The output is <A>true</A> if a lower bound has been set to $\phi$ and <A>false</A> otherwise.
#! @Arguments \phi
#! @Returns true or false
DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainMap ] );
##

#! @Description
#! The input is chain or cochain map. The output is its active upper bound if such has been set to $\phi$. Otherwise we get error.
#! @Arguments \phi
#! @Returns an integer
DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainMap ] );

#! @Description
#! The input is chain or cochain map. The output is its active lower bound if such has been set to $\phi$. Otherwise we get error.
#! @Arguments \phi
#! @Returns an integer
DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainMap ] );

#! @Description
#! The input is chain or cochain map. The output is <A>true</A> if $\phi$ is quasi-isomorphism. 
#! Otherwise it returns <A>false</A>. If the source or range of $\phi$ are not bounded we get error.
#! @Arguments \phi
#! @Returns true or false
DeclareOperation( "IsQuasiIsomorphismMap", [ IsChainOrCochainMap ] );

DeclareOperation( "ZeroMap", 
                  [ IsChainOrCochainComplex, IsChainOrCochainComplex ] );
DeclareOperation( "ZeroChainMap",
                  [ IsChainComplex, IsChainComplex ] );
DeclareOperation( "ZeroCochainMap", 
                  [ IsCochainComplex, IsCochainComplex ] );
##

