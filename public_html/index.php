<?php

// Debugging
// ini_set('error_reporting', E_ALL);
// ini_set('display_errors', true);

// Composer autoloader
require '../vendor/autoload.php';

$smarty = new Smarty;
$smarty->template_dir = realpath(__DIR__ . '/../views/src');
$smarty->compile_dir = realpath(__DIR__ . '/../views/compiled');

$smarty->assign('name', 'Foo');

$smarty->display('index.tpl');
