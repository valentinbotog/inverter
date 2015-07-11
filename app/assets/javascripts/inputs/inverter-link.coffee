# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# INPUT INVERTER LINK
# - depends on Loft character plugin for assets management
# -----------------------------------------------------------------------------
class @InputInverterLink extends InputString

  # PRIVATE ===============================================

  _has_empty_value: ->
    return (@value == '<a title="" href=""></a>')


  _normalize_value: ->
    if ! (@value.indexOf('<a') > -1)
      @value = "<a title='' href=''></a>"


  _add_input: ->
    @_normalize_value()

    # @$el.addClass('input-loft-image')
    # @$el.addClass('has-value')

    @$input =$ "<input type='hidden' name='#{ @name }' value='#{ @_safe_value() }' />"
    @$el.append @$input

    @_add_title()
    @_add_url()
    @_add_choose_button()


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


  _add_choose_button: ->
    @$actions =$ "<span class='input-actions'></span>"
    @$label.append @$actions

    @$chooseBtn =$ "<a href='#' class='choose'>Choose or upload a file</a>"
    @$actions.append @$chooseBtn

    # @$chooseBtn =$ "<a href='#' class='choose'>Choose or upload a file</a>"
    # @$el.append @$chooseBtn

    @$chooseBtn.on 'click', (e) =>
      e.preventDefault()
      chr.modules.loft.showModal 'all', false, (objects) =>
        url   = objects[0].file.url
        title = @_title() || objects[0].name
        @_update_value(url, title)


  # PUBLIC ================================================

  updateValue: (@value) ->
    @_normalize_value()

    @$titleInput.val(@_title())
    @$urlInput.val(@_url())

    if @_has_empty_value()
      @$input.val('')

    else
      @$input.val(@value)

    @$input.trigger('change')


chr.formInputs['inverter-link'] = InputInverterLink




