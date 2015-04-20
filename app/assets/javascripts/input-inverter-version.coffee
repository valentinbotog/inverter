# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# INPUT INVERTER VERSION SELECT
# -----------------------------------------------------------------------------
class @InputInverterVersion extends InputSelect

  _create_el: ->
    @config.optionsHashFieldName = 'version_options'
    @config.ignoreOnSubmission   = true
    @config.default              = 0
    @url                         = "#{ @config.path }/#{ @object._id }.json"

    @$el =$ "<div class='input-#{ @config.type } input-#{ @config.klass } #{ @config.klassName }'>"


  _add_input: ->
    @$input =$ """<select name='#{ @name }'></select>"""
    @$el.append @$input

    @$input.on 'change', (e) => @_load_version()

    @_add_options()


  _load_version: ->
    version = @$input.val()
    $.get @url, { version: version }, (object) ->
      chr.module.view.form.updateValues(object)


chr.formInputs['inverter-version'] = InputInverterVersion




