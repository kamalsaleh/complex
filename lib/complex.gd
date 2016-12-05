###################################################################################
#
#
#
#
#! @Chapter Complexe categories
#
###################################################################################


#! @Section Chain and cochain complex categories 

#! @Description
#!  bla bla
DeclareCategory( "IsChainOrCochainComplexCategory", IsCapCategory );

#! @Description
#!  bla bla
DeclareCategory( "IsChainComplexCategory", IsChainOrCochainComplexCategory );
#! @Description
#!  bla bla
DeclareCategory( "IsCochainComplexCategory", IsChainOrCochainComplexCategory );

###################################################
#
#  Constructors of (Co)chain complexes categories
#
###################################################

#! @Description
#!  Creates the chain complex category <A>Ch(A)</A> an Abelian category <A>A</A>.
#! @Arguments A
#! @Returns a CAP category
DeclareAttribute( "ChainComplexCategory", IsCapCategory );

#! @Description
#!  Creates the cochain complex category <A>CoCh(A)</A> an Abelian category <A>A</A>.
#! @Arguments A
#! @Returns a CAP category
DeclareAttribute( "CochainComplexCategory", IsCapCategory );

#! @Description
#! The input is a chain or cochain complex category <A>B=C(A)</A> constructed by one of the previous commands. 
#! The outout is <A>A</A>.
#! @Arguments B
#! @Returns a CAP category
DeclareAttribute( "UnderlyingCategory", IsChainOrCochainComplexCategory );



#! @Section Chain and cochain complexes 
#! @Description
#!  bla bla
DeclareCategory( "IsChainOrCochainComplex", IsCapCategoryObject );

#! @Description
#!  bla bla
DeclareCategory( "IsChainComplex", IsChainOrCochainComplex );

#! @Description
#!  bla bla
DeclareCategory( "IsCochainComplex", IsChainOrCochainComplex );

DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );


#########################################
#
#  Constructors of (Co)chain complexes 
#
#########################################


DeclareOperation( "ChainComplexByDifferentialList", [ IsCapCategory, IsZList, IsBool ] );
#! @Description
#! The input is category <A>A</A> and an infinite list <A>diffs</A>. The output is the chain complex $M_{\bullet}\in \mathrm{Ch}(A)$ where $d^M_{i}=\mathrm{diffs}[ i ]$.
#! @Arguments A, diffs
#! @Returns a chain complex
DeclareOperation( "ChainComplexByDifferentialList", [ IsCapCategory, IsZList ] );

DeclareOperation( "CochainComplexByDifferentialList", [ IsCapCategory, IsZList, IsBool ] );

#! @Description
#! The input is category <A>A</A> and an infinite list <A>diffs</A>. The output is the cochain complex $M^{\bullet}\in \mathrm{Ch}(A)$ where $d_M^{i}=\mathrm{diffs}[ i ]$.
#! @Arguments A, diffs
#! @Returns a cochain complex
DeclareOperation( "CochainComplexByDifferentialList", [ IsCapCategory, IsZList ] );

#! @Description
#! The input is a finite dense list <A>diffs</A> and an integer <A>n</A> . The output is the chain complex $M_{\bullet}\in \mathrm{Ch}(A)$ where 
#! $d^M_{n}=\mathrm{diffs}[ 1 ],d^M_{n+1}=\mathrm{diffs}[ 2 ],$ etc..
#! @Arguments diffs, n
#! @Returns a chain complex
DeclareOperation( "FiniteChainComplex", [ IsDenseList, IsInt ] );

#! @Description
#! The same as the previous command with <A>n=0</A>.
#! @Arguments diffs
#! @Returns a chain complex
DeclareOperation( "FiniteChainComplex", [ IsDenseList ] );

#! @Description
#! The input is a finite dense list <A>diffs</A> and an integer <A>n</A> . The output is the chain complex $M^{\bullet}\in \mathrm{CoCh}(A)$ where 
#! $d_M^{n}=\mathrm{diffs}[ 1 ],d_M^{n+1}=\mathrm{diffs}[ 2 ],$ etc..
#! @Arguments diffs, n
#! @Returns a cochain complex
DeclareOperation( "FiniteCochainComplex", [ IsDenseList, IsInt ] );

