################################################
#  chainmaps.gd         complex package
#  Kamal Saleh
#  2017
#
#  Working with chain morphisms
#
################################################

#! @Chapter Complexes morphisms
#! @Section Categories and filters

#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsChainOrCochainMorphism", IsCapCategoryMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedBelowChainOrCochainMorphism", IsChainOrCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedAboveChainOrCochainMorphism", IsChainOrCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedChainOrCochainMorphism", IsBoundedBelowChainOrCochainMorphism and IsBoundedAboveChainOrCochainMorphism );

##
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsChainMorphism", IsChainOrCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedBelowChainMorphism", IsBoundedBelowChainOrCochainMorphism and IsChainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedAboveChainMorphism", IsBoundedAboveChainOrCochainMorphism and IsChainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedChainMorphism", IsBoundedChainOrCochainMorphism and IsChainMorphism );

##
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsCochainMorphism", IsChainOrCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedBelowCochainMorphism", IsBoundedBelowChainOrCochainMorphism and IsCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedAboveCochainMorphism", IsBoundedAboveChainOrCochainMorphism and IsCochainMorphism );
#! @Description
#!  bla bla
#! @Arguments phi
DeclareCategory( "IsBoundedCochainMorphism", IsBoundedChainOrCochainMorphism and IsCochainMorphism );
#! @EndSection

DeclareCategoryFamily( "IsChainMorphism" );
DeclareCategoryFamily( "IsCochainMorphism" );

######################################
#
# Constructors of co-chain morphisms 
#
######################################

#! @Section Creating chain and cochain morphisms

#! @Description
#! The input is two chain complexes $C,D$ and an infinite list $l$. 
#! The output is the chain morphism $\phi:C\rightarrow D$ defined by $\phi_i :=l[i]$.
#! @Arguments C, D, l
#! @Returns a chain morphism
DeclareOperation( "ChainMorphism",
                   [ IsChainComplex, IsChainComplex, IsZList ] );

#! @Description
#! The input is two chain complexes $C,D$, dense list $l$ and an integer $k$. 
#! The output is the chain morphism $\phi:C\rightarrow D$ such that $\phi_{k}=l[1]$, $\phi_{k+1}=l[2]$, etc. 
#! @Arguments C, D, l, k
#! @Returns a chain morphism
DeclareOperation( "ChainMorphism",
                  [ IsChainComplex, IsChainComplex, IsDenseList, IsInt ] );

