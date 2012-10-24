 # In Perl there is no special 'class' definition.  A namespace is a class.
  package Passmod;
 
  $| = 1;
 
  use Session::Token;
  use strict;
  use warnings;
  
  
  use constant PATH => "../Students/";
  use Tie::File;
  
 
  our $VERSION = "1.00";

  sub new
  {
      my($class) = @_; # Primes Class and Arguments to passed parameters.
    
      my $self = bless({}, $class);  # Blesses self

      $self->{type} = "num";
      $self->{length} = 8;
      $self->{number} = 20;
      $self->{carboncopy} = 1;
      
      $self->reinitializeGenerator();
     
      if(!-d PATH)  # Makes sure the directory of where our passwords are going to be is valid
      { 
         system("mkdir ".PATH);
      }
      else
      {
         system("touch ".PATH."testfile");
         
         if(!-e PATH."testfile")
         {
            die("No write access to students folder!");
         }
         else
         {
            system("rm -f ".PATH."testfile");
         }
      }

      
      return $self;

  }
 
  sub generate 
  {
    my $self = shift;
    my $target = 0;
    my $passfile;

    if( @_ ) 
    {
        $target = shift;
        
      if(!-d PATH.$target)  # Makes sure the directory of where our passwords are going to be is valid
      { 
         system("mkdir ".PATH.$target);
      }
      
      open($passfile , ">".PATH."$target/$target"."passwordSheet.txt");
      
      for(my $i = 0; $i < $self->{number}; $i++)
      {
         print $passfile $self->{Passgen}->get;
         print $passfile "\n";
      }
      close $passfile;
      
      if($self->{carboncopy})
      {
         if(!-d PATH."Passwords/")  # Makes sure the directory of where our passwords are going to be is valid
         { 
            system("mkdir ".PATH."Passwords/");
         }
         
         my $originalpath = PATH."$target/$target"."passwordSheet.txt";
         my $copypath = PATH."Passwords/$target"."passwordSheet.txt";
         system("cp $originalpath $copypath");
         
      }
        
     return 1;
     
     
    }
      
    else
    {
      return 0;
    }

  }
 
 
 
  sub verify 
  {
   my $self = shift;
   my $name = shift;
   my $givenpass = shift;
   my $passfile;
   my $realpass;
   my @temparray;
   
   if(-e PATH."$name/$name"."passwordSheet.txt")
   {
   
      tie @temparray, 'Tie::File', PATH."$name/$name"."passwordSheet.txt" or die;
      
      $realpass = $temparray[0];
      
      if($realpass eq $givenpass)
      {
         shift @temparray;
         untie @temparray;
         return 1;
      }
      
   }
   
   return 0;
  }
 
 
  sub printSettings 
  {
    my $self = shift;
 
    printf "Current Password Type: %s \n" , ($self->{type} eq "num") ? "Numeric Only" : "Alphanumeric";
    printf "Current Password Length: %s \n " , $self->{length};
    print "Current Number of Passwords per File: %s \n" , $self->{number};
 
  }
 
  sub getSetting
  {
      my $self = shift;
      
      if( @_ ) 
      {
      
         my $setting = shift;
         
         if($setting eq "length")
         {
            return $self->{length}
         }
         
         if($setting eq "type")
         {
            return $self->{type}
         }
         
         if($setting eq "number")
         {
            return $self->{number}
         }
         
         if($setting eq "carboncopy")
         {
            return $self->{carboncopy}
         }
      
      }
  }
  
  
  sub setSetting
  {
      my $self = shift;
      
      if( @_ ) 
      {
      
         my $setting = shift;
         my $newValue = shift;
         
         if($setting eq "length")
         {
            $self->{length} = $newValue;
            $self->reinitializeGenerator();
         }
         
         if($setting eq "type")
         {
            $self->{type} = $newValue;
            $self->reinitializeGenerator();
         }
         
         if($setting eq "number")
         {
            $self->{number} = $newValue;
         }
         
                  
         if($setting eq "carboncopy")
         {
            $self->{carboncopy} = $newValue;
         }
      
      }
  }
  
  sub reinitializeGenerator
  {
      my $self = shift;
      
      if($self->{type} eq "num")
      {
         $self->{Passgen} = Session::Token->new(alphabet => ['0'..'9'] , length => $self->{length});
      }
      else
      {
         $self->{Passgen} = Session::Token->new(length => $self->{length});
      }
      
      
      
  }
 
 
  1;

