@VK_LEFT  or= 37
@VK_RIGHT or= 39
@VK_UP    or= 38
@VK_DOWN  or= 40

$(document).keydown (e) ->
  handleNavigationKey e.target, e.keyCode

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
  prevDir = if direction is 'horizontal' then 'navLeft' else 'navUp'
  nextDir = if direction is 'horizontal' then 'navRight' else 'navDown'
  for el, i in elements
    $(el).data(prevDir,   elements[i - 1]) if i > 0
    $(el).data(nextDir, elements[i + 1]) if i < elements.length - 1

addNavigationData $('.menu button'), 'vertical'
addNavigationData $('.content .item'), 'horizontal'

# Menu is focused at the start.
$('.menu').focus()