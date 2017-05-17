SetPackageInfo( rec(
PackageName := "complex",
Subtitle := "I wear a chain complex now.  Chain complexes are cool",

Version := Maximum( [
                   "2017.05.10", ## Kamals's version
                   ] ),

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

# Version := "27.01.2017",
# Date := "27/01/2017",
##  Optional: if the package manual uses GAPDoc, you may duplicate the 
##  version and the release date as shown below to read them while building
##  the manual using GAPDoc facilities to distibute documents across files.
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.1-dev">
##  <!ENTITY RELEASEDATE "24 December 2013">
##  <#/GAPDoc>
PackageWWWHome :="https://bitbucket.org/karnesen/complex",
#ArchiveURL := Concatenation( ~.PackageWWWHome, "example-", ~.Version ),
ArchiveFormats := ".tar.gz",
Persons := [
  rec( 
    LastName      := "Arnesen",
    FirstNames    := "Kristin Krogh",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kristink@math.ntnu.no",
    WWWHome       := "http://www.math.ntnu.no/~kristink",
    PostalAddress := "Trondheim",
    Place         := "Trondheim",
    Institution   := "NTNU"
  ),
  rec( 
    LastName      := "Skartsaeterhagen",
    FirstNames    := "Oystein",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "oysteini@math.ntnu.no",
    WWWHome       := "http://www.math.ntnu.no/~oysteini",
    PostalAddress := "Trondheim",
    Place         := "Trondheim",
    Institution   := "NTNU"
  ),
   rec( 
    LastName      := "Saleh",
    FirstNames    := "Kamal",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kamal.saleh@uni-siegen.de",
    WWWHome       := "https://github.com/kamalsaleh/complex",
    PostalAddress := "Siegen",
    Place         := "Siegen University",
    Institution   := "Reine Mathematik und Informatik"
  ),
  
],
Status := "other",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
AbstractHTML := 
  "<b>boo</b>",

PackageDoc := rec(
  BookName  := "complex",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "The ultimate package",
),

Dependencies := rec(
  GAP := "4.4",
  NeededOtherPackages := [["GAPDoc", "1.3"],
                          ["CAP", "2015.09.20"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

));
