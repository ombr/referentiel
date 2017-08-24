
it 'handle rotations', ->
  ref = new Referentiel(
    dom('<div style="transform: rotate(90deg);"></div>')
  )
  """
  asdasd
  asdasdasd
  """
  expect(ref.global_to_local([0, 0])).to.equal([0, 0])
  expect(ref.local([0, 10])).to.equal([-10, 0])
  expect(ref.local([1, 0])).to.equal([0, 1])

# it 'handle multiple transformations', ->
#   elem = $('<div style="transform: scale(2) rotate(180deg);transform-origin: 0 0;"></div>')[0]
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([0, 0])).to.equal([0, 0])
#   expect(referentiel.local([0, 10])).to.equal([0, -20])
#   expect(referentiel.local([1, 0])).to.equal([-2, 0])
#
# it 'handle transform-origin', ->
#   elem = $('<div style="transform: rotate(90deg);transform-origin: 5 5;"></div>')[0]
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([5, 5])).to.equal([5, -5])
#   expect(referentiel.local([0, 0])).to.equal([10, 0])
#   expect(referentiel.local([10, 0])).to.equal([10, 10])
#
# it 'handle a hierachy of transformation', ->
#   elem = slim(!--PUG
#     div syle="transform: rotate(90deg)"
#       div syle="transform: scale(2)"
#   PUG)
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([5, 5])).to.equal([5, -5])
#   expect(referentiel.local([0, 0])).to.equal([10, 0])
#   expect(referentiel.local([10, 0])).to.equal([10, 10])
