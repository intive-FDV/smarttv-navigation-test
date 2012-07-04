@VK_LEFT  or= 37
@VK_RIGHT or= 39
@VK_UP    or= 38
@VK_DOWN  or= 40

$(document).keydown (e) ->
  handleNavigationKey e.target, e.keyCode

# A simple navigation handler. Reads the data-nav-* properties of an element to
# see where to navigate to. For example, the HTML:
#
#    <button data-nav-left="#other-element">Some Button</button>
#
# declares that when that button is focused and the left key is pressed, the
# element that corresponds to the selector "#other-element" will be focused.
#
# If no navigation data that correspònds to the given key is declared in the
# element, the function will "bubble" to the element's parent and so on.
#
# The possible data-nav-* values are "left", "right", "up" and "down". The value
# can be either a selector or an element, and can be set programmatically:
#
#    $(someElement).data('navLeft', otherElement)
handleNavigationKey = (el, keyCode) ->
  direction = directionForKey keyCode
  return unless el and direction
  nextElSelector = $(el).data(direction)
  if nextElSelector
    $(nextElSelector).focus()
  else
    handleNavigationKey el.parentNode, keyCode

directionForKey = (keyCode) ->
  switch keyCode
    when VK_LEFT  then 'navLeft'
    when VK_RIGHT then 'navRight'
    when VK_UP    then 'navUp'
    when VK_DOWN  then 'navDown'

# The menu remembers which element was last focused.
lastFocused = null
$('.menu button').focus ->
  lastFocused = @
$('.menu').focus ->
  $(lastFocused or '.menu button:first').focus()

# The content panel just focuses the first item.
$('.content').focus ->
  $(@).find('.item:first').focus()

# Adds navLeft/navRight or navUp/navDown data to a sequence of elements.
# `direction` must be "horizontal" or "vertical"
addNavigationData = (elements, direction) ->
  prevDir = if direction is 'horizontal' then 'navLeft'  else 'navUp'
  nextDir = if direction is 'horizontal' then 'navRight' else 'navDown'
  for el, i in elements
    $(el).data(prevDir, elements[i - 1]) if i > 0
    $(el).data(nextDir, elements[i + 1]) if i < elements.length - 1

addNavigationData $('.menu button'), 'vertical'
addNavigationData $('.content .item'), 'horizontal'

# Menu is focused at the start.
$('.menu').focus()