#! @Description
#! The same as the previous command with <A>n=0</A>.
#! @Arguments diffs
#! @Returns a cochain complex
DeclareOperation( "FiniteCochainComplex", [ IsDenseList ] );

DeclareOperation( "StalkChainComplex", [ IsCapCategoryObject ] );
DeclareOperation( "StalkCochainComplex", [ IsCapCategoryObject ] );

DeclareOperation( "ChainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );
DeclareOperation( "CochainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );
DeclareOperation( "ChainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "ChainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "CochainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );
DeclareOperation( "CochainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );
##

# DeclareAttribute( "ComplexCategory", IsCapCategory );
# DeclareAttribute( "CocomplexCategory", IsCapCategory );

#########################################
#
#   Functors
#
########################################


#! @Section Functors
#! @Description
#! The input is an Abelian category <A>A</A> and an integer <A>n</A>. The output is the $n$-th homology functor 
#! $H_n:\mathrm{Ch}(A) \rightarrow A$.
#! @Arguments A,n
#! @Returns a functor
DeclareOperation( "HomologyAsFunctor", [ IsCapCategory, IsInt ] );

#! @Description
#! The input is an Abelian category <A>A</A> and an integer <A>n</A>. The output is the $n$-th cohomology functor 
#! $H^n:\mathrm{CoCh}(A) \rightarrow A$.
#! @Arguments A,n
#! @Returns a functor
DeclareOperation( "CohomologyAsFunctor", [ IsCapCategory, IsInt ] );

#! @Description
#! The input is a complex category <A>C=C(A)</A> and an integer <A>n</A>. The output is the the shift functor 
#! $T[n]:C \rightarrow C$, defined by $M\mapsto M[n]$ for complexes and by $\phi\mapsto \phi[n]$ for maps. In chain complex category we have  $M[n]_i=M_{n+i}, d_{i}^{M[n]}=(-1)^{n}d_{n+i}^{M}$
#! for any chain complex $M\in C$ and $\phi[n]_i=\phi_{n+i}$ for any chain map $\phi\in C$. The same holds in the cochain complex category, i.e.,
#! $M[n]^i=M^{n+i}, d^{i}_{M[n]}=(-1)^{n}d^{n+i}_{M}$ and $\phi[n]^i=\phi^{n+i}$.
#! @Arguments C(A), n
#! @Returns a functor
DeclareOperation( "ShiftAsFunctor", [ IsCapCategory, IsInt ] );

#! @Description
#! The input is a complex category <A>C=C(A)</A> and an integer <A>n</A>. The output is the the shift functor 
#! $S[n]:C \rightarrow C$, defined by $M\mapsto S[n](M)$ for complexes and by $\phi\mapsto S[n](\phi)$ for maps. In chain complex category we have $(S[n](M))_i=M_{n+i}, d_{i}^{S[n](M)}=d_{n+i}^{M}$
#! for any chain complex $M\in C$ and $\phi[n]_i=\phi_{n+i}$ for any chain map $\phi\in C$. The same holds in the cochain complex category, i.e.,
#! $(S[n](M))^i=M^{n+i}, d^{i}_{S[n](M)}=d^{n+i}_{M}$ and $\phi[n]^i=\phi^{n+i}$.
#! @Arguments C(A), n
#! @Returns a functor
DeclareOperation( "UnsignedShiftAsFunctor", [ IsCapCategory, IsInt ] );

#! @Description
#! The input is a category <A>A</A>. The output is the functor $F:\mathrm{Ch(A)}\rightarrow\mathrm{CoCh(A)}$ defined by $M_{\bullet}\mapsto M^{\bullet}$ for any 
#! for any chain complex $M_{\bullet}\in \mathrm{Ch}(A)$ and by $\phi_{\bullet}\mapsto \phi^{\bullet}$ for any map $\phi$ where $M^{i}=M_{-i}$ and $\phi^{i}=\phi_{-i}$.
#! @Arguments A
#! @Returns a functor
DeclareOperation( "ChainToCochainComplexAsFunctor", [ IsCapCategory ] );

#! @Description
#! The input is a category <A>A</A>. The output is the functor $F:\mathrm{CoCh(A)}\rightarrow\mathrm{Ch(A)}$ defined by $M^{\bullet}\mapsto M_{\bullet}$ for any 
#! cochain complex $M^{\bullet}\in \mathrm{CoCh}(A)$ and by $\phi^{\bullet}\mapsto \phi_{\bullet}$ for any map $\phi$ where $M_{i}=M^{-i}$ and $\phi_{i}=\phi^{-i}$.
#! @Arguments A
#! @Returns a functor
DeclareOperation( "CochainToChainComplexAsFunctor", [ IsCapCategory ] );
##



#c
# The following two operations are exactly the same as ChainComplexByDifferentialList.
# I 
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
##


DeclareOperation( "FiniteComplex", [ IsAbelianCategory, IsDenseList ] );
DeclareOperation( "StalkComplex", [ IsAbelianCategory, IsObject ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCategory ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCategory, IsObject, IsObject ] );
DeclareOperation( "InductiveComplex", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Resolution", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Coresolution", [ IsAbelianCategory, IsObject, IsFunction ] );
#c
DeclareOperation( "Shift", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainOrCochainComplex, IsInt ] );
##

DeclareOperation( "YonedaProduct", [ IsChainComplex, IsChainComplex ] );

DeclareOperation( "GoodTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "BrutalTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "SyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "CosyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "SyzygyCosyzygyTruncation", [ IsChainComplex, IsInt, IsInt ] );
#DeclareOperation( "CutComplexAbove", [ IsChainComplex ] );
#DeclareOperation( "CutComplexBelow", [ IsChainComplex ] );


##############################################
#
# Attributes of (co)chain complexes
#
##############################################

#c
DeclareAttribute( "DifferentialsOfComplex", IsChainOrCochainComplex );
DeclareAttribute( "Differentials", IsChainOrCochainComplex );

##
#c
# This is supposed to be called ObjectsOfComplex, but it
# causes a conflict with an operation in homalg
DeclareAttribute( "Objects", IsChainOrCochainComplex );
# DeclareAttribute( "ObjectsOfComplex", IsChainOrCochainComplex );
##

#n
DeclareAttribute( "ObjectsOfChainComplex", IsChainComplex );
DeclareAttribute( "ObjectsOfCochainComplex", IsCochainComplex );
##

DeclareAttribute( "CatOfComplex", IsChainOrCochainComplex );

##############################################
#
# operations derived from Attributes
#
##############################################

#c
DeclareOperation( "ObjectOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "\^", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "\[\]", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "CyclesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "HomologyOfChainComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "CohomologyOfCochainComplex", [ IsCochainComplex, IsInt ] );
DeclareOperation( "DefectOfExactness", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "IsExactInIndex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex, IsPosInt ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex, IsPosInt ] );
DeclareOperation( "SetUpperBound", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "SetLowerBound", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "Display", [ IsChainOrCochainComplex, IsInt, IsInt ] );
##

DeclareOperation( "HomologyOfComplex", [ IsChainComplex, IsInt ] );

#c
DeclareOperation( "UpperBound", [ IsChainComplex ] );
# DeclareOperation( "LowerBound", [ IsChainComplex ] );
##
#DeclareOperation( "IsFiniteComplex", [ IsChainComplex ] );
DeclareOperation( "IsBoundedComplex", [ IsChainComplex ] );
DeclareOperation( "LengthOfComplex", [ IsChainComplex ] );
DeclareOperation( "HighestKnownDegree", [ IsChainComplex ] );
DeclareOperation( "LowestKnownDegree", [ IsChainComplex ] );
DeclareProperty( "IsExactSequence", IsChainComplex );
DeclareOperation( "IsExactInDegree", [ IsChainComplex, IsInt ] );
DeclareProperty( "IsShortExactSequence", IsChainComplex );
DeclareOperation( "ForEveryDegree", [ IsChainComplex, IsFunction ] );
