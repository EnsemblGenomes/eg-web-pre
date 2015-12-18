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

package EnsEMBL::Web::Factory::Search;
use strict;

## PRE - force all terms to be wildcarded (e.g. Traes_2DS_875B9CA1A => Traes_2DS_875B9CA1A*)
sub terms {
  my $self = shift;
  my @list = ();
  my @qs = $self->param('q');
  my @clean_kws;

  ## deal with quotes and multiple keywords
  foreach my $q (@qs) {
    $q =~ s/\*+/%/g; ## PRE
    ## pull out terms with quotes around them (and drop the quotes whilst we're at it)
    my @quoted = $q =~ /['"]([^'"]+)['"]/g;
    $q =~ s/(['"][^'"]+['"])//g;
    push @clean_kws, @quoted;
    ## split remaining terms on whitespace
    $q =~ s/^\s|\s$//;
    push @clean_kws, split /\s+/, $q;
  }

  ## create SQL criteria
  foreach my $kw ( @clean_kws ) {
    $kw .= '%' unless $kw =~ /%$/; ## PRE
    my $seq = $kw =~ /%/ ? 'like' : '=';
    push @list, [ $seq, $kw ];
  }

  return @list;
}

1;
