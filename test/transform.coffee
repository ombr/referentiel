describe "Rotations", ->
  it 'handle rotations', ->
    ref = new Referentiel(
     dom('<div style="transform-origin: 0 0;transform: rotate(90deg);"></div>')
    )
    expect(ref.global_to_local([0, 0])).toEqual([0, 0])
    expect(ref.global_to_local([0, 10])).toEqual([10, 0])
    expect(ref.global_to_local([1, 0])).toEqual([0, -1])

  it 'handle multiple transformations', ->
    ref = new Referentiel(
      dom('<div style="transform-origin: 0 0;transform: scale(2) rotate(180deg);"></div>')
    )
    expect(ref.global_to_local([0, 0])).toEqual([0, 0])
    expect(ref.global_to_local([0, 10])).toEqual([0, -5])
    expect(ref.global_to_local([1, 0])).toEqual([-0.5, 0])

  it 'handle transform-origin', ->
    ref = new Referentiel(
      dom('<div style="transform-origin: 5px 5px;transform: rotate(90deg);"></div>')
    )
    expect(ref.global_to_local([5, 5])).toEqual([5, 5])
    expect(ref.global_to_local([0, 0])).toEqual([0, 10])
    expect(ref.global_to_local([10, 0])).toEqual([0, 0])

# it 'handle a hierachy of transformation', ->
#   elem = slim(!--PUG
#     div syle="transform: rotate(90deg)"
#       div syle="transform: scale(2)"
#   PUG)
#   referentiel = new referentiel(elem)
#   expect(referentiel.local([5, 5])).to.equal([5, -5])
#   expect(referentiel.local([0, 0])).to.equal([10, 0])
#   expect(referentiel.local([10, 0])).to.equal([10, 10])
