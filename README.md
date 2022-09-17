# Referentiel

[![Build Status](https://travis-ci.org/ombr/referentiel.svg?branch=master)](https://travis-ci.org/ombr/referentiel)
[![Sauce Test Status](https://saucelabs.com/buildstatus/referentiel)](https://saucelabs.com/u/referentiel)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fombr%2Freferentiel.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fombr%2Freferentiel?ref=badge_shield)

[![Sauce Test Browser Matrix](https://saucelabs.com/browser-matrix/referentiel.svg)](https://saucelabs.com/u/referentiel)

Want to know what is the cursor position relative to an element when you have
css transform, absolute positioning ? Referentiel compute the transformation
matrix and can easily compute local coordinates.

# Installation

## npm

npm install --save referentiel

## html

```html
<script src="https://unpkg.com/referentiel"></script>
```

# Usage

```coffee
$('.referentiel').each (node)->
  $(this).on 'click', (e)->
    point = Referentiel.convertPointFromPageToNode(node, [e.pageX, e.pageY])
    $pointer.css('left', point[0])
    $pointer.css('top', point[1])
```

# Contribute

Clone the repo and then run

```
npm install
npm run start
```

# Warning on usage and performance

When you create a referentiel there is a cache build in. If you scroll or resize
your window, you will need to re-create the referentiel so it takes into account
the changes. (You will only get scroll issues with fixed elements)

# Compatibility

- Chrome 36+
- Firefox 16+
- IE 10+
- Safari 9+
- Edge 13+
- Android 5.0+
- IOS 9+
- Opera 23+


# Todo

- [ ] Test pass on IE9 if transform are prefixed and jquery is used instead of
  getComputedElement...
- [ ] Add more tests and edge cases...
- [ ] Manage scroll (globally and on elements)
- [ ] Round in the tests
- [ ] Greg's test
- [ ] CamelCase + check webkit naming convention

### Big Thanks

Cross-browser Testing Platform and Open Source <3 Provided by [Sauce Labs](https://saucelabs.com)

Opera testing provided by [Browserstack](https://browserstack.com)


## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fombr%2Freferentiel.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fombr%2Freferentiel?ref=badge_large)