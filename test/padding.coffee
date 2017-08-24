# it 'handle padding', ->
#   elem = slim(!--PUG
#     div syle="padding: 5px 10px"
#   PUG)
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([5, 10])).to.equal([0, 0])
#   expect(referentiel.local([6, 12])).to.equal([1, 2])
