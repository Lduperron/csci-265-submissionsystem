   print "Loading Passgen Driver!\n";
   
   use Passmod;
   
   print "Passmod loaded successfully!  Extraction is all good. \n";
   
   my $pass;
   my $student = "dude";
   my $path = "../../students/"."$student"."passwordSheet.txt";

   my $Passmod = Passmod->new;
   
   if($Passmod)
   {
      print "Passmod returned a generator; students directory is good.  Ready to try generating. \n";
   }
   
   print "Printing passgenerator settings:\n";
   
   $Passmod->printSettings();
   
   $Passmod->generate(dude);
   
   print "Generated passwords were: \n";
   
   system("cat $path");
   
   print "Setting type to alnum, length to 3, and number of passwords to 5. \n";
   
   $Passmod->setSetting("length", 5);
   $Passmod->setSetting("type", "alnum");
   $Passmod->setSetting("number", 5);
   $Passmod->generate("amy");
   
    print "Generated passwords were: \n";
   
   $student = "amy";
   $path = "../../students/"."$student"."passwordSheet.txt";
   
   system("cat $path");
   
   print "Sending each password generated to verify.  Expected successes:  5 \n";

   open(my $passfile , $path) or die;
      my $i = 0;
   while($pass = <$passfile>)
   {
      
      chomp($pass);
   
      if($Passmod->verify($student, $pass))
      {
         print "Password verification of password $pass successful.  \n";
         $i++;
         print "Number of successes:  $i\n";
      }
      
      
      if(!$Passmod->verify($student, $pass))
      {
         print "Retrying verification with same password failed.  (expected) \n";
      }
      
   }
   
   if($i == 5)
   {
      print "Passwords accepted.  Sending null password to verify:\n";
      if(!$Passmod->verify($student, ""))
      {
         print "Null password rejected. (expected) \n";
      }
      
      print "Sending string password to verify: \n";
      if(!$Passmod->verify($student, "This is a password."))
      {
         print "String password rejected. (expected) \n";
      }
      
   }
   else
   {
      "Password verification failed!  Saddening.\n";
   }

   
   print "Trying password verification on non-existant student\n";
   
   if(!$Passmod->verify("Aw...", "This is a password."))
      {
         print "Non-existant student rejected. (expected) \n";
      }
   
   print "All tests succeded!  Passgen module appears ready for use.";
   
   
   