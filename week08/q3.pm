package RestrictionEnzyme;

use strict;
use warnings;
=pod
RestrictionEnzyme creates a class with attributes name, manufacturer, 
and recognition sequence. The name and recognition sequence are 
required when creating a new instance of the class object; manufacturer
defaults to "unknown" if not entered. We use AUTOLOAD to automatically
generate accessor and mutator methods (if permission settings permit), 
and there is one class method, cut_dna.
=cut
our $AUTOLOAD;
{
	my %_attrib_props = (
	_name       => [ 'unknown' , 'read.required' ] ,
	_manufacturer   => [ 'unknown' , 'read.write' ] ,
	_recognitionseq => [ 'unknown' , 'read.required'    ] ,
	);
	# keep track of how many objects we've created.
	my $_count = 0;

	sub _all_attributes { return keys %_attrib_props }

	sub _permissions {
	my( $self , $attrib , $perms ) = ( @_ );
	return $_attrib_props{$attrib}[1] =~ /$perms/;
	}

	sub _default_value {
	my( $self , $attrib ) = ( @_ );
	return $_attrib_props{$attrib}[0];
	}

	sub get_count   { return $_count }
	sub _incr_count { $_count++ }
	sub _decr_count { $_count-- }
}

# constructor method
sub new {
	my( $class , %args ) = ( @_ );
	my $self = bless {} , $class;

	foreach my $attrib ( $self->_all_attributes() ) {
		my( $arg ) = $attrib =~ /^_(.*)/;
		if( exists $args{$arg} ) {
	  		$self->{$attrib} = $args{$arg};
		}
		elsif( $self->_permissions( $attrib , 'required' )) {
	  		die( "Required $arg attribute missing." );
		}
		else {
	  		$self->{$attrib} = $self->_default_value($attrib);
		}
	}

	$class->_incr_count();
	return $self;
}

sub AUTOLOAD {
  	my( $self , $new ) = ( @_ );

  	no strict 'refs';

	die "Can't AUTOLOAD $AUTOLOAD" unless
    	my( $op , $attrib ) = $AUTOLOAD =~ /(get|set)(_\w+)$/;

  	die "'$attrib' doesn't exist"
    	unless( exists $self->{$attrib} );

  	if( $op eq 'get' ) {
    	die "no read perms on '$attrib'" unless
      		$self->_permissions( $attrib , 'read' );

	    # munge symbol table
   		*{$AUTOLOAD} = sub {
      		my( $self ) = ( @_ );
      		die "no read perms on '$attrib'" unless
        		$self->_permissions( $attrib , 'read' );
      	return $self->{$attrib};
    	};
  	}

  	elsif( $op eq 'set' ) {
    	die "no write perms on '$attrib'" unless
      		$self->_permissions( $attrib , 'write' );

    	$self->{$attrib} = $new;

    	# munge symbol table
    	*{$AUTOLOAD} = sub {
      		my( $self , $new ) = ( @_ );
      		die "no write perms on '$attrib'" unless
        		$self->_permissions( $attrib , 'write' );
      		return $self->{$attrib} = $new;
    	};
  	}

  	use strict 'refs';

	return $self->{$attrib};
}

# destructor method
sub DESTROY {
  	my( $self ) = ( @_ );
  	$self->_decr_count();
}

=pod
cut_dna takes in a DNA sequence and splits it by the restriction
sequence as specified by the class object self. It returns a 
reference to the array containing the cut pieces of DNA.
=cut
sub cut_dna {
	my ($self, $dnaseq) = ( @_ );
	my $cutsite = $self->get_recognitionseq;
	my $seq = uc $dnaseq;
	my @sites = (split(qr/($cutsite)/, $seq));
	return \@sites;
}
1;