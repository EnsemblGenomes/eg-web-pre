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

# $Id: HomePage.pm,v 1.69 2014-01-17 16:02:23 jk10 Exp $

package EnsEMBL::Web::Component::Info::HomePage;

use strict;

use previous qw(content);

## PRE - most changes here relate to fixing up the FTP urls, or disabling VEP links


#Do we still need this method now that _assembly_text and _genebuild_text methods are overwritten here and that only those methods have links to FTP site 
sub content {
  my $self = shift;
  my $html = $self->PREV::content(@_);
  return $html =~ s/\/release-pre\//\/pre\//gmr; #/
}

sub _site_release {
  my $self = shift;
  return 'pre';
}


sub _assembly_text {
  my $self             = shift;
  my $hub              = $self->hub;
  my $species_defs     = $hub->species_defs;
  my $species          = $hub->species;
  my $name             = $species_defs->SPECIES_COMMON_NAME;
  my $img_url          = $self->img_url;
  my $sample_data      = $species_defs->SAMPLE_DATA;
  my $ensembl_version  = $self->_site_release;
  my $current_assembly = $species_defs->ASSEMBLY_NAME;
  my $accession        = $species_defs->ASSEMBLY_ACCESSION;
  my $source           = $species_defs->ASSEMBLY_ACCESSION_SOURCE || 'NCBI';
  my $source_type      = $species_defs->ASSEMBLY_ACCESSION_TYPE;
 #my %archive          = %{$species_defs->get_config($species, 'ENSEMBL_ARCHIVES') || {}};
  my %assemblies       = %{$species_defs->get_config($species, 'ASSEMBLIES') || {}};
  my $previous         = $current_assembly;

  my $html = '<div class="homepage-icon">';

  if (@{$species_defs->ENSEMBL_CHROMOSOMES || []}) {
    $html .= qq(<a class="nodeco _ht" href="/$species/Location/Genome" title="Go to $name karyotype"><img src="${img_url}96/karyotype.png" class="bordered" /><span>View karyotype</span></a>);
  }

  my $region_text = $sample_data->{'LOCATION_TEXT'};
  my $region_url  = $species_defs->species_path . '/Location/View?r=' . $sample_data->{'LOCATION_PARAM'};

  $html .= qq(<a class="nodeco _ht" href="$region_url" title="Go to $region_text"><img src="${img_url}96/region.png" class="bordered" /><span>Example region</span></a>);
  $html .= '</div>'; #homepage-icon

  if ($sample_data->{POLYPLOID_REGION}) { 
    my $url  = $species_defs->species_path . '/Location/MultiPolyploid?r=' . $sample_data->{'POLYPLOID_REGION'};
    $html .= qq(
      <div class="homepage-icon" style="padding-top:97px;">
        <a class="nodeco _ht" href="$url" title="Go to $sample_data->{POLYPLOID_REGION}"><img src="${img_url}96/region_polyploid.png" class="bordered" /><span>Polyploid example</span></a>
      </div>
    );
  }

  my $assembly = $current_assembly;
  if ($accession) {
    $assembly = $hub->get_ExtURL_link($current_assembly, 'ENA', $accession);
  }
  $html .= "<h2>Genome assembly: $assembly</h2>";
  $html .= qq(<p><a href="/$species/Info/Annotation/#assembly" class="nodeco"><img src="${img_url}24/info.png" alt="" class="homepage-link" />More information and statistics</a></p>);

  # Link to FTP site
  if ($species_defs->ENSEMBL_FTP_URL) {
    my $ftp_url;
    if ($species_defs->SPECIES_DATASET ne $species) {
      $ftp_url = sprintf '%s/release-%s/fasta/%s_collection/%s/dna/', $species_defs->ENSEMBL_FTP_URL, $ensembl_version, lc $species_defs->SPECIES_DATASET, lc $species;
    }
    else {
      $ftp_url = sprintf '%s/release-%s/fasta/%s/dna/', $species_defs->ENSEMBL_FTP_URL, $ensembl_version, lc $species;
    }
##
#PRE - No FTP download links on species page
##
  #  $html .= qq(<p><a href="$ftp_url" class="nodeco"><img src="${img_url}24/download.png" alt="" class="homepage-link" />Download DNA sequence</a> (FASTA)</p>);
  }

  # Link to assembly mapper
  if ($species_defs->ENSEMBL_AC_ENABLED and $species_defs->ASSEMBLY_CONVERTER_FILES) {
    $html .= sprintf('<a href="%s" class="nodeco"><img src="%s24/tool.png" class="homepage-link" />Convert your data to %s coordinates</a></p>', $hub->url({'type' => 'Tools', 'action' => 'AssemblyConverter'}), $img_url, $current_assembly);
  }
  
  $html .= sprintf '<p><a href="%s" class="modal_link nodeco" rel="modal_user_data">%sDisplay your data in %s</a></p>',
    $hub->url({ type => 'UserData', action => 'SelectFile', __clear => 1 }), qq|<img src="${img_url}24/page-user.png" class="homepage-link" />|, $species_defs->ENSEMBL_SITETYPE;

  return $html;
}





