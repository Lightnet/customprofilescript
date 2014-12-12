###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###

path = require 'path'
_ = require 'underscore-plus'
{$, $$, ScrollView, TextEditorView} = require 'atom'
#async = require 'async'
#CSON = require 'season'

module.exports =
class CustomProfileScriptConfigView extends ScrollView
  #@bufferedProcess: null

  @content: ->
    @div class: 'settings-view pane-item', tabindex: -1, =>
      @div class: 'config-menu', outlet: 'sidebar', =>
        @ul class: 'panels-menu nav nav-pills nav-stacked', outlet: 'panelMenu', =>
          @div class: 'panel-menu-separator', outlet: 'menuSeparator'
          @div class: 'editor-container settings-filter', =>
            #@span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''
            #@subview 'filterEditor', new TextEditorView(mini: true, placeholderText: 'Filter packages')
        @ul class: 'panels-packages nav nav-pills nav-stacked', outlet: 'panelPackages'
        #@span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''
        @div class: 'button-area', =>
          #@button class: 'btn btn-default icon icon-link-external', outlet: 'openDotAtom', 'Open ~/.atom'

      #@div class: 'panels padded', outlet: 'panels'
      @div class: 'panels padded', outlet: 'scriptOptionsView', => #non header
        #@div class: 'panel-body padded', =>
        @span class: 'heading-status icon-alert', outlet: 'icon_restart', click: ''
        @label 'Setting Name:'
        @input
          type: 'text'
          class: 'editor mini native-key-bindings'
          outlet: 'inputSettingName'
        @div class: 'block', =>
          css = 'btn inline-block-tight'
          @button class: "btn #{css}", click: '', 'Save'



  initialize: ({@uri, activePanelName}={}) ->
    super
    #console.log 'initialize'
    #console.log "@uri"
    #console.log @uri
    #

  #handlePackageEvents: ->

  #initializePanels: ->

  #afterAttach: (onDom) ->

  #serialize: ->

  #getPackages: ->

  #addCorePanel: (name, iconName, panel) ->

  #addPackagePanel: (pack) ->

  #addPanel: (name, panelMenuItem, panelCreateCallback) ->

  #getOrCreatePanel: (name) ->

  #makePanelMenuActive: (name) ->

  #focus: ->
    #super

  #showPanel: (name) ->

  #filterPackages: ->

  #removePanel: (name) ->

  getTitle: ->
    "CustomProfileScript Config"

  #getIconName: ->
    #"tools"

  getUri: ->
    @uri

  isEqual: (other) ->
    other instanceof MyView
