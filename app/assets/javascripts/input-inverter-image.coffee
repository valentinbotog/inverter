# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# INPUT INVERTER IMAGE
# - depends on Loft character plugin for assets management
# -----------------------------------------------------------------------------
class @InputInverterImage extends InputString

  # PRIVATE ===============================================

  _add_input: ->
    @_normalize_value()

    @$el.addClass('input-loft-image')
    @$el.addClass('has-value')

    @$input =$ "<input type='hidden' name='#{ @name }' value='#{ @_safe_value() }' />"
    @$el.append @$input

    @_add_image()
    @_add_choose_button()
    @_add_remove_button()
    @_add_alt()


  _normalize_value: ->
    if @value.indexOf('<img') > -1
      @value = @value.replace(new RegExp('"', 'g'), "'")

      if ! @value.indexOf(' alt=') > -1
        @value.replace('<img ', "<img alt='' ")
    else
      @value = "<img src='' alt='' />"


  _alt: -> $(@value).attr('alt')


  _src: -> $(@value).attr('src')


  _add_alt: ->
    @$altInput =$ "<input type='text' value='' placeholder='Text alternative (alt)' />"
    @$el.append @$altInput

    @_update_alt()

    @$altInput.on 'change', (e) =>
      newAlt = $(e.target).val()
      @_update_value(@_src(), newAlt)


  _update_alt: ->
    @$altInput.val(@_alt())
    if @_src() == '' then @$altInput.hide() else @$altInput.show()


  _add_image: ->
    @$image =$ "<a href='' target='_blank' class='image'><img src='' /></a>"
    @$el.append @$image
    @_update_image()


  _update_image: ->
    imageUrl = @_src()
    if imageUrl == ''
      @$el.removeClass('has-value')
      @$image.hide()
    else
      @$el.addClass('has-value')
      @$image.attr('href', imageUrl).children().attr('src', imageUrl)
      @$image.show()


  _add_choose_button: ->
    @$chooseBtn =$ "<a href='#' class='choose'></a><br/>"
    @$el.append @$chooseBtn

    @_update_choose_button_title()

    @$chooseBtn.on 'click', (e) =>
      e.preventDefault()
      chr.modules.assets.showModal 'images', false, (objects) =>
        newSrc = objects[0].file.url
        alt    = @_alt() || objects[0].name
        @_update_value(newSrc, alt)


  _update_choose_button_title: ->
    title = if @value == '' then 'Choose or upload' else 'Choose other or upload'
    @$chooseBtn.html(title)


  _update_value: (src, alt) ->
    value = @value
    value = value.replace("src='#{ @_src() }'", "src='#{ src }'")
    value = value.replace("alt='#{ @_alt() }'", "alt='#{ alt }'")
    @updateValue(value)


  _add_remove_button: ->
    @$removeBtn =$ "<a href='#' class='remove'>Remove</a>"
    @$el.append @$removeBtn

    @$removeBtn.on 'click', (e) =>
      e.preventDefault()
      if confirm('Are you sure?')
        @updateValue('')


  # PUBLIC ================================================

  updateValue: (@value) ->
    @_normalize_value()
    @$input.val(@value)

    @_update_image()
    @_update_alt()


chr.formInputs['inverter-image'] = InputInverterImage




