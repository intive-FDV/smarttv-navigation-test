# Platform-specific stuff for different smart TV vendors.

isSamsung = /maple/i.test navigator.userAgent

if isSamsung
  # alert is used for debugging in Samsung.
  @console =
    log: (args...) -> alert args

  # Samsung needs a couple of script tags.
  document.write """
    <script type='text/javascript' src='$MANAGER_WIDGET/Common/API/Widget.js'></script>
    <script type='text/javascript' src='$MANAGER_WIDGET/Common/API/TVKeyValue.js'></script>
  """
  # When those scripts are loaded, change the key code values for the stupid
  # values Samsung uses.
  window.onload = ->
    keys = new Common.API.TVKeyValue()
    @VK_LEFT  = keys.KEY_LEFT
    @VK_RIGHT = keys.KEY_RIGHT
    @VK_UP    = keys.KEY_UP
    @VK_DOWN  = keys.KEY_DOWN
