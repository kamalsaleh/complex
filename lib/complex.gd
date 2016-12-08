###################################################################################
#
#
#
#
#! @Chapter Complexes categories
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
#! @EndSection

DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );

#! @Chapter Working with complexes

#! @Section Filters 
#! @Description
#!  bla bla
DeclareCategory( "IsChainOrCochainComplex", IsCapCategoryObject );

#! @Description
#!  bla bla
DeclareCategory( "IsChainComplex", IsChainOrCochainComplex );

#! @Description
#!  bla bla
DeclareCategory( "IsCochainComplex", IsChainOrCochainComplex );
#! @EndSection

#! @Section Creating chain and cochain complexes
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

#! @InsertChunk cochain_creation

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

#! @InsertChunk 2
#! @Description
#! The input is an object $M\in A$. The output is chain complex $M_{\bullet}\in\mathrm{Ch(A)}$ where $M_0=M$ and $M_i=0$ whenever $i\neq 0$.
#! @Arguments M
#! @Returns a chain complex
DeclareOperation( "StalkChainComplex", [ IsCapCategoryObject ] );

#! @Description
#! The input is an object $M\in A$. The output is cochain complex $M^{\bullet}\in\mathrm{CoCh(A)}$ where $M^0=M$ and $M^i=0$ whenever $i\neq 0$.
#! @Arguments M
#! @Returns a cochain complex
DeclareOperation( "StalkCochainComplex", [ IsCapCategoryObject ] );