#! @Description
#! The output is the chain morphism $\phi:C\rightarrow D$, where $C_m = c[ 1 ], C_{m+1} =c[ 2 ],$ etc.
#! $D_n = d[ 1 ], D_{n+1} =d[ 2 ],$ etc. and $\phi_{k}=l[1]$, $\phi_{k+1}=l[2]$, etc. 
#! @Arguments c,m,d,n,l, k
#! @Returns a chain morphism
DeclareOperation( "ChainMorphism",
                   [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );


#! @Description
#! The input is two cochain complexes $C,D$ and an infinite list $l$. 
#! The output is the cochain morphism $\phi:C\rightarrow D$ defined by $\phi_i :=l[i]$.
#! @Arguments C, D, l
#! @Returns a cochain morphism
DeclareOperation( "CochainMorphism",
		   [ IsCochainComplex, IsCochainComplex, IsZList ] );

#! @Description
#! The input is two cochain complexes $C,D$, dense list $l$ and an integer $k$. 
#! The output is the cochain morphism $\phi:C\rightarrow D$ such that $\phi^{k}=l[1]$, $\phi^{k+1}=l[2]$, etc. 
#! @Arguments C, D, l, k
#! @Returns a chain morphism
DeclareOperation( "CochainMorphism",
                  [ IsCochainComplex, IsCochainComplex, IsDenseList, IsInt ] );

#! @Description
#! The output is the cochain morphism $\phi:C\rightarrow D$, where $C^m = c[ 1 ], C^{m+1} =c[ 2 ],$ etc.
#! $D^n = d[ 1 ], D^{n+1} =d[ 2 ],$ etc. and $\phi^{k}=l[1]$, $\phi^{k+1}=l[2]$, etc. 
#! @Arguments c,m,d,n,l, k
#! @Returns a cochain morphism
DeclareOperation( "CochainMorphism",
                   [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ] );

#! @EndSection
######################################
#
#  Attribtes, Operations ..
#
######################################

#! @Section Attributes

#! @Description
#! The output is morphisms of the chain or cochain morphism as an infinite list.
#! @Arguments phi
#! @Returns infinite list
DeclareAttribute( "Morphisms", IsChainOrCochainMorphism );

#! @Description
#! The input a chain (resp. cochain) morphism $\phi:C \rightarrow D$. The output is its 
#! mapping cone chain (resp. cochain) complex $\mathrm{Cone}(\phi )$.
#! @Arguments phi
#! @Returns complex
DeclareAttribute( "MappingCone", IsChainOrCochainMorphism );

#! @Description
#! The input a chain (resp. cochain) morphism $\phi:C\rightarrow D$. The output is the natural injection 
#! $i:D\rightarrow \mathrm{Cone}\phi )$.
#! @Arguments phi
#! @Returns chain (resp. cochain) morphism
DeclareAttribute( "NaturalInjectionInMappingCone", IsChainOrCochainMorphism );

#! @Description
#! The input a chain ( resp. cochain) morphism $\phi:C\rightarrow D$. The output is the natural projection
#! $\pi:\mathrm{Cone}(\phi ) \rightarrow C[u]$ where $u=-1$ if $\phi$ is chain morphism and $u=1$ if $\phi$ is cochain morphism. 
#! @Arguments phi
#! @Returns chain (resp. cochain) morphism
DeclareAttribute( "NaturalProjectionFromMappingCone", IsChainOrCochainMorphism );
#! @EndSection

#! @Section Properties

#! @Description
#! The input a chain ( resp. cochain) morphism $\phi:C\rightarrow D$. The output is **true** if $\phi$ is quasi-isomorphism and **false** otherwise. If $\phi$ 
#! is not bounded an error is raised. 
#! @Arguments phi
DeclareProperty( "IsQuasiIsomorphism_", IsChainOrCochainMorphism );

#! @EndSection


#! @Section Operations

#! @Description
#! The command sets an upper bound to the morphism $\phi$. An upper bound of $\phi$ is an integer $u$
#! with $\phi_{i\geq u}= 0$. The integer $u$ will be called **active** upper bound of $\phi$. If $\phi$ already has an
#! active upper bound, say $u^\prime$, then $u^\prime$ will be replaced by $u$ only if $u\leq u^\prime$.
#! @Arguments phi, n
#! @Returns a side effect
DeclareOperation( "SetUpperBound", [ IsChainOrCochainMorphism, IsInt ] );

#! @Description
#! The command sets an lower bound to the morphism $\phi$. A lower bound of $\phi$ is an integer $l$
#! with $\phi_{i\leq l}= 0$. The integer $l$ will be called **active** lower bound of $\phi$. If $\phi$ already has an
#! active lower bound, say $l^\prime$, then $l^\prime$ will be replaced by $l$ only if $l\geq l^\prime$.
#! @Arguments phi, n
#! @Returns a side effect
DeclareOperation( "SetLowerBound", [ IsChainOrCochainMorphism, IsInt ] );

#! @Description
#! The input is chain or cochain morphism $\phi$. 
#! The output is <A>true</A> if an upper bound has been set to $\phi$ and <A>false</A> otherwise.
#! @Arguments phi
#! @Returns true or false
DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainMorphism ] );

#! @Description
#! The input is chain or cochain morphism $\phi$. 
#! The output is <A>true</A> if a lower bound has been set to $\phi$ and <A>false</A> otherwise.
#! @Arguments phi
#! @Returns true or false
DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainMorphism ] );

#! @Description
#! The input is chain or cochain morphism. The output is its active upper bound if such has been set to $\phi$. Otherwise we get error.
#! @Arguments phi
#! @Returns an integer
DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainMorphism ] );

#! @Description
#! The input is chain or cochain morphism. The output is its active lower bound if such has been set to $\phi$. Otherwise we get error.
#! @Arguments phi
#! @Returns an integer
DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainMorphism ] );


KeyDependentOperation( "CertainMorphism", IsChainOrCochainMorphism, IsInt, ReturnTrue );

#! @Description
#! The input is chain (resp. cochain) morphism and an integer $n$. The output is the component of $\phi$ in index $n$, i.e., $\phi_n$(resp. $\phi^n$).
#! @Arguments phi, n
#! @Returns an integer
DeclareOperation( "\[\]", [ IsChainOrCochainMorphism, IsInt ] );

#! @Description
#! The command displays the components of the morphism between $m$ and $n$. 
#! @Arguments phi, m, n
DeclareOperation( "Display", [ IsChainOrCochainMorphism, IsInt, IsInt ] );
#! @EndSection 

#! @Section Examples
#! @InsertChunk vec_2
#! @EndSection
#######################################
#
#  Global functions and variables
#
#######################################

DeclareGlobalVariable( "PROPAGATION_LIST_FOR_CO_CHAIN_MORPHISMS" );

DeclareGlobalFunction( "INSTALL_TODO_LIST_FOR_CO_CHAIN_MORPHISMS" );

DeclareGlobalFunction( "TODO_LIST_TO_CHANGE_MORPHISM_FILTERS_WHEN_NEEDED" );

DeclareAttribute( "FAL_BOUND", IsChainOrCochainMorphism );

DeclareAttribute( "FAL_BOUND", IsChainOrCochainMorphism );

DeclareProperty( "HAS_FAL_BOUND", IsChainOrCochainMorphism );

DeclareProperty( "HAS_FAL_BOUND", IsChainOrCochainMorphism );


