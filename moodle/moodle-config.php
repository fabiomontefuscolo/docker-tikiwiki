<?php
unset($CFG);
global $CFG;

$CFG = new stdClass();

$CFG->dbtype    = getenv('DBTYPE') ?: 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('DBHOST') ?: 'database';
$CFG->dbname    = getenv('DBNAME') ?: 'moodle';
$CFG->dbuser    = getenv('DBUSER') ?: 'moodle';
$CFG->dbpass    = getenv('DBPASS') ?: 'moodle';
$CFG->prefix    = getenv('PREFIX') ?: 'mdl_';

$CFG->dboptions = array(
    'dbpersist' => false,
    'dbsocket'  => false,
    'dbport'    => '3306',
);

$CFG->wwwroot   = getenv('WWWROOT') ?: 'http://localhost';
$CFG->dataroot  = '/var/www/moodledata';
$CFG->directorypermissions = 02777;
$CFG->admin = 'admin';

require_once(dirname(__FILE__) . '/lib/setup.php');
