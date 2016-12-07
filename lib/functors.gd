#########################################
#
#   Functors
#
########################################
#! @Chapter Functors
#! @Section basic functors for complex categories.

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
#! @EndSection
