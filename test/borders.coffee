describe 'borders', ->
  it 'handle borders', ->
    ref = from_template(
      '<div class="reference" style="border-top: 5px black solid; border-left: 10px black solid;"></div>'
    )
    expect(ref.global_to_local([20, 10])).toEqual([10, 5])
    expect(ref.global_to_local([10, 5])).toEqual([0, 0])

  it 'handle margin', ->
    ref = from_template(
      '<div class="reference" style="margin: 6px 8px;"></div>'
    )
    expect(ref.global_to_local([0, 0])).toEqual([-8, -6])
    expect(ref.global_to_local([8, 6])).toEqual([0, 0])
