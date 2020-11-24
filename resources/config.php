<?php

unset($CFG);  // Ignore this line
global $CFG;  // This is necessary here for PHPUnit execution
$CFG = new stdClass();

$CFG->dbtype = 'pgsql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'pgdb';
$CFG->dbname    = 'pguser';
$CFG->dbuser    = 'pguser';
$CFG->dbpass    = 'pass';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = [
    'dbpersist' => 0,
    'dbport' => 5432,
    'dbsocket' => ''
];
$CFG->directorypermissions = 0777;
$CFG->wwwroot = '{{WWWROOT}}';
$CFG->dataroot = '/var/www-data/moodle';

$CFG->admin = 'admin';

$CFG->minpasswordlength = 4;
$CFG->minpassworddigits = 0;
$CFG->minpasswordlower = 0;
$CFG->minpasswordupper = 0;
$CFG->minpasswordnonalphanum = 0;

$debug = {{DEBUG}};
if ($debug) {
    // Force a debugging mode regardless the settings in the site administration
    @error_reporting(E_ALL | E_STRICT); // NOT FOR PRODUCTION SERVERS!
    @ini_set('display_errors', '1');    // NOT FOR PRODUCTION SERVERS!
    $CFG->debug = (E_ALL | E_STRICT);   // === DEBUG_DEVELOPER - NOT FOR PRODUCTION SERVERS!
    $CFG->debugdisplay = 1;             // NOT FOR PRODUCTION SERVERS!
    // Show performance data in footer.
    define('MDL_PERF', true);
    define('MDL_PERFDB', true);
    define('MDL_PERFTOLOG', true);
    define('MDL_PERFTOFOOT', true);
}

$CFG->allowthemechangeonurl = true;

require_once(__DIR__ . '/lib/setup.php');
