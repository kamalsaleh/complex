
LoadPackage( "complex" );
LoadPackage( "CAP" );
LoadPackage( "ModulePresentationsForCAP" );
LoadPackage( "IO_ForHomalg" );


HOMALG_IO.show_banners := false;

HOMALG_IO.suppress_PID := true;

HOMALG_IO.use_common_stream := true;

AUTODOC_file_scan_list := [ "../examples/ChainComplexOfRightPresentations.g", "../examples/CochainComplexOfLeftPresentations.g" ];

LoadPackage( "GAPDoc" );

example_tree := ExtractExamples( Directory("/usr/local/lib/gap4r8/local/pkg/complex/doc/"), "complex.xml", AUTODOC_file_scan_list, 500 );

RunExamples( example_tree, rec( compareFunction := "uptowhitespace" ) );

QUIT;

