@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#! /usr/bin/perl 
#line 15

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
   my $source="\\\\sha-sql2005-c\\QA\\CN\\CNBAK\\Configuration\\UNI.Reg";
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
__END__
:endofperl
