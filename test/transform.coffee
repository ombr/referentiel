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
    ref = from_template('<div class="context"><div class="reference" style="transform-origin: 5px 5px;transform: rotate(90deg);"></div></div>')
    expect(ref.global_to_local([5, 5])).toEqual([5, 5])
    expect(ref.global_to_local([0, 0])).toEqual([0, 10])
    expect(ref.global_to_local([10, 0])).toEqual([0, 0])


  it 'handle borders', ->
    ref = from_template(
      '<div class="context"><div class="reference" style="border-top: 5px black solid; border-left: 10px black solid;"></div></div>'
    )
    expect(ref.global_to_local([0, 0])).toEqual([-10, -5])
    expect(ref.global_to_local([10, 5])).toEqual([0, 0])

  it 'handle margin', ->
    ref = from_template('<div class="context"><div style="width: 100px; height: 20px;"></div><div class="reference" style="margin: 6px 8px;"></div></div>')
    expect(ref.global_to_local([0, 0])).toEqual([-8, -26])
    expect(ref.global_to_local([8, 26])).toEqual([0, 0])

  it 'manage context', ->
    ref = from_template('
      <div>
        <div style="width: 100px; height: 100px;">
          <div class="context">
            <div style="width: 100px; height: 20px;"></div>
            <div class="reference">
          </div>
        </div>
      </div>
    ')
    console.log(ref.global_to_local([0, 20]))
    expect(ref.global_to_local([0, 20])).toEqual([0, 0])

  it 'manage context and rotation', ->
    ref = from_template('
      <div>
        <div style="width: 100px; height: 100px;">
          <div class="context">
            <div style="width: 100px; height: 20px;"></div>
            <div class="reference" style="transform: rotation(90deg); transform-origin: 50% 50%;width: 50px; height: 50px;">
          </div>
        </div>
      </div>
    ')
    expect(ref.global_to_local([0, 20])).toEqual([0, 0])
    expect(ref.global_to_local([0, 20])).toEqual([0, 0])

  it 'manage a absolute position with context', ->
    ref = from_template('
      <div>
        <div style="width: 100px; height: 100px;">
          <div class="context">
            <div style="width: 100px; height: 20px;"></div>
            <div style="position: absolute; top: 50; left: 50;">
              <div class="reference" style="transform: rotation(90deg); transform-origin: 0 0;width: 50px; height: 50px;">
            </div>
          </div>
        </div>
      </div>
    ')
    expect(ref.global_to_local([50, 50])).toEqual([0, 0])

  it 'manage a fixed position with context', ->
    ref = from_template('
      <div>
        <div style="width: 100px; height: 100px;">
          <div class="context">
            <div style="width: 100px; height: 20px;"></div>
            <div style="position: fixed; top: 50; left: 50;">
              <div class="reference" style="transform: rotation(90deg); transform-origin: 0 0;width: 50px; height: 50px;">
            </div>
          </div>
        </div>
      </div>
    ')
    expect(ref.global_to_local([50, 50])).toEqual([0, 0])
    # expect(ref.global_to_local([50, 100])).toEqual([50, 80])

  it 'manage a fixed position with scroll', ->
    ref = from_template('
      <div>
        <div style="width: 100px; height: 10000px;">
          <div class="context">
            <div style="width: 100px; height: 20px;"></div>
            <div style="position: fixed; top: 0; left: 200;">
              <div class="reference" style="transform: rotation(90deg); transform-origin: 50% 50%;width: 50px; height: 50px;">
            </div>
          </div>
        </div>
      </div>
    ')
    window.scrollTo({top: 500})
    expect(ref.global_to_local([0, 0])).toEqual([50, 0])
    expect(ref.global_to_local([0, 20])).toEqual([0, 0])
    # expect(ref.global_to_local([0, 40])).toEqual([0, 20])
    #
  # it 'test issue repeated', ->
  #   ref = new Referentiel(
  #    dom('<div style="margin: 20px;"></div>')
  #   )
  #   expect(ref.global_to_local([20, 20])).toEqual([0, 0])
  #   expect(ref.global_to_local([20, 20])).toEqual([0, 0])
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
