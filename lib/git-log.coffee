{BufferedProcess} = require 'atom'
LogListView = require './log-list-view'
StatusView = require './status-view'

dir = -> atom.project.getRepo()?.getWorkingDirectory() ? atom.project.getPath()

currentFile = ->
  atom.project.relativize atom.workspace.getActiveEditor()?.getPath()

amountOfCommitsToShow = ->
  atom.config.getPositiveInt('git-plus.amountOfCommitsToShow') ? (atom.config.getDefault 'git-plus.amountOfCommitsToShow')

gitLog = (onlyCurrentFile=false) ->
  args = ['log', '--pretty="%h;|%aN <%aE>;|%s;|%ar (%aD)"', '-s']
  args.push "-n#{amountOfCommitsToShow()}"
  args.push currentFile() if onlyCurrentFile and currentFile()?

  new BufferedProcess
    command: 'git'
    args: args
    options:
      cwd: dir()
    stdout: (data) ->
      new LogListView(data, onlyCurrentFile)
    stderr: (data) ->
      new StatusView(type: 'alert', message: data.toString())

module.exports = gitLog