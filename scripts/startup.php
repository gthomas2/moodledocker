<?php

$srcfilename = '/tmp/config.php';
$filename = '/var/www/moodle/config.php';
$dirroot = dirname($filename);
$contents = file_get_contents($srcfilename);
$envvars = [
    'WWWROOT',
    'DEBUG'
];
foreach ($envvars as $envvar) {
    $value = getenv($envvar);
    $contents = str_replace('{{'.$envvar.'}}', $value, $contents);
}

file_put_contents($filename, $contents);

$retval = null;
exec('/usr/bin/php '.$dirroot.'/admin/cli/check_database_schema.php', $output, $retval);

$envvardefaults = [
    'SITEFULLNAME' => 'Moodle test',
    'SITESHORTNAME' => 'Moodle test',
    'ADMINPASS' => 'pass'
];
$envvals = [];
foreach ($envvardefaults as $envvar => $default) {
    $envvals[$envvar] = getenv($envvar) ? getenv($envvar) : $default;
}

$sitename = getenv('SITEFULLNAME') ? getenv('SITEFULLNAME') "Moodle test";
$sitenameshort = getenv('SITESHORTNAME') || "Moodle test";
$adminpass = getenv('ADMINPASS') || "pass";

if ($retval !== 0) {
    $cmd = <<<EXEC
    /usr/bin/php $dirroot/admin/cli/install_database.php \
    --agree-license \
    --adminemail="admin@test.local" \
    --fullname="$sitename" \
    --shortname="$sitenameshort" \
    --adminpass="$adminpass" \
    --lang="en" \
    --dbpass="pass" \
    --dbuser="pguser" \
    --dbname="pguser" \
    --dbhost="db"
EXEC;
    passthru($cmd);
};