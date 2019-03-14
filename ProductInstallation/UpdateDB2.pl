#! /usr/bin/perl 

sub ModifyFile($$$);
sub main();

if($#ARGV==1){
   &main();
}else{
   print "Error: Must contains 2 arguments.Sequence is ProductPath DataBase.\n";
}

sub main()
{

   my $ProductPath=shift @ARGV;
   my $DB=shift @ARGV;
   chomp($ProductPath);
   chomp($DB);
  $ProductPath=$ProductPath."\\Configuration";
  my $DB_Data=$DB."_DATA";
  my $DB_System=$DB."_SYSTEM";
    if(-e $ProductPath){
	$ProductPath =~ s/\\/\\\\/g;
	chdir "$ProductPath" or die "Cannot chdir to $ProductPath: $!";
       &ModifyFile(\$ProductPath,\$DB_Data,\$DB_System);
      
    }
    else{
	print "Error:Not exists direcotry( $ProductPath).\n";
    }
}


sub ModifyFile($$$)
{

   my ($TargetPath,$Data_pos,$Sys_pos)=@_;
   my @Xml=();
   my $source=$$TargetPath;
   if(defined $$Data_pos && defined $$Sys_pos){

       if(-e "$source"){
    
	open FR,"<$source" or die "Cannot read $source:($!)\n";
	@Xml=<FR>;

	foreach my $tmp(@Xml)
	{
	   if($tmp=~/DB1/){$tmp="\"Database\"=\"$$Data_pos\"\n";}
       if($tmp=~/DB2/){$tmp="\"Database\"=\"$$Sys_pos\"\n";}
	}
open FW,">$$TargetPath\\UNI.REG" or die "Cannot open $$TargetPath\\UNI.REG:($!)\n";
	seek(FW,0,0);
	print FW @Xml;
	close FW;
	close FR;
       }
       else{ print "Error:Not exists UNI under $$TargetPath!\n";}
   }else{
     print "Error: Not defined DataBases!\n";
   }
}