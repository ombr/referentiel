describe "Positions", ->
  describe 'Fixed', ->
    it 'scoped', ->
      ref = from_template('
        <div style="position: fixed; top: 12px; left: 13px;">
          <div style="position: fixed; top: 50px; left: 20px;">
            <div class="reference">
            </div>
          </div>
        </div>
      ')
      expect(ref.global_to_local([20, 50])).toEqual([0, 0])
      expect(ref.global_to_local([30, 60])).toEqual([10, 10])

    it 'offset', ->
      ref = from_template('
        <div style="width: 13px; height: 12px;"></div>
        <div>
          <div style="position: fixed; top: 50px; left: 20px;">
              <div class="reference">
              </div>
          </div>
        </div>
      ')
      expect(ref.global_to_local([20, 50])).toEqual([0, 0])
      expect(ref.global_to_local([30, 60])).toEqual([10, 10])

  describe 'Absolute', ->
    it 'basic', ->
      ref = from_template('
        <div style="position: absolute; top: 50px; left:10px">
          <div class="reference" style="width: 50px; height: 50px;"></div>
        </div>
      ')
      expect(ref.global_to_local([10, 50])).toEqual([0, 0])
      expect(ref.global_to_local([20, 60])).toEqual([10, 10])

    it 'tricky', ->
      ref = from_template('
        <div style="position: absolute; top: 10px; left:10px">
          <div style="transform: scale(2); transform-origin: 0 0">
            <div style="position: absolute; top: 50px; left:10px">
              <div class="reference" style="width: 50px; height: 50px;"></div>
            </div>
          </div>
        </div>
      ')
      expect(ref.global_to_local([30, 110])).toEqual([0, 0])
      expect(ref.global_to_local([50, 130])).toEqual([10, 10])

    it 'stacked', ->
      ref = from_template('
        <div style="position: absolute; top: 50px; left:10px">
          <div style="position: absolute; top: 50px; left:10px">
            <div style="position: absolute; top: 50px; left:10px">
              <div class="reference" style="width: 50px; height: 50px;"></div>
            </div>
          </div>
        </div>
      ')
      expect(ref.global_to_local([30, 150])).toEqual([0, 0])
      expect(ref.global_to_local([40, 160])).toEqual([10, 10])
    it 'with transformations', ->
      ref = from_template('
        <div style="position: absolute; top: 50px; left:10px">
          <div class="reference" style="transform: rotate(180deg); transform-origin: 0 0; width: 50px; height: 50px;"></div>
        </div>
      ')
      expect(ref.global_to_local([10, 50])).toEqual([0, 0])
      # expect(ref.global_to_local([20, 60])).toEqual([10, 10])


  it 'manage margins', ->
    ref = from_template('
      <div style="margin-top: 10px">
        <div style="margin-top: 20px">
        <div class="reference" style="width: 50px; height: 50px;"></div>
      </div>
    ')
    expect(ref.global_to_local([0, 20])).toEqual([0, 0])
    expect(ref.global_to_local([0, 30])).toEqual([0, 10])

