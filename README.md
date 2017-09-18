# Referentiel

[![Build Status](https://travis-ci.org/ombr/referentiel.svg?branch=master)](https://travis-ci.org/ombr/referentiel)

# Installation

## npm

npm install --save referentiel

## html

```html
<script src="https://unpkg.com/referentiel"></script>
```

# Usage

```coffee
$('.referentiel').each ->
  ref = new Referentiel(this)
  $(this).on 'click', (e)->
    input = [e.pageX, e.pageY]
    p = ref.global_to_local(input)
    $pointer = $('.pointer', this)
    $pointer.css('left', p[0]-1)
    $pointer.css('top', p[1]-1)
```

# Contribute

Clone the repo and then run

```
npm install
npm run start
```

# Todo

- [ ] Add more tests and edge cases...
- [ ] Manage position fixed, absolute,...
- [ ] Manage margins
