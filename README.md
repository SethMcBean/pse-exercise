# README #

I solved this challenge by first setting up the web root folders needed to
store files for our nginx vhost. After that, I made sure git was installed in
order to facilitate the vcsrepo module to pull files from the
puppetlabs/exercise-webpage repository on Github and place them into a folder
created for our vhost. Then I setup an nginx instance and declared a vhost
named www.puppetlabs.dev, running on port 8000 and serving files from the
pre-configured vhost directory under our web root. Lastly, I updated the local
hosts file to resolve the hostname of our new vhost.

Successful configuration was verified using the command:
$curl -v www.puppetlabs.dev:8000
