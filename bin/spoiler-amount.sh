#!/bin/bash

num_spoilers=$( psql mastodon_production -A -t -c "select count(*) from statuses where visibility in (0, 1) and spoiler_text != ''" )
num_statuses=$( psql mastodon_production -A -t -c "select count(*) from statuses where visibility in (0, 1) and spoiler_text = ''" )
echo -e "Public/Unlisted statuses with spoilers:    ${num_spoilers}"
echo -e "Public/Unlisted statuses without spoilers: ${num_statuses}" 
