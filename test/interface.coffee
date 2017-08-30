describe 'Referentiel', ->
  it 'without any transformation', ->
    ref = new Referentiel(
      dom('<div></div>')
    )
    expect(ref.global_to_local([0, 0])).toEqual([0, 0])
    expect(ref.global_to_local([1, 2])).toEqual([1, 2])
