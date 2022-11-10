#!/bin/bash

psql mastodon_production -c "select spoiler_text from statuses where visibility in (0, 1) and spoiler_text != ''" | tr ',' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^re: //' | tr '[A-Z]' '[a-z]' | sort | uniq -c | sort -rn 
