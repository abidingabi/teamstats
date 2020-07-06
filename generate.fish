#!/usr/bin/env fish

function strip_whitespace
    sed -e 's/^[ \t]*//'
end

# Main output
set index_file "docs/index.html"


# Intermediate files
set markdown_file "build/out.md"

set years_file "build/years.txt"
# set total_teams_file "build/total.txt"
set rookie_counts_file "build/rookie_counts.txt"
set last_active_file "build/last_active.txt"

printf "# FTC Team Statistics\n\n" > $markdown_file

get_TOA_data team | jq '.[] | .rookie_year' | sort | uniq | sed '1i\Year' > $years_file

get_TOA_data team | jq '.[] | .rookie_year' | sort | uniq -c | strip_whitespace | cut -d' ' -f1 | sed '1i\Rookies' > $rookie_counts_file
get_TOA_data team | jq '.[] | .last_active' | sort | uniq -c | strip_whitespace | cut -d' ' -f1 | sed '1i\Last Active' > $last_active_file


paste -d',' $years_file $rookie_counts_file $last_active_file | csv2md >> $markdown_file

pandoc $markdown_file -o $index_file