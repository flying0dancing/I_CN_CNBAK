#! /usr/bin/perl 

sub ModifyFile($$$);
sub main();

if($#ARGV==2){
   &main();
}else{
   print "Error: Must contains 3 arguments.Sequence is ProductPath oldDataBase newDataBase.\n";
}

sub main()
{

   my $ProductPath=shift @ARGV;
   my $ODB=shift @ARGV;
   my $NDB=shift @ARGV;
   chomp($ProductPath);
   chomp($NDB);
   chomp($ODB);
  $ProductPath=$ProductPath."\\Configuration";
  #my $DB_Data=$NDB."_DATA";
  #my $DB_System=$NDB."_SYSTEM";
  
    if(-e $ProductPath){
	$ProductPath =~ s/\\/\\\\/g;
	chdir "$ProductPath" or die "Cannot chdir to $ProductPath: $!";
       &ModifyFile(\$ProductPath,\$ODB,\$NDB);
      
    }
    else{
	print "Error:Not exists direcotry( $ProductPath).\n";
    }
}


sub ModifyFile($$$)
{

   my ($TargetPath,$oldDB,$newDB)=@_;
   my @Xml=();
   #my $source="\\\\sha-sql2005-c\\QA\\CN\\CNBAK\\Configuration\\UNI.Reg";
   if(defined $$newDB && defined $$oldDB){
		my $newDATA=$$newDB."_DATA";
		my $newSYS=$$newDB."_SYSTEM";
		my $oldDATA=$$oldDB."_DATA";
		my $oldSYS=$$oldDB."_SYSTEM";
       if(-e "$$TargetPath\\UNI.REG"){
    
	open FR,"<$$TargetPath\\UNI.REG" or die "Cannot read $$TargetPath\\UNI.REG:($!)\n";
	
    @Xml=<FR>;
	foreach my $tmp(@Xml)
	{
	   if($tmp=~/$oldDATA/){$tmp="\"Database\"=\"$newDATA\"\n";}
       if($tmp=~/$oldSYS/){$tmp="\"Database\"=\"$newSYS\"\n";}
	   #print $tmp;
	}

	close FR;

   open FW,">$$TargetPath\\UNI.REG" or die "Cannot open $$TargetPath\\UNI.REG:($!)\n";
	seek(FW,0,0);
	print FW @Xml;
	
	close FW;
	close FW;

       }
       else{ print "Error:Not exists UNI under $$TargetPath!\n";}
   }else{
     print "Error: Not defined DataBases!\n";
   }
}