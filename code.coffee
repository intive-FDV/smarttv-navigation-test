@VK_LEFT  or= 37
@VK_RIGHT or= 39
@VK_UP    or= 38
@VK_DOWN  or= 40

$(document).keydown (e) ->
  if handleNavigationKey e.target, e.keyCode
    e.preventDefault() # Prevent Philips NetTV's default navigation.

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
#
# Returns true if the keyCode was a navigation key (and therefore was handled)
# or false otherwise.
handleNavigationKey = (el, keyCode) ->
  direction = directionForKeys keyCode
  return false unless el and direction
  nextElSelector = $(el).data(direction)
  if nextElSelector
    navigateTo $(nextElSelector)
  else
    handleNavigationKey el.parentNode, keyCode
  true

directionForKeys = (keyCode) ->
  switch keyCode
    when VK_LEFT  then 'navLeft'
    when VK_RIGHT then 'navRight'
    when VK_UP    then 'navUp'
    when VK_DOWN  then 'navDown'

navigateTo = ($el) ->
  if isFocusable $el
    $el.focus()
  else
    # On some brosers (Samsung) the focus event cannot be triggered on
    # non-focusable elements, so the attached handlers are called directly.
    $el.triggerHandler 'focus'

isFocusable = ($el) ->
  $el.is 'a, input, button, select'

# The menu remembers which element was last focused.
lastFocused = null
$('.menu .option').focus ->
  lastFocused = @
$('.menu').focus ->
  $(lastFocused or '.menu .option:first').focus()

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

addNavigationData $('.menu .option'), 'vertical'
addNavigationData $('.content .item'), 'horizontal'

# Menu is focused at the start.
navigateTo $('.menu')