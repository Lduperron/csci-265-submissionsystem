 # In Perl there is no special 'class' definition.  A namespace is a class.
  package Passmod;

  my $moduledirectory;

BEGIN  # Finds the position of the module.
{      # Assumes that Session-Token-0.82 is in the same folder.
   use File::Basename;
   
   foreach $include (keys %INC)
   {
      if ($include =~ m/Passmod.pm/)
      {
         $fpath = $INC{$include};
         
         $moduledirectory = dirname($fpath);
         
      }
   }
}

  
  use lib "$moduledirectory";
  use lib "$moduledirectory/Session-Token-0.82/lib";
  use lib "$moduledirectory/Session-Token-0.82/blib/arch";
  
  use Session::Token;
  use strict;
  use warnings;
  
  use constant PATH => "../students/";
  use Tie::File;
  
  my $StudentsPath = $moduledirectory."/../../students/";
   
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
     
      if(!-d $StudentsPath)  # Makes sure the directory of where our passwords are going to be is valid
      { 
         return 0;
         #system("mkdir ".$StudentsPath);
      }
      else
      {
         system("touch ".$StudentsPath."testfile");
         
         if(!-e $StudentsPath."testfile")
         {
            die("No write access to students folder!");
         }
         else
         {
            system("rm -f ".$StudentsPath."testfile");
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
        
      if(!-d $StudentsPath)  # Makes sure the directory of where our passwords are going to be is valid
      { 
         return 0;
         #system("mkdir ".$StudentsPath.$target);
      }
      
      open($passfile , ">".$StudentsPath."$target"."passwordSheet.txt");
      
      for(my $i = 0; $i < $self->{number}; $i++)
      {
         print $passfile $self->{Passgen}->get;
         print $passfile "\n";
      }
      close $passfile;
      
      if($self->{carboncopy})
      {
         if(!-d $StudentsPath."Passwords/")  # Makes sure the directory of where our passwords are going to be is valid
         { 
            system("mkdir ".$StudentsPath."Passwords/");
         }
         
         my $originalpath = $StudentsPath."$target"."passwordSheet.txt";
         my $copypath = $StudentsPath."Passwords/$target"."passwordSheet.txt";
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
   
   if(-e $StudentsPath."$name"."passwordSheet.txt")
   {
   
      tie @temparray, 'Tie::File', $StudentsPath."$name"."passwordSheet.txt" or die;
      
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

