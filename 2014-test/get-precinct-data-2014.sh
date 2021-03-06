PRES16=https://electionresults.sos.state.mn.us/Results/MediaResult/100?mediafileid=52 \
GOV14=https://electionresults.sos.state.mn.us/Results/MediaResult/20?mediafileid=39 \
SEN14=https://electionresults.sos.state.mn.us/Results/MediaResult/20?mediafileid=28 \

echo "Downloading 2018 precincts ..." &&
wget ftp://ftp.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_sos/bdry_votingdistricts/shp_bdry_votingdistricts.zip && \
  unzip shp_bdry_votingdistricts.zip  && \
  shp2json bdry_votingdistricts.shp | \
  mapshaper - -quiet -proj longlat from=bdry_votingdistricts.prj -o ./bdry_votingdistricts.json format=geojson && \
  cat bdry_votingdistricts.json | \
  geo2topo precincts=- > ./mn-precincts-longlat.tmp.json && \
  rm bdry_votingdistricts.* && \
  rm -rf ./metadata && \
  rm shp_bdry_votingdistricts.* &&

########## GET PRECINCT RESULTS ##########

echo "Downloading precinct results ..." &&

echo "2016 president ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;precincts_reporting;\
precincts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null $PRES16) > mn-pres-16.tmp.csv &&

echo "2014 governor ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;precincts_reporting;\
precincts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null $GOV14) > mn-gov-14.tmp.csv &&

echo "2014 senate ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;precincts_reporting;\
precincts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null $SEN14) > mn-sen-14.tmp.csv &&

######### PROCESS RESULTS ##########

echo "Calculating winners ..."

echo "2016 president ..." &&
cat mn-pres-16.tmp.csv | \
  csv2json -r ";" | \
  ndjson-split | \
  ndjson-map '{"id":  d.county_id + d.precinct_id, "county_id": d.county_id, "precinct_id": d.precinct_id, "party": d.party, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct)}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({party: d.party, votes: d.votes, votes_pct: d.votes_pct}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.party != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes > 0 ? d.votes[0].votes != d.votes[1].votes ? ["DFL", "R"].includes(d.votes[0].party) ? d.votes[0].party : "OTH" : "even" : "none", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined-pres-16.tmp.ndjson &&

echo "2014 governor ..." &&
cat mn-gov-14.tmp.csv | \
  csv2json -r ";" | \
  ndjson-split | \
  ndjson-map '{"id":  d.county_id + d.precinct_id, "county_id": d.county_id, "precinct_id": d.precinct_id, "party": d.party, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct)}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({party: d.party, votes: d.votes, votes_pct: d.votes_pct}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.party != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes > 0 ? d.votes[0].votes != d.votes[1].votes ? ["DFL", "R"].includes(d.votes[0].party) ? d.votes[0].party : "OTH" : "even" : "none", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined-gov-14.tmp.ndjson &&

echo "2014 senate ..." &&
cat mn-sen-14.tmp.csv | \
  csv2json -r ";" | \
  ndjson-split | \
  ndjson-map '{"id":  d.county_id + d.precinct_id, "county_id": d.county_id, "precinct_id": d.precinct_id, "party": d.party, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct)}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({party: d.party, votes: d.votes, votes_pct: d.votes_pct}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.party != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes > 0 ? d.votes[0].votes != d.votes[1].votes ? ["DFL", "R"].includes(d.votes[0].party) ? d.votes[0].party : "OTH" : "even" : "none", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined-sen-14.tmp.ndjson &&

######### JOIN RESULTS TOGETHER ##########

echo "Joining results together ..."
ndjson-join 'd.id' <(cat joined-pres-16.tmp.ndjson) <(cat joined-gov-14.tmp.ndjson) | \
  ndjson-map '{"id": d[0].id, "winner16pres": d[0].winner, "winner14gov": d[1].winner, "votes16pres": d[0].total_votes, "votes14gov": d[1].total_votes}' | \
ndjson-join 'd.id' - <(cat joined-sen-14.tmp.ndjson) | \
  ndjson-map '{"id": d[0].id, "winner16pres": d[0].winner16pres, "winner14gov": d[0].winner14gov, "winner14sen": d[1].winner, "votes16pres": d[0].votes16pres, "votes14gov": d[0].votes14gov, "votes14sen": d[1].total_votes}' > joined-all.tmp.ndjson

########## JOIN RESULTS TO MAPS ##########

echo "Joining results to maps ..."
ndjson-split 'd.objects.precincts.geometries' < mn-precincts-longlat.tmp.json | \
  ndjson-map -r d3 '{"type": d.type, "arcs": d.arcs, "properties": {"id": d3.format("02")(d.properties.COUNTYCODE) + d.properties.PCTCODE, "county": d.properties.COUNTYNAME, "precinct": d.properties.PCTNAME, "area_sqmi": d.properties.Shape_Area * 0.00000038610}}' > mn-precincts-longlat.tmp.ndjson &&
  ndjson-join 'd.properties.id' 'd.id' <(cat mn-precincts-longlat.tmp.ndjson) <(cat joined-all.tmp.ndjson) | \
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "county": d[0].properties.county, "precinct": d[0].properties.precinct, "area_sqmi": d[0].properties.area_sqmi, "winner16pres": d[1].winner16pres, "winner14gov": d[1].winner14gov, "winner14sen": d[1].winner14sen, "votes16_sqmi": d[1].votes16pres / d[0].properties.area_sqmi, "r16_dgov14": d[1].winner16pres == "R" && d[1].winner14gov == "DFL" ? "y" : "n", "r16_dsen14": d[1].winner16pres == "R" && d[1].winner14sen == "DFL" ? "y" : "n", "dgov14_rsen14": d[1].winner14gov == "DFL" && d[1].winner14sen == "R" ? "y" : "n"}}' | \
ndjson-reduce 'p.geometries.push(d), p' '{"type": "GeometryCollection", "geometries":[]}' > mn-precincts.geometries.tmp.ndjson &&

ndjson-join '1' '1' <(ndjson-cat mn-precincts-longlat.tmp.json) <(cat mn-precincts.geometries.tmp.ndjson) |
  ndjson-map '{"type": d[0].type, "bbox": d[0].bbox, "transform": d[0].transform, "objects": {"precincts": {"type": "GeometryCollection", "geometries": d[1].geometries}}, "arcs": d[0].arcs}' > mn-precincts-final.json &&
topo2geo precincts=mn-precincts-geo.json < mn-precincts-final.json &&

########## CLEANUP ##########

echo "Cleaning up" &&
rm *.tmp.* &&
rm mn-precincts-final-2014.json