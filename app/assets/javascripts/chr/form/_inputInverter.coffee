# -----------------------------------------------------------------------------
# INPUT HASH
# -----------------------------------------------------------------------------
class @InputInverter
  constructor: (@name, @value, @config, @object) ->
    @_createEl()

    @inputs = {}

    for name, value of @value
      input = @_addInput(name, value, @config)
      @inputs[name] = input
      @$el.append input.$el

    return this

  _addInput: (name, value) ->
    inputConfig = $.extend {}, @config

    inputType             = @config.defaultInputType || 'text'
    inputConfig.label     = name.titleize()
    inputConfig.klass    ?= 'stacked'
    inputConfig.klassName = name

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
    hash[@config.klassName] = '' #@$input.val()
    return hash

  updateValue: (@value) ->
    ''
    #@$input.val(@value)

  showErrorMessage: (message) ->
    @$el.addClass 'error'
    @$errorMessage.html(message)

  hideErrorMessage: ->
    @$el.removeClass 'error'
    @$errorMessage.html('')


_chrFormInputs['inverter'] = InputInverter




