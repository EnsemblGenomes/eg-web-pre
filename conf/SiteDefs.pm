package EG::Pre::SiteDefs;
use strict;


sub update_conf {

    $SiteDefs::ENSEMBL_PORT       = 8009;
    $SiteDefs::ENSEMBL_SERVERNAME = 'pre.ensemblgenomes.org';
    $SiteDefs::SITE_NAME          = 'Ensembl Genomes Pre';
    $SiteDefs::ENSEMBL_BASE_URL   = 'http://pre.ensemblgenomes.org';
    $SiteDefs::SITE_FTP           = 'ftp://ftp.ensemblgenomes.org/pub/pre';

    $SiteDefs::ENSEMBL_DATASETS = [qw(
      Triticum_aestivum
    )];

    $SiteDefs::ENSEMBL_PRIMARY_SPECIES   = 'Triticum_aestivum';
    $SiteDefs::ENSEMBL_SECONDARY_SPECIES = 'Triticum_aestivum';

    # Flag to enable/disable BLAST, VEP, Assembly Converter
    $SiteDefs::ENSEMBL_BLAST_ENABLED  = 1;
    $SiteDefs::ENSEMBL_VEP_ENABLED    = 0;
    $SiteDefs::ENSEMBL_MART_ENABLED   = 0;
    $SiteDefs::ENSEMBL_AC_ENABLED     = 1;
}

1;
