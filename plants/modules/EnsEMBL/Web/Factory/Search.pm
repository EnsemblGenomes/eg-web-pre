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

## PRE - also search seq region synonyms
sub search_SEQUENCE {
  my $self = shift;
  my $dbh = $self->database('core');
  return unless $dbh;  
  
  my $species = $self->species;
  my $species_path = $self->species_path;
  
  $self->_fetch_results( 
    [ 'core', 'Sequence',
## PRE    
      "select count(*) from seq_region sr left join seq_region_synonym srs using (seq_region_id) where sr.name [[COMP]] '[[KEY]] or srs.synonym [[COMP]] '[[KEY]]' group by sr.name",
      "select sr.name, cs.name, 1, length, sr.seq_region_id from seq_region as sr left join seq_region_synonym srs using (seq_region_id), coord_system as cs where cs.coord_system_id = sr.coord_system_id and sr.name [[COMP]] '[[KEY]]' or srs.synonym [[COMP]] '[[KEY]]' group by sr.name" ],
##
    [ 'core', 'Sequence',
      "select count(distinct misc_feature_id) from misc_attrib join attrib_type as at using(attrib_type_id) where at.code in ( 'name','clone_name','embl_acc','synonym','sanger_project') 
       and value [[COMP]] '[[KEY]]'", # Eagle change, added at.code in count so that it matches the number of results in the actual search query below. 
      "select ma.value, group_concat( distinct ms.name ), seq_region_start, seq_region_end, seq_region_id
         from misc_set as ms, misc_feature_misc_set as mfms,
              misc_feature as mf, misc_attrib as ma, 
              attrib_type as at,
              (
                select distinct ma2.misc_feature_id
                  from misc_attrib as ma2, attrib_type as at2
                 where ma2.attrib_type_id = at2.attrib_type_id and
                       at2.code in ('name','clone_name','embl_acc','synonym','sanger_project') and
                       ma2.value [[COMP]] '[[KEY]]'
              ) as tt
        where ma.misc_feature_id   = mf.misc_feature_id and 
              mfms.misc_feature_id = mf.misc_feature_id and
              mfms.misc_set_id     = ms.misc_set_id     and
              ma.misc_feature_id   = tt.misc_feature_id and
              ma.attrib_type_id    = at.attrib_type_id  and
              at.code in ('name','clone_name','embl_acc','synonym','sanger_project')
        group by mf.misc_feature_id" ]
  );


  my $sa = $dbh->get_SliceAdaptor(); 

  foreach ( @{$self->{_results}} ) {
    my $KEY =  $_->[2] < 1e6 ? 'contigview' : 'cytoview';
    $KEY = 'cytoview' if $self->species_defs->NO_SEQUENCE;
    # The new link format is usually 'r=chr_name:start-end'
    my $slice = $sa->fetch_by_seq_region_id($_->[4], $_->[2], $_->[3] ); 

    $_ = {
#      'URL'       => (lc($_->[1]) eq 'chromosome' && length($_->[0])<10) ? "$species_path/mapview?chr=$_->[0]" :
#                        "$species_path/$KEY?$_->[3]=$_->[0]" ,
      'URL'       => "$species_path/Location/View?r=" . $slice->seq_region_name . ":" . $slice->start . "-" . $slice->end,   # v58 format
      'URL_extra' => [ 'Region overview', 'View region overview', "$species_path/Location/Overview?r=" . $slice->seq_region_name . ":" . $slice->start . "-" . $slice->end ],
      'idx'       => 'Sequence',
      'subtype'   => ucfirst( $_->[1] ),
      'ID'        => $_->[0],
      'desc'      => '',
      'species'   => $species
    };
  }
  $self->{'results'}{ 'Sequence' }  = [ $self->{_results}, $self->{_result_count} ]
}

1;
