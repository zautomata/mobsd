#!/bin/sh

db="GeoLite2-City-CSV_20181030/GeoLite2-City-Locations-en.csv" 
IPS="41.43.101.44"
#for i in $IPS
#do
#  echo "$i,`geoiplookup $i | cut -d "," -f2 | sed -e 's/^[\t]//'`" >> ipinfo.csv
#done


## Get Cities

awk '
BEGIN {
	FS="\"+,\"+"
	OFS="\",\""
	print "\"" "id", "region_id", "name", "slug", "timezone" "\""
}
NR>1 {
	slug = tolower($6)
	slug_pass_one = gsub(/[ ,_.]/, "-", slug)

	if (slug in city_slugs) {
		i = 2
		newslug = slug "-" i
		while (newslug in city_slugs) {
			i++
			newslug = slug "-" i
		}
		slug = newslug
	}

	city_slugs[slug] = slug

	# id, name, slug
	print "\"" $5, $3, $6, slug, $7 "\""
}
END {
}
' $db 

