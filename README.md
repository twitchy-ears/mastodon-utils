# mastodon-utils

A few handy scripts for running stock mastodon servers

dump-spoilers.sh : Dumps out all the Content-Warning/Spoiler tags for all statuses marked public or unlisted that your server knows about, splits them by commas, flattens the case down to lowercase and sorts and counts them.

dump-users.pl : Can dump out a list of your users, including email addresses, in a format that can be used for email aliasing if you want
