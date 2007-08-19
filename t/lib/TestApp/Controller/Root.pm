#!perl

package TestApp::Controller::Root;
use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config(namespace => '');

sub test :Local {
    my ($self, $c) = @_;
    $c->stash->{world} = 'Universe';
}

sub world :Local {
    my ($self, $c) = @_;
    $c->view->template('test.cs');
    $c->stash->{world} = 'world';
}

sub hdf :Local {
    my ($self, $c) = @_;
    $c->view->template('hdf.cs');
}

sub nest :Local {
    my ($self, $c) = @_;
    $c->view->template('nest.cs');
    $c->stash->{data} = 
      { foo   => bless({ bar => [qw/baz quux/] }),
        hello => \'world',
      };
}

sub end :Private {
    my ($self, $c, @args) = @_;
    $c->detach($c->view('ClearSilver'));
}

1;

