
# it 'handle border', ->
#   elem = slim(!--PUG
#     div syle="border: 10px solid dark"
#   PUG)
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([10, 10])).to.equal([0, 0])
#   expect(referentiel.local([11, 12])).to.equal([1, 2])
