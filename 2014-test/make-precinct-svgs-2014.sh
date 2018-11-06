echo "R16 ..." &&
mapshaper -i mn-precincts-geo.json ./layers/mn-roads-longlat.json ./layers/mn-state-longlat.json ./layers/mn-cities-longlat.json snap combine-files \
  -quiet \
  -proj webmercator \
  -colorizer name=calcFill colors='#c0272d,#dfdfdf' categories="R,DFL" nodata='#dfdfdf' \
  -colorizer name=calcOpacity colors='0.1,0.25,0.5,0.75,1,1' breaks=10,25,100,500,100000 \
  -style fill='calcFill(winner16pres)' opacity='calcOpacity(votes16_sqmi)' target="mn-precincts-geo" \
  -style stroke='#dcdcdc' stroke-width=0.5 target="roads" \
  -style stroke='lightgray' fill="none" stroke-width=1 target="mn-state-longlat" \
  -style r=2 label-text='NAME' text-anchor="ANCHOR" dx="DX" dy="DY" font-size="1em" font-family="Helvetica" stroke='darkgray' stroke-width=0.5 target="cities" \
  -simplify 10% \
  -o ./output/r16.svg combine-layers &&

echo "R16, DGov14 ..." &&
mapshaper -i mn-precincts-geo.json ./layers/mn-roads-longlat.json ./layers/mn-state-longlat.json ./layers/mn-cities-longlat.json snap combine-files \
  -quiet \
  -proj webmercator \
  -colorizer name=calcFill colors='#0258a0,#dfdfdf' categories="y,n" nodata='#dfdfdf' \
  -colorizer name=calcOpacity colors='0.1,0.25,0.5,0.75,1,1' breaks=10,25,100,500,100000 \
  -style fill='calcFill(r16_dgov14)' opacity='calcOpacity(votes16_sqmi)' target="mn-precincts-geo" \
  -style stroke='#dcdcdc' stroke-width=0.5 target="roads" \
  -style stroke='lightgray' fill="none" stroke-width=1 target="mn-state-longlat" \
  -style r=2 label-text='NAME' text-anchor="ANCHOR" dx="DX" dy="DY" font-size="1em" font-family="Helvetica" stroke='darkgray' stroke-width=0.5 target="cities" \
  -simplify 10% \
  -o ./output/r16-dgov14.svg combine-layers &&

echo "R16, DSen14 ..." &&
mapshaper -i mn-precincts-geo.json ./layers/mn-roads-longlat.json ./layers/mn-state-longlat.json ./layers/mn-cities-longlat.json snap combine-files \
  -quiet \
  -proj webmercator \
  -colorizer name=calcFill colors='#0258a0,#dfdfdf' categories="y,n" nodata='#dfdfdf' \
  -colorizer name=calcOpacity colors='0.1,0.25,0.5,0.75,1,1' breaks=10,25,100,500,100000 \
  -style fill='calcFill(r16_dsen14)' opacity='calcOpacity(votes16_sqmi)' target="mn-precincts-geo" \
  -style stroke='#dcdcdc' stroke-width=0.5 target="roads" \
  -style stroke='lightgray' fill="none" stroke-width=1 target="mn-state-longlat" \
  -style r=2 label-text='NAME' text-anchor="ANCHOR" dx="DX" dy="DY" font-size="1em" font-family="Helvetica" stroke='darkgray' stroke-width=0.5 target="cities" \
  -simplify 10% \
  -o ./output/r16-dsen14.svg combine-layers &&

echo "DGov14, RSen14 ..." &&
mapshaper -i mn-precincts-geo.json ./layers/mn-roads-longlat.json ./layers/mn-state-longlat.json ./layers/mn-cities-longlat.json snap combine-files \
  -quiet \
  -proj webmercator \
  -colorizer name=calcFill colors='#c0272d,#dfdfdf' categories="y,n" nodata='#dfdfdf' \
  -colorizer name=calcOpacity colors='0.1,0.25,0.5,0.75,1,1' breaks=10,25,100,500,100000 \
  -style fill='calcFill(dgov14_rsen14)' opacity='calcOpacity(votes16_sqmi)' target="mn-precincts-geo" \
  -style stroke='#dcdcdc' stroke-width=0.5 target="roads" \
  -style stroke='lightgray' fill="none" stroke-width=1 target="mn-state-longlat" \
  -style r=2 label-text='NAME' text-anchor="ANCHOR" dx="DX" dy="DY" font-size="1em" font-family="Helvetica" stroke='darkgray' stroke-width=0.5 target="cities" \
  -simplify 10% \
  -o ./output/dgov14-rsen14.svg combine-layers