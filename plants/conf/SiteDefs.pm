package EG::Pre::Plants::SiteDefs;
use strict;


sub update_conf {

    $SiteDefs::ENSEMBL_PORT       = 8110;
    $SiteDefs::ENSEMBL_SERVERNAME = 'pre.plants.ensembl.org';
    $SiteDefs::SITE_NAME          = 'Ensembl Plants Pre';
    $SiteDefs::ENSEMBL_SITETYPE          = 'Ensembl Plants Pre';
    $SiteDefs::ENSEMBL_BASE_URL   = 'http://pre.plants.ensembl.org';
    $SiteDefs::SITE_FTP           = 'ftp://ftp.ensemblgenomes.org/pub/plants/pre';

    $SiteDefs::ENSEMBL_DATASETS = [qw(
      Triticum_aestivum
      Hordeum_vulgare
    )];

    $SiteDefs::ENSEMBL_PRIMARY_SPECIES   = 'Triticum_aestivum';
    $SiteDefs::ENSEMBL_SECONDARY_SPECIES = 'Triticum_aestivum';

    # Flag to enable/disable BLAST, VEP, Assembly Converter
    $SiteDefs::ENSEMBL_BLAST_ENABLED  = 0;
    $SiteDefs::ENSEMBL_VEP_ENABLED    = 0;
    $SiteDefs::ENSEMBL_MART_ENABLED   = 0;
    $SiteDefs::ENSEMBL_AC_ENABLED     = 0;
}

1;
