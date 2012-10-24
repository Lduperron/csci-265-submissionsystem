use Passmod;
   
   my $pass;
   
   my $path = "../Students/"."dude/dude"."passwordSheet.txt";

   my $hello = Passmod->new;
   
   $hello->setSetting("length", 5);
   
   $hello->generate(test);
   
   $hello->setSetting("type", "alnum");
   
   $hello->generate(dude);

   open(my $passfile , $path) or die;
   
   $pass = <$passfile>;

   chomp($pass);
   
   close ($passfile);
   
   if($hello->verify(dude, $pass))
   {
      print "Password verification successful.  \n";
   }
   
   if(!$hello->verify(dude, $pass))
   {
      print "Retrying verification with same password failed.  (expected) \n";
   }