#! @InsertChunk 3
#! @Description
#! The input is a morphism $d\in A$ and two functions $F,G$. 
#! The output is chain complex $M_{\bullet}\in\mathrm{Ch(A)}$ where $d^{M}_{0}=d$ 
#! and $d^M_{i}=G^{i}( d )$ for all $i\leq -1$ and $d^M_{i}=F^{i}( d )$ for all $i \geq 1$.
#! @Arguments d,G,F
#! @Returns a chain complex
DeclareOperation( "ChainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );

#! @Description
#! The input is a morphism $d\in A$ and two functions $F,G$. 
#! The output is cochain complex $M^{\bullet}\in\mathrm{CoCh(A)}$ where $d_{M}^{0}=d$ 
#! and $d_M^{i}=G^{i}( d )$ for all $i\leq -1$ and $d_M^{i}=F^{i}( d )$ for all $i \geq 1$.
#! @Arguments d,G,F
#! @Returns a cochain complex
DeclareOperation( "CochainComplexWithInductiveSides", [ IsCapCategoryMorphism, IsFunction, IsFunction ] );

#! @Description
#! The input is a morphism $d\in A$ and a functions $G$. 
#! The output is chain complex $M_{\bullet}\in\mathrm{Ch(A)}$ where $d^{M}_{0}=d$ 
#! and $d^M_{i}=G^{i}( d )$ for all $i\leq -1$ and $d^M_{i}=0$ for all $i \geq 1$.
#! @Arguments d,G
#! @Returns a chain complex
DeclareOperation( "ChainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );

#! @Description
#! The input is a morphism $d\in A$ and a functions $F$. 
#! The output is chain complex $M_{\bullet}\in\mathrm{Ch(A)}$ where $d^{M}_{0}=d$ 
#! and $d^M_{i}=F^{i}( d )$ for all $i\geq 1$ and $d^M_{i}=0$ for all $i \leq 1$.
#! @Arguments d,F
#! @Returns a chain complex
DeclareOperation( "ChainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );

#! @Description
#! The input is a morphism $d\in A$ and a functions $G$. 
#! The output is cochain complex $M^{\bullet}\in\mathrm{CoCh(A)}$ where $d_{M}^{0}=d$ 
#! and $d_M^{i}=G^{i}( d )$ for all $i\leq -1$ and $d_M^{i}=0$ for all $i \geq 1$.
#! @Arguments d,G
#! @Returns a cochain complex
DeclareOperation( "CochainComplexWithInductiveNegativeSide", [ IsCapCategoryMorphism, IsFunction ] );

#! @Description
#! The input is a morphism $d\in A$ and a functions $F$. 
#! The output is cochain complex $M^{\bullet}\in\mathrm{CoCh(A)}$ where $d_{M}^{0}=d$ 
#! and $d_M^{i}=F^{i}( d )$ for all $i\geq 1$ and $d_M^{i}=0$ for all $i \leq 1$.
#! @Arguments d,F
#! @Returns a cochain complex
DeclareOperation( "CochainComplexWithInductivePositiveSide", [ IsCapCategoryMorphism, IsFunction ] );
##
#! @InsertChunk 4

# DeclareAttribute( "ComplexCategory", IsCapCategory );
# DeclareAttribute( "CocomplexCategory", IsCapCategory );

##############################################
#
# Attributes of (co)chain complexes
#
##############################################
#! @EndSection
#! @Section Attributes and operations on complexes.

#! @BeginGroup 1
#! @Description
#! Both commands return the differentials of the chain or cochain complex as an infinite list.
#! @Arguments C
#! @Returns an infinite list
DeclareAttribute( "Differentials", IsChainOrCochainComplex );
#! @EndGroup
#! @Group 1
#! @Arguments C
DeclareAttribute( "DifferentialsOfComplex", IsChainOrCochainComplex );
##
#c
# This is supposed to be called ObjectsOfComplex, but it
# causes a conflict with an operation in homalg
# DeclareAttribute( "ObjectsOfComplex", IsChainOrCochainComplex );
##

#! @BeginGroup 2
#! @Description
#! All commands return the objects of the chain or cochain complex as an infinite list.
#! @Arguments C
#! @Returns an infinite list
DeclareAttribute( "Objects", IsChainOrCochainComplex );
#! @Arguments C
DeclareAttribute( "ObjectsOfChainComplex", IsChainComplex );
##
#! @EndGroup
#! @Group 2
#! @Arguments C
DeclareAttribute( "ObjectsOfCochainComplex", IsCochainComplex );

DeclareAttribute( "CatOfComplex", IsChainOrCochainComplex );

##############################################
#
# operations derived from Attributes
#
##############################################

#c
#! @BeginGroup 3
#! @Description
#! Both commands return the object of the chain or cochain complex in index $i$.
#! @Arguments C, i
DeclareOperation( "ObjectOfComplex", [ IsChainOrCochainComplex, IsInt ] );
#! @EndGroup
#! @Group 3
#! @Arguments C, i
#! @Returns an object
DeclareOperation( "\[\]", [ IsChainOrCochainComplex, IsInt ] );

#! @BeginGroup 4
#! @Description
#! Both commands return the differential of the chain or cochain complex in index $i$.
#! @Arguments C, i
DeclareOperation( "DifferentialOfComplex", [ IsChainOrCochainComplex, IsInt ] );
#! @EndGroup
#! @Group 4
#! @Arguments C, i
#! @Returns a morphism
DeclareOperation( "\^", [ IsChainOrCochainComplex, IsInt ] );

#! @Description
#! The input is a chain or cochain complex $C$ and an integer $n$. The outout is the homology(cohomology) object of $C$ in index $n$ if $C$ is chain(cochain) complex.
#! @Arguments C, n
#! @Returns a object
DeclareOperation( "DefectOfExactness", [ IsChainOrCochainComplex, IsInt ] );

#! @Description
#! The input is a chain or cochain complex $C$ and an integer $n$. The outout is <A>true</A> if $C$ is exact in $i$. Otherwise the output is <A>false</A>.
#! @Arguments C, n
#! @Returns true or false
DeclareOperation( "IsExactInIndex", [ IsChainOrCochainComplex, IsInt ] );

#! @Description
#! The command sets an upper bound $n$ to the chain(cochain) complex $C$. This means $C_{i\geq n}=0(C^{\geq n}=0)$. This upper bound will be called $\textit{active}$ upper bound and it can be changed whenever it is needed.
#! @Arguments C, n
#! @Returns a nothing
DeclareOperation( "SetUpperBound", [ IsChainOrCochainComplex, IsInt ] );

#! @Description
#! The command sets a lower bound $n$ to the chain(cochain) complex $C$. This means $C_{i \leq n}=0(C^{i \leq n}=0)$.
#! This lower bound will be called $\textit{active}$ lower bound and it can be changed whenever it is needed.
#! @Arguments C, n
#! @Returns nothing
DeclareOperation( "SetLowerBound", [ IsChainOrCochainComplex, IsInt ] );

#! @Description
#! The input is chain or cochain complex. The output is <A>true</A> if an upper bound has been set to $C$ and <A>false</A> otherwise.
#! @Arguments C
#! @Returns true or false
DeclareOperation( "HasActiveUpperBound", [ IsChainOrCochainComplex ] );

#! @Description
#! The input is chain or cochain complex. The output is <A>true</A> if a lower bound has been set to $C$ and <A>false</A> otherwise.
#! @Arguments C
#! @Returns true or false
DeclareOperation( "HasActiveLowerBound", [ IsChainOrCochainComplex ] );

#! @Description
#! The input is chain or cochain complex. The output is its active upper bound if such has been set to $C$. Otherwise we get error.
#! @Arguments C
#! @Returns an integer
DeclareOperation( "ActiveUpperBound", [ IsChainOrCochainComplex ] );

#! @Description
#! The input is chain or cochain complex. The output is its active lower bound if such has been set to $C$. Otherwise we get error.
#! @Arguments C
#! @Returns an integer
DeclareOperation( "ActiveLowerBound", [ IsChainOrCochainComplex ] );

#! @Description
#! The input is chain or cochain complex $C$ and two integers $m$ and $n$. The command displays all components of $C$ between the indices $m,n$.
#! @Arguments C, m, n
#! @Returns nothing
DeclareOperation( "Display", [ IsChainOrCochainComplex, IsInt, IsInt ] );

#! @EndSection

#! @InsertChunk maps


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



DeclareOperation( "HomologyOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "CyclesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsChainOrCochainComplex, IsInt ] );
DeclareOperation( "HomologyOfChainComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "CohomologyOfCochainComplex", [ IsCochainComplex, IsInt ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "LowerBound", [ IsChainOrCochainComplex, IsPosInt ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex ] );
DeclareOperation( "UpperBound", [ IsChainOrCochainComplex, IsPosInt ] );
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
