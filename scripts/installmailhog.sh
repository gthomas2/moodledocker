#From https://www.lullabot.com/articles/installing-mailhog-for-ubuntu-1604
go get github.com/mailhog/MailHog
go get github.com/mailhog/mhsendmail
cp ~/go/bin/MailHog /usr/local/bin/mailhog
cp ~/go/bin/mhsendmail /usr/local/bin/mhsendmail