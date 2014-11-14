###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###

#CodeContext = require './code-context'
#grammarMap = require './grammars'
#link ref: https://discuss.atom.io/t/file-path-for-assets-used-in-packages/6823/2
#atom://<PACKAGE NAME>/<LOCATION>/<FILE.EXT>


AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'

{View,BufferedProcess,$$} = require 'atom'

THREE = require './three.min'

module.exports =
class CustomProfileScriptAvatarView extends View
  @bufferedProcess: null
  scene: null #new THREE.Scene()
  camera: null # new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
  renderer: null # new THREE.WebGLRenderer();
  cube:null # new THREE Mesh
  Sheight: 480#window.innerHeight
  Swidth: 600#window.innerWidth


  @content: ->
    @div class: 'overlay from-top panel', outlet: 'scriptOptionsView', => #non header
    #@div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'render'
      @span class: 'heading-title', outlet: 'title'
      @div outlet:'renderscene'
      #@script src:'atom://customprofilescript/js/three.min.js', type:'text/javascript'
      #@script src:'atom://customprofilescript/js/render.js', type:'text/javascript'
      #@span class: 'heading-status', outlet: 'status'
      #@span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: ''
      #@span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: ''
      #@span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''
      #@span class: "heading-close icon-remove-close pull-right", click: 'close'

  initialize: (@runOptions) ->
    @ansiFilter = new AnsiFilter
    @title.text  'Avatar'

    @initThreejs()

    #@setStatus 'stop'
    console.log "initialize avatar?"

    #atom.workspaceView.append(this)
    # Bind commands
    #atom.workspaceView.command 'customprofilescript:msg-console', => @msgconsole()
    atom.workspaceView.command 'customprofilescript:toggleavatar', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:hideavatar', => @toggleScriptOptions 'hide'
    atom.workspaceView.command 'customprofilescript:showavatar', => @toggleScriptOptions 'show'
    #@toggleScriptOptions 'hide'
    atom.commands.add 'atom-workspace', 'customprofilescript:render': => @render()
    @render()

  initThreejs:->

    console.log @Sheight
    console.log @Swidth

    @scene =  new THREE.Scene()
    #@camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
    @camera = new THREE.PerspectiveCamera( 75,@Swidth/@Sheight, 0.1, 1000 );
    @renderer = new THREE.WebGLRenderer();
    #@renderer.setSize( window.innerWidth, window.innerHeight );
    @renderer.setSize( @Swidth, @Sheight );

    #console.log @scene
    #console.log @camera
    #console.log @renderer

    geometry = new THREE.BoxGeometry( 1, 1, 1 );
    material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    @cube = new THREE.Mesh( geometry, material );

    #console.log @cube
    @scene.add(@cube);

    @camera.position.z = 5;

    #console.log "@renderscene"
    @renderscene.append(@renderer.domElement)

  render:->
    #requestAnimationFrame( @render );
    console.log "render?"
    @cube.rotation.x += 0.1;
    @cube.rotation.x += 0.1;
    @renderer.render(@scene, @camera);

  toggleconsole:->
    atom.workspaceView.trigger 'customprofilescript:toggle-console'

  toggleScriptOptions: (command) ->
    #console.log command
    console.log "toggle toolbar"
    #@CustomScriptBuildsConfigView.hide()
    switch command
      when 'show' then this.show()
      when 'hide' then this.hide()
      else this.toggle()
    #console.log "toggle console"

  close: ->
    this.hide()

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
