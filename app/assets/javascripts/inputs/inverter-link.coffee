# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
# -----------------------------------------------------------------------------
# INPUT INVERTER LINK
# - depends on Loft character plugin for assets management
# -----------------------------------------------------------------------------
class @InputInverterLink extends InputString

  # PRIVATE ===================================================================

  _has_empty_value: ->
    return ($(@value).attr('href') == '' && $(@value).html() == '')

  _normalize_value: ->
    if ! (@value.indexOf('<a') > -1)
      @value = "<a title='' href=''></a>"

  _add_input: ->
    @$input =$ "<input type='hidden' name='#{ @name }' value='' />"
    @$el.append @$input
    @$input.val(@value)

    @_normalize_value()

    @_add_title()
    @_add_url()
    @_add_actions()

  _update_value: (url, title) ->
    $wrapper =$ "<div>#{ @value }</div>"
    $wrapper.children().attr('href', url).attr('title', title).html(title)
    @updateValue($wrapper.html())

  _title: -> $(@value).html()

  _url: -> $(@value).attr('href')

  _add_title: ->
    @$titleInput =$ "<input type='text' value='' placeholder='Title' />"
    @$el.append @$titleInput

    @$titleInput.val(@_title())

    @$titleInput.on 'change', (e) =>
      newTitle = $(e.target).val()
      @_update_value(@_url(), newTitle)

  _add_url: ->
    @$urlInput =$ "<input type='text' value='' placeholder='URL' />"
    @$el.append @$urlInput

    @$urlInput.val(@_url())

    @$urlInput.on 'change', (e) =>
      newUrl = $(e.target).val()
      @_update_value(newUrl, @_title())

  _add_actions: ->
    @$actions =$ "<span class='input-actions'></span>"
    @$label.append @$actions

    @_add_choose_button()
    @_add_remove_button()

  _add_choose_button: ->
    @$chooseBtn =$ "<a href='#' class='choose'>Choose or upload a file</a>"
    @$actions.append @$chooseBtn

    @$chooseBtn.on 'click', (e) =>
      e.preventDefault()
      chr.modules.loft.showModal 'all', false, (objects) =>
        url   = objects[0].file.url
        title = @_title() || objects[0].name
        @_update_value(url, title)

  _add_remove_button: ->
    @$removeBtn =$ "<a href='#' class='remove'>Remove</a>"
    @$actions.append @$removeBtn

    @$removeBtn.on 'click', (e) =>
      e.preventDefault()
      @_update_value('', '')

  # PUBLIC ====================================================================

  updateValue: (@value) ->
    @_normalize_value()

    @$titleInput.val(@_title())
    @$urlInput.val(@_url())

    if @_has_empty_value()
      @$input.val('')

    else
      @$input.val(@value)

    @$input.trigger('change')

formagicInputs['inverter-link'] = InputInverterLink
