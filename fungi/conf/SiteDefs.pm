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
      Fusarium_graminearum
    )];

    $SiteDefs::ENSEMBL_PRIMARY_SPECIES   = 'Fusarium_culmorum';
    $SiteDefs::ENSEMBL_SECONDARY_SPECIES = 'Fusarium_culmorum';

    # Flag to enable/disable BLAST, VEP, Assembly Converter
    $SiteDefs::ENSEMBL_BLAST_ENABLED  = 0;
    $SiteDefs::ENSEMBL_VEP_ENABLED    = 0;
    $SiteDefs::ENSEMBL_MART_ENABLED   = 0;
    $SiteDefs::ENSEMBL_AC_ENABLED     = 0;

    $SiteDefs::ENSEMBL_LOGDIR  = '/nfs/public/rw/ensembl/shared-storage/ensembl-logs/pre-fungi';
    $SiteDefs::ENSEMBL_TMP_DIR = '/nfs/public/rw/ensembl/shared-storage/ensembl-tmp-dirs/pre-fungi';
}

1;
