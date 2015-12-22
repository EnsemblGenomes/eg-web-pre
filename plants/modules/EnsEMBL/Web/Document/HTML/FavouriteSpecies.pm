=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Document::HTML::FavouriteSpecies;

use strict;

use base qw(EnsEMBL::Web::Document::HTML);

## PRE - only show short summary of species

sub render_species_list {
  my ($self, $fragment) = @_;
  my $hub           = $self->hub;
  my $logins        = $hub->users_available;
  my $user          = $hub->user;
  my $species_info  = $hub->get_species_info;
  
  my (%check_faves, @ok_faves);
  
  foreach (@{$hub->get_favourite_species}) {
    push @ok_faves, $species_info->{$_} unless $check_faves{$_}++;
  }
  
  my $fav_html = $self->render_with_images(@ok_faves);
  
  return $fav_html if $fragment;
  
  # output list
  my $star = '<img src="/i/16/star.png" style="vertical-align:middle;margin-right:4px" />';
  my $html = qq{<div class="static_favourite_species"><h3>Genomes</h3><div class="species_list_container species-list">$fav_html</div></div>};

  return $html;
}

1;
