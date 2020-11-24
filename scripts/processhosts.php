<?php

/**
 * Class process_hosts
 * This class enables vhost servernames within the sites-enabled folder to be added to the
 * containers /etc/hosts file and mapped to the docker host ip.
 * This means that the container can then access itself using curl via the host, which is
 * very important since it's likely to be accessed via a totally different port on the host.
 * It is especially useful if you are using a reverse proxy on your host to manage
 * multiple docker container web servers.
 */
class process_hosts {
    private function __construct() {
        $this->writetohosts();
    }

    /**
     * Entry point.
     */
    public static function go() {
        static $alreadyran = false;
        if ($alreadyran) {
            return;
        }
        new process_hosts();
        $alreadyran = true;
    }

    /**
     * Get hostname from a vhost file's contents.
     * @param string $vhostcontents
     * @return null|string
     */
    private function get_hostname(string $vhostcontents): ?string {
        $regex = '/(?<=server_name)\s*(.*);/';
        $matches = [];
        preg_match($regex, $vhostcontents, $matches);
        if (count($matches) < 2) {
            return null;
        }
        return $matches[1];
    }

    /**
     * Get the docker host ip.
     * @return string
     */
    private function get_hostip(): string {
        $cmd = <<<CMD
    /sbin/ip route|awk '/default/ { print $3 }'
CMD;
        $ip = shell_exec($cmd);
        return trim($ip);
    }

    private function writetohosts() {
        sleep(1);

        $path = '/etc/nginx/sites-enabled';
        $files = scandir($path);
        $hostip = $this->get_hostip();
        $entries = '';
        foreach ($files as $file) {
            if (preg_match('/^.(?:.|)$/', $file)) {
                continue;
            }
            $contents = file_get_contents($path.'/'.$file);
            $hostname = $this->get_hostname($contents);
            $entries .= "\n".$hostip.' '.$hostname;
        }

        $entries .= "\n".$hostip.' dockerhost';
        file_put_contents('/etc/hosts', $entries, FILE_APPEND);
    }
}

process_hosts::go();