sub _variation_text {
  my $self         = shift;
  my $hub          = $self->hub;
  my $species_defs = $hub->species_defs;
  my $species      = $hub->species;
  my $img_url      = $self->img_url;
  my $sample_data  = $species_defs->SAMPLE_DATA;
  my $ensembl_version = $self->_site_release;
  my $display_name    = $species_defs->SPECIES_SCIENTIFIC_NAME;
  my $html;

  if ($hub->database('variation')) {
    $html .= '<div class="homepage-icon">';

    if ($sample_data->{'VARIATION_PARAM'}) {
      my $var_url  = $species_defs->species_path . '/Variation/Explore?v=' . $sample_data->{'VARIATION_PARAM'};
      my $var_text = $sample_data->{'VARIATION_TEXT'};
      $html .= qq(
        <a class="nodeco _ht" href="$var_url" title="Go to variant $var_text"><img src="${img_url}96/variation.png" class="bordered" /><span>Example variant</span></a>
      );
    }

    if ($sample_data->{'PHENOTYPE_PARAM'}) {
      my $phen_text = $sample_data->{'PHENOTYPE_TEXT'};
      my $phen_url  = $species_defs->species_path . '/Phenotype/Locations?ph=' . $sample_data->{'PHENOTYPE_PARAM'};
      $html .= qq(<a class="nodeco _ht" href="$phen_url" title="Go to phenotype $phen_text"><img src="${img_url}96/phenotype.png" class="bordered" /><span>Example phenotype</span></a>);
    }

    if ($sample_data->{'STRUCTURAL_PARAM'}) {
      my $struct_text = $sample_data->{'STRUCTURAL_TEXT'};
      my $struct_url = $species_defs->species_path .'/StructuralVariation/Explore?sv='.$sample_data->{'STRUCTURAL_PARAM'};
      $html .= qq(<a class="nodeco _ht"  href="$struct_url" title="Go to structural variant $struct_text"><img src="${img_url}96/struct_var.png" class="bordered" /><span>Example structural variant</span></a>);
    }

    $html .= '</div>';
    $html .= '<h2>Variation</h2><p><strong>What can I find?</strong> Short sequence variants';
    if ($species_defs->databases->{'DATABASE_VARIATION'}{'STRUCTURAL_VARIANT_COUNT'}) {
      $html .= ' and longer structural variants';
    }
    if ($sample_data->{'PHENOTYPE_PARAM'}) {
      $html .= '; disease and other phenotypes';
    }
    $html .= '.</p>';

    if ($self->_other_text('variation', $species)) {
      $html .= qq(<p><a href="/$species/Info/Annotation#variation" class="nodeco"><img src="${img_url}24/info.png" alt="" class="homepage-link" />More about variation in $display_name</a></p>);
    }

    my $site = $species_defs->ENSEMBL_SITETYPE;
    $html .= qq(<p><a href="http://ensemblgenomes.org/info/data/variation" class="nodeco"><img src="${img_url}24/info.png" alt="" class="homepage-link" />More about variation in $site</a></p>);

    if ($species_defs->ENSEMBL_FTP_URL) {
      my @links;
      foreach my $format (qw/gvf vcf/){
        push(@links, sprintf('<a href="%s/release-%s/%s/%s/" class="nodeco _ht" title="Download (via FTP) all <em>%s</em> variants in %s format">%s</a>', $species_defs->ENSEMBL_FTP_URL, $ensembl_version, $format, lc $species, $display_name, uc $format,uc $format));
      }
#      push(@links, sprintf('<a href="%s/release-%s/vep/%s_vep_%s_%s.tar.gz" class="nodeco _ht" title="Download (via FTP) all <em>%s</em> variants in VEP format">VEP</a>', $species_defs->ENSEMBL_FTP_URL, $ensembl_version, lc $species, $ensembl_version, $species_defs->ASSEMBLY_NAME, $display_name));
      my $links = join(" - ", @links);
      $html .= qq[<p><img src="${img_url}24/download.png" alt="" class="homepage-link" />Download all variants - $links</p>];
    }
  }
  else {
#    $html .= '<h2>Variation</h2><p>This species currently has no variation database. However you can process your own variants using the Variant Effect Predictor:</p>';
  }

## hide VEP
  # my $new_vep = $species_defs->ENSEMBL_VEP_ENABLED;
  # $html .= sprintf(
  #   qq(<p><a href="%s" class="%snodeco">$self->{'icon'}Variant Effect Predictor<img src="%svep_logo_sm.png" style="vertical-align:top;margin-left:12px" /></a></p>),
  #   $hub->url({'__clear' => 1, $new_vep ? qw(type Tools action VEP) : qw(type UserData action UploadVariations)}),
  #   $new_vep ? '' : 'modal_link ',
  #   $self->img_url
  # );
##

  return $html;
}

