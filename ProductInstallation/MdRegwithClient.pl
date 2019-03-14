#! /usr/bin/perl 

sub ModifyFile($$$);
sub main();

if($#ARGV==1){
   &main();
}else{
   print "Error: Must contains 2 arguments.Sequence is RegFilePath Client(without _DATA/_SYSTEM).\n";
}

sub main()
{

   my $RegFilePath=shift @ARGV;
   my $DB=shift @ARGV;
   chomp($RegFilePath);
   chomp($DB);
  my $DB_Data=$DB."_DATA";
  my $DB_System=$DB."_SYSTEM";
    if(-e $RegFilePath){
	$RegFilePath =~ s/\\/\\\\/g;
    &ModifyFile(\$RegFilePath,\$DB_Data,\$DB_System);  
    }
    else{
	print "Error:Not exists file ( $RegFilePath).\n";
    }
}


sub ModifyFile($$$)
{

   my ($TargetPath,$Data_pos,$Sys_pos)=@_;
   my @Xml=();
   my $source=$$TargetPath;
   if(defined $$Data_pos && defined $$Sys_pos){

       if(-e "$source"){
    
	open FR,"+<$source" or die "Cannot read $source:($!)\n";
	@Xml=<FR>;
    
	foreach my $tmp(@Xml)
	{
	   if($tmp=~/Database.*?DATA/i){$tmp="\"Database\"=\"$$Data_pos\"\n";}
       if($tmp=~/Database.*?SYSTEM/i){$tmp="\"Database\"=\"$$Sys_pos\"\n";}
	}
open FW,">$$TargetPath" or die "Cannot open $$TargetPath:($!)\n";
	seek(FW,0,0);
	print FW @Xml;
	close FW;
	close FR;
       }
       else{ print "Error:Not exists $source!\n";}
   }else{
     print "Error: Not defined DataBases!\n";
   }
}