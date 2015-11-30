
Header = React.createClass

  getInitialState: ->
    searchVal: @props.search

  handleSearchChange: (event) ->
    @setState
      searchVal: event.target.value

  setSearch: (val) ->
    @props.setSearch(val)

  handleSearchKeyPress: (event) ->
    if event.keyCode is 13 # Enter: commit search and close
      @setSearch(@state.searchVal)
      $("#searchDDToggle").dropdown("toggle")
    else if event.keyCode is 27 # Escape: clear search and commit
      @setState
        searchVal: ''
      @setSearch('')
      $("#searchDDToggle").dropdown("toggle")

  handleSearchToggle: (event) ->
    ReactDOM.findDOMNode(@refs.searchInput).focus()

  renderBreadcrumbs: ->
    segments = @props.path.split('/')
    return segments.map (s, i) =>
      path = segments.slice(0, i + 1).join('/')
      if i < segments.length - 1
        return (
          <li key={i}>
            {s}
          </li>
        )
      else
        return (
          <li key={i}>
            <strong>
                {s}
            </strong>
          </li>
        )

  renderTasksDropdown: ->
    <div className="btn-group">
      <button type="button" className="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span className="glyphicon glyphicon-tasks"></span> <span className="caret"></span>
      </button>
      <ul className="dropdown-menu">
        {@renderListItems()}
      </ul>
    </div>

  renderListItems: ->
    tasks = _.sortBy(@props.activeTasks, (t) => t.taskId.instanceNo).map (task, i) =>
        taskId = task.id
        <li key={i}>
          <a onClick={() => @props.toggleViewingInstance(taskId)}>
            <span className="glyphicon glyphicon-#{if taskId in @props.viewingInstances then 'check' else 'unchecked'}"></span>
            <span> Instance {task.taskId.instanceNo}</span>
          </a>
        </li>
    if tasks.length > 0
      return tasks
    else
      return <li><a className="disabled">No running instances</a></li>

  renderViewButtons: ->
    if @props.viewingInstances.length > 1
      <div className="btn-group" role="group">
        <button type="button" className="btn btn-sm btn-default no-margin #{if !@props.splitView then 'active'}" onClick={@props.toggleView}>Unified</button>
        <button type="button" className="btn btn-sm btn-default no-margin #{if @props.splitView then 'active'}" onClick={@props.toggleView}>Split</button>
      </div>

  renderColorList: ->
    <div className="btn-group">
      <button type="button" className="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span className="glyphicon glyphicon-adjust"></span> <span className="caret"></span>
      </button>
      <ul className="dropdown-menu">
        <li className={if @props.activeColor is '' then 'active'}>
          <a onClick={() => @props.setLogColor('')}>
            <span>Default</span>
          </a>
        </li>
        <li className={if @props.activeColor is 'midnight' then 'active'}>
          <a onClick={() => @props.setLogColor('midnight')}>
            <span>Midnight</span>
          </a>
        </li>
        <li className={if @props.activeColor is 'solarized' then 'active'}>
          <a onClick={() => @props.setLogColor('solarized')}>
            <span>Solarized</span>
          </a>
        </li>
      </ul>
    </div>

  renderAnchorButtons: ->
    <span>
      <a className="btn btn-default btn-sm tail-bottom-button" onClick={@props.scrollToBottom}>
        <span className="glyphicon glyphicon-chevron-down"></span>
      </a>
      <a className="btn btn-default btn-sm tail-top-button" onClick={@props.scrollToTop}>
        <span className="glyphicon glyphicon-chevron-up"></span>
      </a>
    </span>

  renderSearch: ->
    <div className="btn-group">
      <button id="searchDDToggle" type="button" className="btn btn-#{if @props.search is '' then 'default' else 'info'} btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onClick={@handleSearchToggle}>
        <span className="glyphicon glyphicon-search"></span> <span className="caret"></span>
      </button>
      <ul className="dropdown-menu">
        <li>
          <div className="input-group log-search">
            <input ref="searchInput" type="text" className="form-control" placeholder="Grep Logs" value={@state.searchVal} onChange={@handleSearchChange} onKeyDown={@handleSearchKeyPress} />
            <span className="input-group-btn">
              <button className="btn btn-info no-margin" type="button" onClick={() => @setSearch(@state.searchVal)}><span className="glyphicon glyphicon-search"></span></button>
            </span>
          </div>
        </li>
      </ul>
    </div>

  render: ->
    <div className="tail-header">
      <div className="row">
        <div className="col-md-3">
          <ul className="breadcrumb breadcrumb-request">
            <li>
              Request&nbsp;
              <a href="#{config.appRoot}/request/#{@props.requestId}">
                {@props.requestId}
              </a>
            </li>
          </ul>
        </div>
        <div className="col-md-6">
          <ul className="breadcrumb">
            {@renderBreadcrumbs()}
          </ul>
        </div>
        <div className="col-md-3 hidden-xs tail-buttons">
          {@renderSearch()}
          {@renderTasksDropdown()}
          {@renderColorList()}
          {@renderViewButtons()}
          {@renderAnchorButtons()}
        </div>
      </div>
    </div>

module.exports = Header