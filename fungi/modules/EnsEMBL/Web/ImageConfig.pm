=head1 LICENSE

Copyright [2009-2014] EMBL-European Bioinformatics Institute

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

package EnsEMBL::Web::ImageConfig;

use strict;

sub _add_file_format_track {
  my ($self, %args) = @_;
  my $menu = $args{'menu'} || $self->get_node('user_data');

  return unless $menu;

  %args = $self->_add_trackhub_extras_options(%args) if $args{'source'}{'trackhub'};

  my $type    = lc $args{'format'};
  my $article = $args{'format'} =~ /^[aeiou]/ ? 'an' : 'a';
  my ($desc, $url);

  if ($args{'internal'}) {
    $desc = $args{'description'};
    $url = join '/', $self->hub->species_defs->DATAFILE_BASE_PATH, lc $self->hub->species, $self->hub->species_defs->ASSEMBLY_VERSION, $args{'source'}{'dir'}, $args{'source'}{'file'};
    $args{'options'}{'external'} = undef;
  } else {
    if ($args{'source'}{'source_type'} =~ /^session|user$/i) {
      $desc = sprintf(
        'Data retrieved from %s %s file on an external webserver. %s <p>This data is attached to the %s, and comes from URL: <a href="%s">%s</a></p>',
        $article,
        $args{'format'},
        $args{'description'},
        encode_entities($args{'source'}{'source_type'}),,
        encode_entities($args{'source'}{'source_url'}),
        encode_entities($args{'source'}{'source_url'})
      );
    } else {
      $desc = $args{'description'};
    }
  }
 
  $self->generic_add($menu, undef, $args{'key'}, {}, {
    display     => 'off',
    strand      => 'f',
    format      => $args{'format'},
    glyphset    => $type,
    colourset   => $type,
    renderers   => $args{'renderers'},
    name        => $args{'source'}{'source_name'},
    caption     => exists($args{'source'}{'caption'}) ? $args{'source'}{'caption'} : $args{'source'}{'source_name'},
    labelcaption => $args{'source'}{'labelcaption'},
    section     => $args{'source'}{'section'},
    url         => $url || $args{'source'}{'source_url'},
    description => $desc,
    %{$args{'options'}}
  });
}

1;
