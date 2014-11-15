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

#link ref:https://github.com/guscost/guscost.github.io/blob/master/spacefrack/js/etc/atom.coffee

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
  cube: null # new THREE Mesh
  Sheight: 320#window.innerHeight
  Swidth: 480#window.innerWidth
  bStart: true
  bPause: false
  ms: 500
  IsRenderCreated: false

  @content: ->
    #@element = document.createElement('div')
    #@element.classList.add('customprofilescript',  'overlay', 'from-top')
    @div class: 'customprofilescript overlay from-top', =>
    #@div class: 'panel-heading padded heading header-view', outlet: 'AvatarHeader', => #header
      @div id:'mymodal', class: 'overlay from-top panel', outlet: 'AvatarView', => #non header
      #@div class: 'panel-heading padded heading header-view', => #header
        @div class: 'block', =>
          @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'render'
          @span class: 'heading-title', outlet: 'title'
          @span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: 'start'
          @span class: 'heading-status icon-playback-pause', outlet: 'icon_stop', click: 'pause'
          @span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: 'stop'
          @span class: 'heading-status icon-sync', outlet: 'icon_restart', click: 'restart'
        @div class: 'block', =>
          @div outlet:'renderscene'
          #@script src:'atom://customprofilescript/js/three.min.js', type:'text/javascript'
          #@script src:'atom://customprofilescript/js/render.js', type:'text/javascript'
          #@span class: 'heading-status', outlet: 'status'
          #@span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: ''
          #@span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: ''
          #@span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''
          #@span class: "heading-close icon-remove-close pull-right", click: 'close'
  #constructor: (serializeState) ->
    #super
    #atom.commands.add 'atom-workspace', 'customprofilescript:timetick': -> @timetick()

  initialize: (@runOptions) ->
    #$('#myModal').draggable();
    #@AvatarView
    #console.log $('#yModal').hide()
    console.log "@content"
    console.log @element
    #console.log $$
    console.log @AvatarView


    @ansiFilter = new AnsiFilter
    @title.text  ' Avatar '

    @initThreejs()

    #@setStatus 'stop'
    #console.log "initialize avatar?"
    #atom.workspaceView.appendToTop(this)
    #atom.workspaceView.appendToRight(this)
    #atom.workspaceView.append(this)
    # Bind commands
    atom.workspaceView.command 'customprofilescript:toggleavatar', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:hideavatar', => @toggleScriptOptions 'hide'
    atom.workspaceView.command 'customprofilescript:showavatar', => @toggleScriptOptions 'show'
    #@toggleScriptOptions 'hide'
    atom.commands.add 'atom-workspace', 'customprofilescript:render': => @render()

    atom.commands.add 'atom-workspace', 'customprofilescript:startrender': => @start()
    atom.commands.add 'atom-workspace', 'customprofilescript:pauserender': => @pause()
    atom.commands.add 'atom-workspace', 'customprofilescript:stoprender': => @stop()
    atom.commands.add 'atom-workspace', 'customprofilescript:restartrender': => @restart()

    #console.log
    #window.requestAnimationFrame( @render())
    #@render()
    #console.log setTimeout

  timetick:->
    console.log 'tick'

  initThreejs:->
    #console.log @Sheight
    #console.log @Swidth

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

  start:->
    #console.log "start"
    @bPause = false
    if @IsRenderCreated == false
      @render()
      #console.log "render init?"
    #console.log "end start"


  pause:->
    #console.log "pause"
    @bPause = true

  stop:->
    #console.log "stop"
    #window

  restart:->
    console.log "restart"

  render:->
    @IsRenderCreated = true
    callback = @render.bind(@)
    window.requestAnimationFrame(callback, 1000 )
    if @bPause == true
      return

    #console.log('foo = ', @foo)
    #requestAnimationFrame
    #window.requestAnimationFrame( @render() );
    #console.log "render?"

    @cube.rotation.x += 0.1;
    @cube.rotation.y += 0.1;
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
