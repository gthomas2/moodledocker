#!/usr/bin/expect
spawn curl https://pear.php.net/go-pear.phar -o /tmp/go-pear.phar
expect eof

spawn php /tmp/go-pear.phar

expect "1-11, 'all' or Enter to continue:"
send "\r"
expect eof

spawn rm /tmp/go-pear.phar