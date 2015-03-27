# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# INPUT INVERTER
# -----------------------------------------------------------------------------

# _slugify(string)
if ! @_slugify
  @_slugify = (string) ->
    return string.toString().toLowerCase()
      .replace(/\s+/g, '-')           # Replace spaces with -
      .replace(/[^\w\-]+/g, '')       # Remove all non-word chars
      .replace(/\-\-+/g, '-')         # Replace multiple - with single -
      .trim()                         # Trim - from start/end of text


class @InputInverter
  constructor: (@name, @value, @config, @object) ->
    @startsWith = @config.startsWith
    @_createEl()

    @inputs = {}

    for name, value of @value
      input = @_addInput(name, value, @config)
      @inputs[name] = input
      @$el.append input.$el

    return this

  _addInput: (name, value) ->
    inputConfig = $.extend {}, @config

    # get input label and type from name, e.g. "Page Title : text"
    labelAndType = name.split(' : ')

    # input label
    inputConfig.label = labelAndType[0].titleize()

    # input type
    inputType  = labelAndType[1]
    inputType ?= @config.defaultInputType || 'text'
    inputType  = $.trim(inputType)

    if ! _chrFormInputs[inputType]
      inputType = 'text'

    if @startsWith
      # update label if @startsWith is used
      inputConfig.label = inputConfig.label.replace(@startsWith, '').titleize()

      # use hidden input type for blocks that do not start with @startsWith
      if ! name.startsWith(@startsWith)
        inputType = 'hidden'

    # input css class
    inputConfig.klassName = 'inverter-block-' + _slugify(inputConfig.label)
    inputConfig.klass    ?= 'stacked'

    inputClass = _chrFormInputs[inputType]

    inputName = if @config.namePrefix then "#{ @config.namePrefix }#{ @name }[#{ name }]" else "#{ @name }[#{ name }]"
    inputConfig.namePrefix = @config.namePrefix

    return new inputClass(inputName, value, inputConfig, @object)

  _createEl: ->
    @$el =$ "<div class='input-#{ @config.type } #{ @config.klassName }'>"

  #
  # PUBLIC
  #

  initialize: ->
    for name, input of @inputs
      input.initialize()

    @config.onInitialize?(this)

  hash: (hash={}) ->
    obj = {}
    for key, input of @inputs
      input.hash(obj)
    hash[@config.klassName] = obj
    return hash

  updateValue: (@value) ->
    for key, input of @inputs
      input.updateValue(@value[key])

  showErrorMessage: (message) ->
    @$el.addClass 'error'
    @$errorMessage.html(message)

  hideErrorMessage: ->
    @$el.removeClass 'error'
    @$errorMessage.html('')


_chrFormInputs['inverter'] = InputInverter