sub _genebuild_text {
  my $self            = shift;
  my $hub             = $self->hub;
  my $species_defs    = $hub->species_defs;
  my $species         = $hub->species;
  my $img_url         = $self->img_url;
  my $sample_data     = $species_defs->SAMPLE_DATA;
  my $ensembl_version = $self->_site_release;
  my $vega            = $species_defs->get_config('MULTI', 'ENSEMBL_VEGA');
  my $has_vega        = $vega->{$species};

  my $html = '<div class="homepage-icon">';

  my $gene_text = $sample_data->{'GENE_TEXT'};
  my $gene_url  = $species_defs->species_path . '/Gene/Summary?g=' . $sample_data->{'GENE_PARAM'};
  $html .= qq(<a class="nodeco _ht" href="$gene_url" title="Go to gene $gene_text"><img src="${img_url}96/gene.png" class="bordered" /><span>Example gene</span></a>);

  my $trans_text = $sample_data->{'TRANSCRIPT_TEXT'};
  my $trans_url  = $species_defs->species_path . '/Transcript/Summary?t=' . $sample_data->{'TRANSCRIPT_PARAM'};
  $html .= qq(<a class="nodeco _ht" href="$trans_url" title="Go to transcript $trans_text"><img src="${img_url}96/transcript.png" class="bordered" /><span>Example transcript</span></a>);

  $html .= '</div>'; #homepage-icon

  $html .= '<h2>Gene annotation</h2><p><strong>What can I find?</strong> Protein-coding and non-coding genes, splice variants, cDNA and protein sequences, non-coding RNAs.</p>';
  $html .= qq(<p><a href="/$species/Info/Annotation/#genebuild" class="nodeco"><img src="${img_url}24/info.png" alt="" class="homepage-link" />More about this genebuild</a></p>);

  if ($species_defs->ENSEMBL_FTP_URL) {
    my $dataset = $species_defs->SPECIES_DATASET;
    my $fasta_url = $hub->get_ExtURL('SPECIES_FTP_URL',{GENOMIC_UNIT=>$species_defs->GENOMIC_UNIT,VERSION=>$ensembl_version, FORMAT=>'fasta', SPECIES=> ($dataset ne $species) ? lc($dataset) . "_collection/" . lc $species : lc $species},{class=>'nodeco'});
    my $gff3_url  = $hub->get_ExtURL('SPECIES_FTP_URL',{GENOMIC_UNIT=>$species_defs->GENOMIC_UNIT,VERSION=>$ensembl_version, FORMAT=>'gff3', SPECIES=> ($dataset ne $species) ? lc($dataset) . "_collection/" . lc $species : lc $species},{class=>'nodeco'});
##
#PRE - No FTP download links on species page
##
#    $html .= qq[<p><img src="${img_url}24/download.png" alt="" class="homepage-link" />Download genes, cDNAs, ncRNA, proteins - <span class="center"><a href="$fasta_url" class="nodeco">FASTA</a><!-- - <a href="$gff3_url" class="nodeco">GFF3</a>--></span></p>];
  }

## PRE - no id mapper 
#  my $im_url = $hub->url({'type' => 'UserData', 'action' => 'UploadStableIDs'});
#  $html .= qq(<p><a href="$im_url" class="modal_link nodeco"><img src="${img_url}24/tool.png" class="homepage-link" />Update your old Ensembl IDs</a></p>);
##

  if ($has_vega) {
    $html .= qq(
      <a href="http://vega.sanger.ac.uk/$species/" class="nodeco">
      <img src="/img/vega_small.gif" alt="Vega logo" style="float:left;margin-right:8px;width:83px;height:30px;vertical-align:center" title="Vega - Vertebrate Genome Annotation database" /></a>
      <p>
        Additional manual annotation can be found in <a href="http://vega.sanger.ac.uk/$species/" class="nodeco">Vega</a>
      </p>
    );
  }

  return $html;
}


1;
