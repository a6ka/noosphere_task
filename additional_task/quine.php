echo 'Самый читерский способ написания квайна - просто убрать тег "< ?php" из скрипта :-)';

<?php
$code = '<?php
$code = \'\';
$rcode = str_replace(chr(39), chr(92) . chr(39), $code);
$code  = str_replace(\'$code = \' . chr(39) . chr(39) . \';\', \'$code = \' . chr(39) . $rcode . chr(39) . \';\', $code);
print $code . PHP_EOL;';
$rcode = str_replace(chr(39), chr(92) . chr(39), $code);
$code  = str_replace('$code = ' . chr(39) . chr(39) . ';', '$code = ' . chr(39) . $rcode . chr(39) . ';', $code);
print $code . PHP_EOL;