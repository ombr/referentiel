describe 'borders', ->
  it 'handle borders', ->
    ref = new Referentiel(
      dom('<div style="border-top: 5px black solid; border-left: 10px black solid;"></div>')
    )
    expect(ref.global_to_local([0, 0])).toEqual([10, 5])
    expect(ref.global_to_local([10, 5])).toEqual([0, 0])

describe 'margin', ->
  it 'handle margin', ->
    ref = new Referentiel(
      dom('<div style="margin: 6px 8px;"></div>')
    )
    expect(ref.global_to_local([0, 0])).toEqual([8, 6])
    expect(ref.global_to_local([8, 6])).toEqual([0, 0])
