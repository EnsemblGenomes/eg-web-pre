package EG::Pre::Fungi::SiteDefs;
use strict;


sub update_conf {

    $SiteDefs::ENSEMBL_PORT       =  8112;
    $SiteDefs::ENSEMBL_SERVERNAME = 'pre.fungi.ensembl.org';
    $SiteDefs::SITE_NAME          = 'Ensembl Fungi Pre';
    $SiteDefs::ENSEMBL_SITETYPE   = 'Ensembl Fungi Pre';
    $SiteDefs::ENSEMBL_BASE_URL   = 'http://pre.fungi.ensembl.org';
    $SiteDefs::SITE_FTP           = 'ftp://ftp.ensemblgenomes.org/pub/fungi/pre';

    $SiteDefs::ENSEMBL_DATASETS = [qw(
      Fusarium_culmorum 
    )];

    $SiteDefs::ENSEMBL_PRIMARY_SPECIES   = 'Fusarium_culmorum';
    $SiteDefs::ENSEMBL_SECONDARY_SPECIES = 'Fusarium_culmorum';

    # Flag to enable/disable BLAST, VEP, Assembly Converter
    $SiteDefs::ENSEMBL_BLAST_ENABLED  = 0;
    $SiteDefs::ENSEMBL_VEP_ENABLED    = 0;
    $SiteDefs::ENSEMBL_MART_ENABLED   = 0;
    $SiteDefs::ENSEMBL_AC_ENABLED     = 0;
}

1;
